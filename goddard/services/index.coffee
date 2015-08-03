# loads all the modules and the subdirs for the app
### istanbul ignore next ###
module.exports = exports = (app) ->

	# load in our modules
	### istanbul ignore next ###
	app.set('services', {
			
			node: require('./node')(app),
			metric: require('./metric')(app)

		})