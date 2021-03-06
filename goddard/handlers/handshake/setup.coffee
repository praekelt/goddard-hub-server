# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# required modules
	fs = require('fs')
	S = require('string')

	# handle the setup
	app.post '/setup.json', (req, res) ->

		# get the params
		param_mac_addr 		= req.body.mac
		param_public_key 	= req.body.key

		# update the

		# create / find a node
		app.get('services').node.find param_mac_addr, param_public_key, (err, node_obj) =>

			# ok so now save the key
			app.get('services').node.saveKey node_obj, param_public_key, (err) =>

				# set the new public key
				node_obj.publickey = param_public_key

				# awesome so update for any missing properties
				app.get('services').node.update node_obj, (err) =>

					# get the node
					node_obj = node_obj.get()

					# format the response to send
					app.get('services').node.formatResponse node_obj, (err, public_response_obj) =>
						
						# get all the items from the whitelist that match that group
						app.get('models').whitelist.findAll({

							where: {

								'groupId': node_obj.groupId

							}

						}).then (whitelist_objs) ->

							# append the whitelist
							public_response_obj.whitelist = []

							# output
							for whitelist_obj in whitelist_objs

								# get the values
								parsed_whitelist_obj = null

								# try to get values
								try
									parsed_whitelist_obj = whitelist_obj.dataValues
								catch e
									# ignored ...
									continue

								# handle the dir
								public_response_obj.whitelist.push({

									name: parsed_whitelist_obj.name,
									domain: parsed_whitelist_obj.domain

								})

							# output
							res.json public_response_obj

						.catch (err) -> 
							console.dir(err)
							res.json { status: 'error', message: 'Something went wrong ...' }
