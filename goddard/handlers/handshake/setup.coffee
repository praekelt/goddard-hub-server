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

			console.dir err
			console.dir node_obj

			# ok so now save the key
			app.get('services').node.saveKey node_obj, param_public_key, (err) =>

				# set the new public key
				node_obj.publickey = param_public_key

				# awesome so update for any missing properties
				app.get('services').node.update node_obj, (err) =>

					# did we find the node ... ?
					console.dir err
					console.dir node_obj

					# get the node
					node_obj = node_obj.get()

					# format the response to send
					app.get('services').node.formatResponse node_obj, (err, public_response_obj) =>
							
						# output
						res.json public_response_obj
