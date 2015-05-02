# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# required modules
	async = require('async')
	S = require('string')

	# the homepage for load balancer
	app.get '/apps/create', (req, res) -> 

		# render the create page 
		res.render 'apps/create', {

			title: 'Create a Group'

		}

	# the homepage for load balancer
	app.post '/apps/create', (req, res) -> 

		# get the params
		param_name_str				= req.body.name
		param_description_str		= req.body.description
		param_key_str				= req.body.key
		param_visible_str			= req.body.visible
		param_portal_str			= req.body.portal

		# output
		group_obj = app.get('models').apps.build({

				name: param_name_str,
				description: param_description_str,
				key: param_key_str,
				visible: param_visible_str == '1',
				portal: param_portal_str == '1',
				slug: S(param_name_str).slugify().s

			})

		# run it
		group_obj.save().then -> res.redirect '/apps'
