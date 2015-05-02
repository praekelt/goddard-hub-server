# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# modules
	_ = require('underscore')

	# the homepage for load balancer
	app.get '/groups/:groupid', app.get('middleware').checkLoggedIn, (req, res) -> 

		# get all the groups
		app.get('models').apps.findAll().then (app_objs) ->

			app.get('models').groups.find(req.params.groupid).then((item_obj) ->
				if not item_obj
					res.redirect '/groups'
					return

				item_obj.getApps().then (item_app_objs) ->

					item_obj = item_obj.get()
					res.render 'groups/view', {

						title: item_obj.name,
						item_obj: item_obj,
						app_objs: app_objs,
						item_app_objs: item_app_objs,
						registered_app_ids: _.pluck(item_app_objs, 'id')

					}
			)

	# the homepage for load balancer
	app.post '/groups/:groupid', app.get('middleware').checkLoggedIn, (req, res) -> 

		app.get('models').groups.find(req.params.groupid).then((item_obj) ->
			if not item_obj
				res.redirect '/groups'
				return

			item_obj.name = req.body.name
			item_obj.description = req.body.description
			item_obj.save().then -> 

				# run a build against the node
				group_obj = item_obj.get()

				# create a build
				app.get('services').build.create group_obj.key, (err, build_obj) ->

					# and ... ?
					console.log 'build reported back and running now'

					# start the actual build
					app.get('services').build.run(build_obj, ->
						console.log('build done ...')
					)

				# redirect to group
				res.redirect '/groups'
		)