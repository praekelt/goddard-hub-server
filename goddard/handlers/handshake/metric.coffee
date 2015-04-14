# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# require the modules
	_ 			= require('underscore')

	# handle any metric coming our way
	app.post '/metric.json', (req, res) ->

		console.dir req.body

		# get the passed name / value / nodeid
		nodeid 		= req.body.nodeid

		# find the node by that id
		app.get('models').nodes.find(1 * nodeid).then((node_obj) ->

				# did we find it ?
				if node_obj

					# Update out last ping
					node_obj.lastping = new Date()
					node_obj.save().then ->

						# metrics parsed out
						metric_obj = {}

						# loop all the passed keys of metrics
						for key_str in _.keys(req.body or {})

							# if this is not in our reserved list
							if key_str.toString().toLowerCase() not in [ 'nodeid' ]

								# build our metric value ?
								metric_obj[ (key_str or '').toLowerCase() ] = req.body[ key_str ]

						# save according to our registered params
						app.get('models').systeminfo.create({

								cpus: metric_obj.node.cpus,
								load: metric_obj.node.load,
								uptime: metric_obj.node.uptime,

								totalmem: metric_obj.node.memory.total,
								freemem: metric_obj.node.memory.free,

								totaldisk: metric_obj.node.disk.total,
								freedisk: metric_obj.node.disk.free,
								raid: (metric_obj.node.disk.raid or []).join(' '),

								nodeid: 1 * nodeid

							}).then(->

								# then save the device info
								app.get('models').deviceinfo.create({

									bgan_temp: metric_obj.bgan.temp,
									bgan_ping: metric_obj.bgan.ping,
									bgan_ip: metric_obj.bgan.ip,
									bgan_uptime: metric_obj.bgan.uptime,
									bgan_lat: metric_obj.bgan.lat,
									bgan_lng: metric_obj.bgan.lng,

									router_uptime: metric_obj.router.uptime,
									wireless_uptime: metric_obj.wireless.uptime,

									relays: metric_obj.relays.join(' ')

									nodeid: 1 * nodeid

								}).then(->

									# the port we came up with
									res.json { status: 'ok' }

								)

							)

				else 
					res.json {status: 'error',message: 'No such node with that id was found registered ...'}

		)