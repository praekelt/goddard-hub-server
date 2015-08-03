# loads all the modules and the subdirs for the app
### istanbul ignore next ###
module.exports = exports = (app) ->

	# require the modules
	_ 			= require('underscore')

	# handle any metric coming our way
	app.get '/build.json', (req, res) ->

		# output as build happens async
		res.json {
			status: 'ok'
		}