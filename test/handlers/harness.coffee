GLOBAL.app = null

module.exports = exports = (fn) ->

	# return the global app
	if GLOBAL.app

		# perform a sync
		GLOBAL.app.get('sequelize_instance')
		.sync({ sync: true })
		.then(-> fn(GLOBAL.app))
		.catch((err) -> console.dir(err))

	else

		# update it, create the http server
		app = require('../../goddard/httpd')

		# connect and setup database
		require('../../goddard/schema')(app)
		require('../../goddard/services')(app)
		require('../../goddard/middleware')(app)
		require('../../goddard/handlers')(app)

		# set the global app
		GLOBAL.app = app

		# output the amount
		app.get('sequelize_instance')
		.sync({ sync: true })
		.then(-> fn(app))
		.catch((err) -> console.dir(err))