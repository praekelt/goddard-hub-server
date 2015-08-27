# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# require the modules
	_ 			= require('underscore')
	moment 		= require('moment')
	request		= require('request')

	# handle any metric coming our way
	app.post '/metric.json', (req, res) ->

		# get the passed name / value / nodeid
		nodeid 		= req.body.nodeid

		# find the node by that id
		app.get('models').nodes.find(1 * nodeid).then((node_obj) =>

			# did we find it ?
			if node_obj

				# get the metric objs
				app.get('services').metric.parse req.body, (err, metric_obj) =>

					# add in the ip we got this from
					metric_obj.public_ip = req.headers['x-forwarded-for'] or req.connection.remoteAddress or null

					# update the last ping
					# app.get('services').metric.updateLastPing node_obj, metric_obj, (err) =>

					# check for warnings
					app.get('services').metric.check node_obj, metric_obj, (err, warnings) =>

						# if it's empty mark as null
						if not warnings or warnings.length == 0
							node_obj.warnings = null
						else
							# save the metrics
							node_obj.warnings = JSON.stringify(warnings or [])

						# check if this is older than a week ... ?
						time_delta = new Date().getTime() - moment(node_obj.lastping).toDate().getTime()

						# check if older than a week ...
						if process.env.SLACK_NOTIFICATION_URL? and time_delta > (1000 * 60 * 60 * 24 * 7)

							# the name parts
							name_parts = []

							# build name
							if node_obj.name?
								name_parts.push(node_obj.name)
								name_parts.push('(' + node_obj.serial + ')')
							else
								name_parts.push(node_obj.name)


							# send a notification back to Goddard channel
							options = {
								uri: process.env.SLACK_NOTIFICATION_URL,
								method: 'POST',
								timeout: 1000 * 10,
								json: {
									"text": name_parts.join(' ') + ' came back online after more than a week of inactivity. Click <http://hub.goddard.unicore.io/nodes/' + node_obj.id + '|here> to have a look'
								}
							}

							# send the rquest 
							request options, (error, response, body) ->

								# done !
								console.log('done')


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
								app.get('services').metric.addDeviceInfo node_obj, metric_obj, (err) =>
									app.get('services').metric.saveHosts node_obj, metric_obj, (err) =>

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