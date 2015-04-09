# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# required modules
	async = require('async')

	# the homepage for load balancer
	app.get '/apps/create', (req, res) -> 

		# render the create page 
		res.render 'apps/create', {

			title: 'Create a Group'

		}

	# the homepage for load balancer
	app.post '/apps/create', (req, res) -> 

		# get the params
		param_name_str			= req.body.name
		param_description_str	= req.body.description
		param_image_str			= req.body.image

		# output
		group_obj = app.get('models').apps.build({

				name: param_name_str,
				description: param_description_str,
				image: param_image_str

			})

		# run it
		group_obj.save().then -> res.redirect '/apps'
