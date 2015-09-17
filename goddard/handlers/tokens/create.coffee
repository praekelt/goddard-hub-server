# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# required modules
	async = require('async')
	S = require('string')
	fs = require('fs')
	uuid = require('node-uuid')

	# the homepage for load balancer
	app.get '/tokens/create', (req, res) -> 

		# render the create page 
		res.render 'tokens/create', {

			title: 'Create a Token'

		}

	# the homepage for load balancer
	app.post '/tokens/create', (req, res) -> 

		# get the params
		param_name_str				= req.body.name

		# output
		group_obj = app.get('models').tokens.build({

				name: param_name_str,
				key: uuid.v4()

			})

		# run it
		group_obj.save().then -> res.redirect '/tokens'
