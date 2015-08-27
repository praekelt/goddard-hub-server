# loads all the modules and the subdirs for the app
### istanbul ignore next ###
module.exports = exports = (app) ->

	# load in our modules
	require('./connect')(app)
	require('./login')(app)
	require('./logout')(app)