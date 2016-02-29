# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# required modules
	async = require('async')
	moment = require('moment')
	_ = require('underscore')

	# the homepage for load balancer
	app.get '/nodes', app.get('middleware').checkLoggedIn, app.get('middleware').handlePagination, (req, res) -> 

		# search params
		filter_params = {}

		# was the search given ?
		if req.query.q
			search_param = req.query.q
			filter_params = app.get('sequelize').or(
				{

					serial: { like: '%' + search_param + '%' }

				},
				{

					description: { like: '%' + search_param + '%' }

				})

		if req.query.group and req.query.group not in [ 'all', 'undefined' ]
			if req.query.group == 'none'
				filter_params.groupId = null
			else
				filter_params.groupId = 1 * req.query.group

		# get all the nodes
		app.get('models').nodes.findAndCountAll(

				offset: req.requesting_pagination_offset,
				limit: req.requesting_pagination_limit,
				where: filter_params,
				order: 'id ASC',
				include: app.get('models').groups

			).then (result) ->

				# nodes to send to the view file after processing
				public_node_objs = []

				# handle each of the requests
				handleEachNodeRequets = (node_obj, cb) ->

					# get the item
					item_obj = node_obj.get()

					# get the latest request for each node
					# delete all installs
					app.get('sequelize_instance')
					.query('SELECT * FROM systeminfos where "nodeid"=' + item_obj.id + " ORDER BY id DESC LIMIT 1")
					.then((stat_objs)->

						# get the stats
						if stat_objs[0] and stat_objs[0][0]

							# parse the date
							createdAtObj = moment(stat_objs[0][0].createdAt).toDate()

							# did we find a time ... ?
							if createdAtObj.getTime() == 0

								# nope
								item_obj.nodeStatus = 'unknown'

							else

								# get the time it happened ago in minutes
								minutes_since_update = moment.duration( new Date().getTime() - createdAtObj.getTime(), 'milliseconds').asMinutes()

								# right so do some quick cals
								if (item_obj.warnings or []).length > 0
									item_obj.status = 'warning'
								else if minutes_since_update > 40
									item_obj.status = 'disabled'
								else
									item_obj.status = 'ok'

						else
							item_obj.nodeStatus = 'unknown'

						# add to our list
						public_node_objs.push(item_obj)

						# done
						cb(null)
					)

				# loop each and get all the metrics to use
				async.each result.rows or [], handleEachNodeRequets, ->

					# pseudo sort just to be sure
					public_node_objs = _.sortBy public_node_objs, (item_obj)->return -item_obj.id

					# get all the groups
					app.get('models').groups.findAll().then (group_objs) ->

						# render them out
						res.render 'nodes/list', {

							title: 'Nodes',
							group_objs: group_objs,
							items: public_node_objs,
							limit: 150,
							offset: req.requesting_pagination_offset,
							total_count: result.count,
							current_page: req.requesting_pagination_page,
							pages: Math.ceil( result.count / req.requesting_pagination_limit ),
							selected_group_id: req.query.group

						}