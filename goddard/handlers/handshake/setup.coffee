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
							server: process.env.TUNNEL_SERVER or 'goddard.io.co.za',
							port: (port + 1),
							mport: (port + 2),
							macaddr: param_mac_addr,
							publickey: param_public_key,

							lat: null,
							lng: null,

							lastping: new Date()

						}

					}).then((returned_values) ->

						# write the key to the autherised hosts
						fs.appendFile '/home/root/.ssh/authorized_keys', param_public_key + '\n', (err) ->

							# write the key to allow access
							console.dir err

							# get a local obj to work with
							node_obj = returned_values[0]
							created = returned_values[1] == true

							# update
							if not node_obj.serial
								node_obj.serial = S(node_obj.id).padLeft(3, '0').s

							# save it
							node_obj.save().then ->

								# get the node
								node_obj = node_obj.get()

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