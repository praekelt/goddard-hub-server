# loads all the modules and the subdirs for the app
### istanbul ignore next ###
module.exports = exports = (app) ->

	# load in our modules
	require('./list')(app)
	require('./create')(app)
	require('./view')(app)
	require('./remove')(app)