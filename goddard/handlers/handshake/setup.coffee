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

		# read our key file
		fs.readFile './public.key', (err, key_str) ->

			# get the highest ports
			app.get('models').nodes.max('port').then((port) ->

				# check the port
				if port
					if port < 15000
						port = port + 15000
				else
					port = 15000

				# create the node if it doesn't exist
				app.get('models').nodes.findOrCreate({

						where: {

							macaddr: param_mac_addr

						}, 
						defaults: {

							serial: '',
							groups: [],
							server: 'tunnel1.goddard.com',
							port: (port + 1),
							mport: (port + 2),
							macaddr: param_mac_addr,
							publickey: param_public_key,

							lat: null,
							lng: null,

							lastping: new Date()

						}

					}).then((returned_values) ->

						# get a local obj to work with
						node_obj = returned_values[0].dataValues
						created = returned_values[1] == true

						# output
						res.json {

							'name': node_obj.name,
							'serial': S( node_obj.id ).padLeft(5, '0').s,
							'port': {

								'tunnel': node_obj.port,
								'monitor': node_obj.mport

							},
							'uid': node_obj.id,
							'server': node_obj.server,
							'publickey': key_str.toString()

						}
				)

			)