# loads all the modules and the subdirs for the app
### istanbul ignore next ###
module.exports = exports = (app) ->

	# load in our modules
	require('./home')(app)
	require('./downloads')(app)
	require('./handshake')(app)
	require('./auth')(app)
	require('./users')(app)
	require('./nodes')(app)
	require('./groups')(app)
	require('./apps')(app)