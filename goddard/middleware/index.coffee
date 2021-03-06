# loads all the modules and the subdirs for the app
### istanbul ignore next ###
module.exports = exports = (app) ->

	# create middleware object
	app.set('middleware', {})

	# load in our modules
	require('./auth')(app)
	require('./locals')(app)
	require('./pagination')(app)