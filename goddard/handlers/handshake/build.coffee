# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# require the modules
	_ 			= require('underscore')
	fs 			= require('fs')

	# handle any metric coming our way
	app.all '/build.json', (req, res) ->

		# write out the lock file so the builds can happen
		fs.writeFileSync(process.env.WEBHOOKFILE or '/var/goddard/builds/webhook.txt', '' + new Date().getTime())

		# output as build happens async
		res.json {

			status: 'ok'

		}