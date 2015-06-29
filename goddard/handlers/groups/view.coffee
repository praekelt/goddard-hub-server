# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# modules
	_ = require('underscore')
	async = require('async')

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

		# get the params
		param_name_str			= req.body.name
		param_key_str			= req.body.key
		param_description_str	= req.body.description
		param_application_strs 		= req.body.applications

		app.get('models').groups.find(req.params.groupid).then((item_obj) ->

			console.dir item_obj

			if not item_obj
				res.redirect '/groups'
				return

			# get the group
			group_obj = item_obj.get()

			item_obj.name = param_name_str
			item_obj.key = param_key_str
			item_obj.description = param_description_str
			item_obj.save().then -> 

				# delete all installs
				app.get('sequelize_instance')
				.query("DELETE FROM installs WHERE \"groupId\"=" + group_obj.id)
				.then(->

					# handles the actual saving of the application
					handleSavingApp = (app_id_str, cb) ->

						# get that app
						app.get('models').apps.find( 1 * app_id_str ).then (app_obj) ->

							# create and save it
							item_obj.addApp(app_obj)

							# done
							cb(null)

					# loop and save
					async.each param_application_strs or [], handleSavingApp, (err) ->

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
		)