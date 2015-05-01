# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# require the modules
	_ 			= require('underscore')

	# handle any metric coming our way
	app.get '/build.json', (req, res) ->

		# get the params
		param_target_str = req.query.target

		# try to start a build
		app.get('services').build.create param_target_str, (err, build_obj) ->

			# error ?
			if err or not build_obj
				res.json {

					status: 'error',
					message: 'Something went wrong'

				}
			else 
				# start the actual build
				app.get('services').build.run(build_obj, ->
					console.log('build done ...')
				)

				# output as build happens async
				res.json {
					status: 'ok'
				}