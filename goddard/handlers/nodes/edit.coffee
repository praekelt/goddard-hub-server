# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/nodes/:nodeid/edit', app.get('middleware').checkLoggedIn, (req, res) -> 

		app.get('models').nodes.find(req.params.nodeid).then((item_obj) ->
			if not item_obj
				res.redirect '/nodes'
				return

			# get all the groups
			app.get('models').groups.findAll().then (group_objs) ->

				item_obj = item_obj.get()
				res.render 'nodes/edit', {

					title: item_obj.name,
					item_obj: item_obj,
					group_objs: group_objs

				}

		)

	# the homepage for load balancer
	app.post '/nodes/:nodeid/edit', app.get('middleware').checkLoggedIn, (req, res) -> 

		app.get('models').nodes.findById(req.params.nodeid).then((item_obj) ->
			if not item_obj
				res.redirect '/nodes'
				return

			# set it
			group_int = req.body.group

			# get the group
			if req.body.group == 'none'
				group_int = null

			# run a build against the node
			node_obj = item_obj.get()
			app.get('services').build.create node_obj.serial, (err, build_obj) ->

				# and ... ?
				console.log 'build reported back and running now'

				# start the actual build
				app.get('services').build.run(build_obj, ->
					console.log('build done ...')
				)

			item_obj.name = req.body.name
			item_obj.description = req.body.description
			item_obj.enabled = req.body.status == 'enabled'
			item_obj.groupId = group_int
			item_obj.save().then -> res.redirect '/nodes/' + item_obj.get().id

		)