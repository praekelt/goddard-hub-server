# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# required modules
	async = require('async')
	S = require('string')
	fs = require('fs')
	uuid = require('node-uuid')

	# the homepage for load balancer
	app.get '/whitelist/create', (req, res) -> 

		# get all the groups
		app.get('models').groups.findAll().then (group_objs) ->

			# render the create page 
			res.render 'whitelist/create', {

				title: 'Create a Whitelist Item',
				group_objs: group_objs

			}

	# the homepage for load balancer
	app.post '/whitelist/create', (req, res) -> 

		# get the params
		param_name_str      = req.body.name
		param_domain_str    = req.body.domain
		param_group_int     = req.body.group

		# output
		whitelist_obj = app.get('models').whitelist.build({

				name: param_name_str,
				domain: param_domain_str,
				groupId: param_group_int

			})

		# run it
		whitelist_obj.save().then -> res.redirect '/whitelist'