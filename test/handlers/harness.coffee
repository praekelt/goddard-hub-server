module.exports = exports = (fn) ->

	# update it, create the http server
	app = require('../../goddard/httpd')

	# connect and setup database
	require('../../goddard/schema')(app)
	require('../../goddard/services')(app)
	require('../../goddard/middleware')(app)
	require('../../goddard/handlers')(app)

	# output the amount
	app.get('sequelize_instance')
	.sync({ force: true })
	.then(-> fn(app))
	.catch((err) -> console.dir err)