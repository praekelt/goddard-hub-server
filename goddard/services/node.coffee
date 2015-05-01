# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# pull in required modules
	S 				= require('string')
	exec 			= require('child_process').exec

	# start the Nodes service
	Nodes = {}

	# returns the next available port to use
	Nodes.getNextTunnelPort = (fn) ->

		# get the highest ports
		app.get('models').nodes.max('port').then((port) ->

			# check the port
			if port
				if port < 15000
					port = port + 15000
			else
				port = 15000

			# done
			fn(null, port)

		).catch(fn)

	# returns a nicely formatted response for the handshake client
	Nodes.formatResponse = (node_obj, fn) ->

		# read in the public key from environ
		param_public_key = process.env.NODE_PUBLIC_KEY or ''

		# output
		fn null, {

			'name': node_obj.name,
			'serial': S( node_obj.id ).padLeft(5, '0').s,
			'port': {

				'tunnel': node_obj.port,
				'monitor': node_obj.mport

			},
			'uid': node_obj.id,
			'server': node_obj.server,
			'publickey': param_public_key

		}

	# loads in the key if the key has changed
	Nodes.saveKey = (node_obj, param_public_key, fn) ->

		# check if we match ..
		if '' + node_obj.publickey != '' + param_public_key

			# write the key to the autherised hosts
			fs.appendFile '/home/node/.ssh/authorized_keys', param_public_key + '\n', (err) ->

				# handle the error
				if err
					fn(err)
					console.log 'saving key error:'
					console.dir(err)
				else

					# cool so save that
					# node_obj.publickey = param_public_key

					# just continue now
					fn()

		else fn()

	# updates with the existing nodes. Ensures that serial 
	# and all missing fields are present
	Nodes.update = (node_obj, fn) ->

		# update
		if not node_obj.serial
			node_obj.serial = S(node_obj.id).padLeft(4, '0').s

		# save it
		node_obj.save().then(->

			# return the node
			fn(null, node_obj)

		).catch(fn)

	# Nodess the path to run
	Nodes.find = (param_mac_addr, param_public_key, fn) ->

		# get the next
		Nodes.getNextTunnelPort (err, port) ->

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

					# get a local obj to work with
					node_obj = returned_values[0]
					created = returned_values[1] == true

					# return the settings
					fn(null, node_obj)

				).catch(fn)

	# expose it
	return Nodes