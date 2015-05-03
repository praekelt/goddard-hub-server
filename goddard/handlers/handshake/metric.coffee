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
		app.get('models').nodes.find(1 * nodeid).then((node_obj) =>

			# did we find it ?
			if node_obj

				# get the metric objs
				app.get('services').metric.parse req.body, (err, metric_obj) =>

					# update the last ping
					app.get('services').metric.updateLastPing node_obj, metric_obj, (err) =>

						# check for warnings
						app.get('services').metric.check node_obj, metric_obj, (err, warnings) =>

							try
								# get the public obj
								node_obj = node_obj.get()
							catch e
								# nothing

							# update the metrics
							app.get('services').metric.addSystemInfo node_obj, metric_obj, (err) =>
								app.get('services').metric.addDeviceInfo node_obj, metric_obj, (err) =>
									app.get('services').metric.saveHosts node_obj, metric_obj, (err) =>

										# respond done
										res.json { status: 'ok' }

			else 
				res.json {status: 'error',message: 'No such node with that id was found registered ...'}

		).catch (err) ->
			console.dir err
			res.json {

				status: 'error',
				message: 'Problem looking for the node by it\'s ID'

			}