# loads all the modules and the subdirs for the app
### istanbul ignore next ###
module.exports = exports = (app) ->

	# load in our modules
	require('./setup')(app)
	require('./metric')(app)
	require('./build')(app)
	require('./apps')(app)
	require('./reports')(app)