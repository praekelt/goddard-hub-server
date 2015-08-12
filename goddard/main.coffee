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

# before we start the web server, listen for migration commands

# load in the argv's passed
argv = require('minimist')(process.argv.slice(2));

# should we run the migrations ?
### istanbul ignore if ###
### istanbul ignore else ###
if argv.migrations == true

	# run the migrations
	app.get('sequelize_instance').sync({})

	# should we seed ?
	if argv.seed == true
		app.get('models').groups.create({

			id:1, 
			name:'Default', 
			description:'Default group',
			key: 'default'
		
		}, null, {validate: false})
		.catch(->)
		app.get('models').apps.create({

			id:1, 
			name:'Captive Portal', 
			description:'The default captive portal for the Goddard platform.',
			key: 'captiveportal',
			slug: 'captive-portal',
			visible: false,
			portal: true

		}, null, {validate: false})
		.catch(->)
		app.get('models').apps.create({

			id:2, 
			name:'MAMA', 
			description:'The Mobile Alliance for Maternal Action (MAMA) is a global movement that seeks to use mobile technologies to improve the health and lives of mothers in developing nations.',
			key: 'mama',
			slug: 'mama',
			visible: true,
			portal: false

		}, null, {validate: false})
		.catch(->)
		app.get('sequelize_instance')
		.query('INSERT INTO installs(id, "groupId", "appId", "createdAt", "updatedAt") VALUES(1,1,1,now(),now())')
		.catch(->)
		app.get('sequelize_instance')
		.query('INSERT INTO installs(id, "groupId", "appId", "createdAt", "updatedAt") VALUES(1,1,2,now(),now())')
		.catch(->)
		
		# debug output
		console.log('database was synced up')

	# done
	process.exit(0)

else

	# start the web app
	app.listen process.env.PORT or 4000, ->

		# just output that the web server is running
		console.log 'Running on port ' + (process.env.PORT or 4000)