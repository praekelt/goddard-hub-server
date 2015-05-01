# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# load in our modules
	app.set('services', {

			build: require('./build')(app),
			node: require('./node')(app),
			metric: require('./metric')(app)

		})