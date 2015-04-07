# required modules
Sequelize = require('sequelize');

# create the http server
app = require('./httpd')

# connect and setup database
require('./schema')(app)
require('./services')(app)

# load in all the handlers
require('./middleware')(app)
require('./handlers')(app)

# start the web app
app.listen process.env.PORT or 4000, ->

	# just output that the web server is running
	console.log 'Running on port ' + (process.env.PORT or 4000)