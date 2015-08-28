# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# require the modules
	_ 			= require('underscore')

	# handle any metric coming our way
	app.post '/report.json', (req, res) ->

		# check if id was given
		if req.query.uid?

			# save as a log that we can use
			app.get('models').reports.create({

				"nodeId": 1 * req.query.uid,
				"status": req.body.status or req.body.build or null,
				"message": req.body.message or req.body.text or req.body.process or null

			}).then(->

				# done
				res.jsonp { status: 'ok' }

			).catch((err) ->
				console.dir(err)
				res.status(400).jsonp {

					status: 'error',
					message: 'could not create reporting history log entry'

				}
			)

		else

			# output the jsonp status
			res.status(400).jsonp {

				status: 'error',
				message: '?uid={id} is required for the node that this log is for'

			}