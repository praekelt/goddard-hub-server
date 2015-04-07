# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# load in our modules
	require('./home')(app)
	require('./handshake')(app)
	require('./auth')(app)
	require('./nodes')(app)