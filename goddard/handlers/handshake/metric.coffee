# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# require the modules
	_ 			= require('underscore')

	# handle any metric coming our way
	app.post '/metric.json', (req, res) ->

		# get the passed name / value / nodeid
		nodeid 		= req.body.nodeid

		# find the node by that id
		app.get('models').nodes.findById(1 * nodeid).then((node_obj) =>

			# did we find it ?
			if node_obj

				# get the metric objs
				app.get('services').metric.parse req.body, (err, metric_obj) =>

					console.dir metric_obj

					# add in the ip we got this from
					metric_obj.public_ip = req.headers['x-forwarded-for'] or req.connection.remoteAddress or null

					# update the last ping
					# app.get('services').metric.updateLastPing node_obj, metric_obj, (err) =>

					# check for warnings
					app.get('services').metric.check node_obj, metric_obj, (err, warnings) =>

						# save the metrics
						node_obj.warnings = JSON.stringify(warnings or [])

						# update the ndoe
						node_obj.lastping = new Date()
						if metric_obj.bgan
							node_obj.lat = metric_obj.bgan.lat
							node_obj.lng = metric_obj.bgan.lng

						# umm ok
						node_obj.save().then(->

							try
								# get the public obj
								node_obj = node_obj.get()
							catch e
								# nothing

							# update the metrics
							app.get('services').metric.addSystemInfo node_obj, metric_obj, (err) =>
								console.dir(err)
								app.get('services').metric.addDeviceInfo node_obj, metric_obj, (err) =>
									console.dir(err)
									app.get('services').metric.saveHosts node_obj, metric_obj, (err) =>
										console.dir(err)

										# respond done
										res.json { status: 'ok' }

						).catch((err)->
							console.dir(err)
							res.status(400).jsonp({status: 'error',message: 'Something went wrong'})
						)

			else 
				res.json {status: 'error',message: 'No such node with that id was found registered ...'}

		).catch (err) ->
			console.dir err
			res.json {

				status: 'error',
				message: 'Problem looking for the node by it\'s ID'

			}