module.exports = exports = (app) ->

	# required modules
	async = require('async')

	# the homepage for load balancer
	app.get '/whitelist', app.get('middleware').checkLoggedIn, app.get('middleware').handlePagination, (req, res) -> 

		# search params
		filter_params = {}

		# was the search given ?
		if req.query.q
			filter_params = { name: { like: '%' + req.query.q + '%' } }

		# get all the nodes
		app.get('models').whitelist.findAndCountAll(

				offset: req.requesting_pagination_offset,
				limit: req.requesting_pagination_limit,
				where: filter_params

			).then((result) ->

				# get all the groups
				app.get('models').groups.findAll().then (group_objs) ->

					# public items we will be rendering
					public_whitelist_objs = []

					# handles rendering a nice version of whitelist
					renderWhitelist = (raw_whitelist_obj, cb) ->

						# item to pass out to view
						public_whitelist_obj = raw_whitelist_obj.get()

						# get the group of the whitelist
						for group_obj in group_objs

							# the id matches ?
							if group_obj.id == public_whitelist_obj.groupId

								# set as group
								public_whitelist_obj.groupName = group_obj.name
								public_whitelist_obj.groupId = group_obj.id

								# done
								break

						if !public_whitelist_obj.groupName

							# set as group
							public_whitelist_obj.groupName = 'N/A'
							public_whitelist_obj.groupId = null

						# append
						public_whitelist_objs.push(public_whitelist_obj)

						# done
						cb(null)

					# loop them all
					async.each result.rows, renderWhitelist, ->

						# render them out
						res.render 'whitelist/list', {

							title: 'Whitelist',
							description: 'Domains users are allowed to browse',
							items: public_whitelist_objs,
							limit: req.requesting_pagination_limit,
							offset: req.requesting_pagination_offset,
							total_count: result.count,
							current_page: req.requesting_pagination_page,
							pages: Math.ceil( result.count / req.requesting_pagination_limit )

						}

			).catch((err) ->

				# render them out
				res.render 'whitelist/list', {

					title: 'Domains users are allowed to browse',
					items: [],
					limit: req.requesting_pagination_limit,
					offset: req.requesting_pagination_offset,
					total_count: 0,
					current_page: req.requesting_pagination_page,
					pages: 0

				}

			)