# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# required modules
	async = require('async')

	# the homepage for load balancer
	app.get '/groups/create', (req, res) -> 

		# get all the groups
		app.get('models').apps.findAll().then (app_objs) ->

			# render the create page 
			res.render 'groups/create', {

				title: 'Create a Group',
				app_objs: app_objs

			}

	# the homepage for load balancer
	app.post '/groups/create', (req, res) -> 

		# get the params
		param_name_str			= req.body.name
		param_description_str	= req.body.description
		param_application_strs 		= req.body.applications

		# output
		group_obj = app.get('models').groups.build({

				name: param_name_str,
				description: param_description_str

			})

		# handles the actual saving of the application
		handleSavingApp = (app_id_str, cb) ->

			# get that app
			app.get('models').apps.find( 1 * app_id_str ).then (app_obj) ->

				console.dir group_obj.addInstall
				console.dir group_obj.addApp
				console.dir group_obj.addApps

				# create and save it
				group_obj.addApp(app_obj)

				# done
				cb(null)

		# loop and save
		async.each param_application_strs or [], handleSavingApp, (err) ->

			# run it
			group_obj.save().then ->

				# done
				res.redirect '/groups'
