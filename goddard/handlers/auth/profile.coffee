# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# load in our modules
	app.get '/profile', (req, res) ->
		res.send 'profile'