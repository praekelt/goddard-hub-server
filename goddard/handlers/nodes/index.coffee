# loads all the modules and the subdirs for the app
### istanbul ignore next ###
module.exports = exports = (app) ->

	# load in our modules
	require('./list')(app)
	require('./view')(app)
	require('./delete')(app)
	require('./edit')(app)