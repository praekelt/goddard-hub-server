# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# required modules
	async = require('async')

	# the homepage for load balancer
	app.get '/groups/create', (req, res) -> 

		# render the create page 
		res.render 'groups/create', {

			title: 'Create a Group'

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

		# run it
		group_obj.save().then ->

			# handles the actual saving of the application
			handleSavingApp = (app_id_str, cb) ->

				# create and save it
				app.get('models').installs.build({

					appid: 1 * app_id_str,
					groupid: group_obj.id

				}).save().then(cb).catch(cb)

			# loop and save
			async.each param_application_strs, handleSavingApp, (err) ->

				# done
				res.redirect '/groups'
