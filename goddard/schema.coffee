# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# required modules
	Sequelize 			= require('sequelize')

	# dicts of models
	Models = {}

	# connect to the database
	sequelize = new Sequelize(process.env.DB_URL)

	# set as variable
	app.set('database', sequelize)

	# set the models
	Models.groups = sequelize.define('groups', {

		name: { type: Sequelize.STRING(255), field: 'name' }
		description: { type: Sequelize.STRING(255), field: 'description' }

	})

	# set the models
	Models.apps = sequelize.define('apps', {

		name: { type: Sequelize.STRING(255), field: 'name' }
		image: { type: Sequelize.STRING(255), field: 'image' }
		description: { type: Sequelize.STRING(255), field: 'description' }

	})

	# set the models
	Models.installs = sequelize.define('installs', {

		groupid: { type: Sequelize.INTEGER, field: 'groupid' },
		appid: { type: Sequelize.INTEGER, field: 'appid' },

	})

	# set the models
	Models.nodes = sequelize.define('nodes', {

		serial: { type: Sequelize.STRING(255), field: 'serial' }
		group: { type: Sequelize.INTEGER , field: 'group' }
		server: { type: Sequelize.STRING(255), field: 'server' }
		country: { type: Sequelize.STRING(255), field: 'country' }
		region: { type: Sequelize.STRING(255), field: 'region' }
		city: { type: Sequelize.STRING(255), field: 'city' }
		address: { type: Sequelize.STRING(255), field: 'address' }
		description: { type: Sequelize.STRING(255), field: 'description' }
		status: { type: Sequelize.STRING(32), field: 'status' }
		comments: { type: Sequelize.TEXT, field: 'comments' }
		port: { type: Sequelize.INTEGER, field: 'port' }
		mport: { type: Sequelize.INTEGER, field: 'mport' },
		macaddr: { type: Sequelize.STRING(255), field: 'macaddr' },
		publickey: { type: Sequelize.TEXT, field: 'publickey' }
		lat: { type: Sequelize.FLOAT, field: 'lat' }
		lng: { type: Sequelize.FLOAT, field: 'lng' }
		lastping: { type: Sequelize.DATE, field: 'lastping' }

	})

	# set the models
	Models.systeminfo = sequelize.define('systeminfo', {

		nodeid: { type: Sequelize.INTEGER, field: 'nodeid' },
		load: { type: Sequelize.STRING(32), field: 'load' },
		cpus: { type: Sequelize.INTEGER, field: 'cpus' },
		totaldisk: { type: Sequelize.FLOAT, field: 'totaldisk' },
		freedisk: { type: Sequelize.FLOAT, field: 'freedisk' },
		totalmem: { type: Sequelize.FLOAT, field: 'totalmem' },
		freemem: { type: Sequelize.FLOAT, field: 'freemem' },
		raid: { type: Sequelize.STRING(32), field: 'raid' },
		uptime: { type: Sequelize.FLOAT, field: 'uptime' }

	})

	# set the models
	Models.deviceinfo = sequelize.define('deviceinfo', {

		nodeid: { type: Sequelize.INTEGER, field: 'nodeid' },
		bgan_temp: { type: Sequelize.INTEGER, field: 'bgan_temp' },
		bgan_ping: { type: Sequelize.INTEGER, field: 'bgan_ping' },
		bgan_ip: { type: Sequelize.INTEGER, field: 'bgan_ip' },
		bgan_lat: { type: Sequelize.INTEGER, field: 'bgan_lat' },
		bgan_lng: { type: Sequelize.INTEGER, field: 'bgan_lng' },
		bgan_uptime: { type: Sequelize.FLOAT, field: 'bgan_uptime' },
		router_uptime: { type: Sequelize.FLOAT, field: 'mikrotik_uptime' },
		wireless_uptime: { type: Sequelize.FLOAT, field: 'mikrotik_uptime' },
		relays: { type: Sequelize.STRING(64), field: 'relays' }

	})

	# set the models
	Models.users = sequelize.define('users', {

		provider: { type: Sequelize.STRING(32), field: 'provider' },
		uid: { type: Sequelize.STRING(128), field: 'uid' },
		name: { type: Sequelize.STRING(255), field: 'name' },
		email: { type: Sequelize.STRING(255), field: 'email' },
		avatar: { type: Sequelize.STRING(255), field: 'avatar' },
		enabled: { type: Sequelize.BOOLEAN, field: 'enabled' },
		admin: { type: Sequelize.BOOLEAN, field: 'admin' },
		lastLogin: { type: Sequelize.DATE, field: 'lastLogin' }

	})

	# sync all the tables
	# sequelize.sync()

	# create our schema 
	app.set('models', Models)
	app.set('sequelize', Sequelize)
