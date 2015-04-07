# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# create middleware object
	app.set('middleware', {})

	# load in our modules
	require('./locals')(app)
	require('./auth')(app)