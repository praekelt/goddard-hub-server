# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# required modules
	Sequelize 			= require('sequelize')

	# dicts of models
	Models = {}


	# if testing we switch to SQLite
	if process.env.NODE_ENV == 'testing'

		# handle the uuid
		uuid = require('uuid')

		# connect to the database
		sequelize = new Sequelize( uuid.v1(), '', '', {

			logging: false,
			dialect: 'sqlite'

		})

	else

		# connect to the database
		sequelize = new Sequelize(process.env.DB_URL, {

			logging: false

		})

	# set as variable
	app.set('database', sequelize)

	# set the models
	Models.tokens = sequelize.define('tokens', {

		name: { type: Sequelize.STRING(255), field: 'name' },
		key: { type: Sequelize.STRING(255), field: 'key' }

	})

	# set the models
	Models.reports = sequelize.define('reports', {

		nodeId: { type: Sequelize.INTEGER, field: 'nodeId' }
		status: { type: Sequelize.STRING(255), field: 'status' }
		message: { type: Sequelize.STRING(255), field: 'message' }

	})

	# set the models
	Models.groups = sequelize.define('groups', {

		name: { type: Sequelize.STRING(255), field: 'name' }
		key: { type: Sequelize.STRING(255), field: 'key' }
		description: { type: Sequelize.STRING(255), field: 'description' }

	})

	# set the models
	Models.node_dashboard_macs = sequelize.define('node_dashboard_macs', {

		nodeId: { type: Sequelize.INTEGER, field: 'nodeId' }
		h1: { type: Sequelize.INTEGER, field: 'h1' }
		h24: { type: Sequelize.INTEGER, field: 'h24' }
		h48: { type: Sequelize.INTEGER, field: 'h48' }
		d7: { type: Sequelize.INTEGER, field: 'd7' }
		d31: { type: Sequelize.INTEGER, field: 'd31' }
		d365: { type: Sequelize.INTEGER, field: 'd365' }
		allTime: { type: Sequelize.INTEGER, field: 'allTime' }
		timestamp: { type: Sequelize.DATE, field: 'timestamp' }

	})

	# set the models
	Models.node_dashboard_page_view = sequelize.define('node_dashboard_page_view', {

		nodeId: { type: Sequelize.INTEGER, field: 'nodeId' }
		appId: { type: Sequelize.INTEGER, field: 'appId' }
		h1: { type: Sequelize.INTEGER, field: 'h1' }
		h24: { type: Sequelize.INTEGER, field: 'h24' }
		h48: { type: Sequelize.INTEGER, field: 'h48' }
		d7: { type: Sequelize.INTEGER, field: 'd7' }
		d31: { type: Sequelize.INTEGER, field: 'd31' }
		d365: { type: Sequelize.INTEGER, field: 'd365' }
		allTime: { type: Sequelize.INTEGER, field: 'allTime' }
		timestamp: { type: Sequelize.DATE, field: 'timestamp' }

	})

	# set the models
	Models.node_access = sequelize.define('node_access', {

		nodeId: { type: Sequelize.INTEGER, field: 'nodeId' }
		appId: { type: Sequelize.INTEGER, field: 'appId' }
		hourLoggedAt: { type: Sequelize.DATE, field: 'hourLoggedAt' }
		pagesServed: { type: Sequelize.INTEGER, field: 'pagesServed' }

	})

	# set the models
	Models.node_mac_access = sequelize.define('node_mac_access', {

		nodeId: { type: Sequelize.INTEGER, field: 'nodeId' }
		hourLoggedAt: { type: Sequelize.DATE, field: 'hourLoggedAt' }
		macaddr: { type: Sequelize.STRING(255), field: 'macaddr' }
		ip: { type: Sequelize.STRING(255), field: 'ip' }

	})

	# set the models
	Models.logs = sequelize.define('logs', {

		buildId: { type: Sequelize.INTEGER, field: 'buildId' }
		nodeId: { type: Sequelize.INTEGER, field: 'nodeId' }
		ok: { type: Sequelize.INTEGER, field: 'source' }
		changed: { type: Sequelize.INTEGER, field: 'source' }
		unreachable: { type: Sequelize.INTEGER, field: 'source' }
		failure: { type: Sequelize.INTEGER, field: 'source' }

	})

	# set the models
	Models.builds = sequelize.define('builds', {

		target: { type: Sequelize.STRING(255), field: 'target' }
		source: { type: Sequelize.STRING(255), field: 'source' }
		status: { type: Sequelize.INTEGER, field: 'status' }
		output: { type: Sequelize.TEXT, field: 'output' }

	})

	# set the models
	Models.apps = sequelize.define('apps', {

		name: { type: Sequelize.STRING(255), field: 'name' }
		key: { type: Sequelize.STRING(255), field: 'key' }
		description: { type: Sequelize.TEXT, field: 'description' }
		slug: { type: Sequelize.STRING(255), field: 'slug' }
		visible: { type: Sequelize.BOOLEAN, field: 'visible' }
		portal: { type: Sequelize.BOOLEAN, field: 'portal' }
		docker_command: { type: Sequelize.STRING(255), field: 'docker_command' }
		
	})

	# setup the apps
	Models.apps.hasMany(Models.groups, {as: 'Groups', through: 'installs',unique: false})
	Models.groups.hasMany(Models.apps, {as: 'Apps',through: 'installs',unique: false})

	# set the models
	Models.nodes = sequelize.define('nodes', {

		serial: { type: Sequelize.STRING(255), field: 'serial' }
		server: { type: Sequelize.STRING(255), field: 'server' }
		country: { type: Sequelize.STRING(255), field: 'country' }
		region: { type: Sequelize.STRING(255), field: 'region' }
		city: { type: Sequelize.STRING(255), field: 'city' }
		address: { type: Sequelize.STRING(255), field: 'address' }
		name: { type: Sequelize.STRING(255), field: 'name' }
		description: { type: Sequelize.STRING(255), field: 'description' }
		warnings: { type: Sequelize.STRING(255), field: 'warnings' }
		comments: { type: Sequelize.TEXT, field: 'comments' }
		port: { type: Sequelize.INTEGER, field: 'port' }
		mport: { type: Sequelize.INTEGER, field: 'mport' },
		macaddr: { type: Sequelize.STRING(255), field: 'macaddr' },
		publickey: { type: Sequelize.TEXT, field: 'publickey' }
		lat: { type: Sequelize.FLOAT, field: 'lat' }
		lng: { type: Sequelize.FLOAT, field: 'lng' }
		lastping: { type: Sequelize.DATE, field: 'lastping' }
		enabled: { type: Sequelize.BOOLEAN, field: 'enabled' }

	})

	# setup the apps
	Models.nodes.belongsTo(Models.groups)
	Models.groups.hasMany(Models.nodes, {as: 'Nodes',unique: false})

	# setup joins
	# Models.nodes.hasOne(Models.groups, { as: 'group' })
	Models.groups.hasMany(Models.nodes, {as: 'Nodes'})

	# set the models
	Models.systeminfo = sequelize.define('systeminfo', {

		nodeid: { type: Sequelize.INTEGER, field: 'nodeid' },
		load: { type: Sequelize.STRING(64), field: 'load' },
		cpus: { type: Sequelize.INTEGER, field: 'cpus' },
		totaldisk: { type: Sequelize.FLOAT, field: 'totaldisk' },
		freedisk: { type: Sequelize.FLOAT, field: 'freedisk' },
		totalmem: { type: Sequelize.FLOAT, field: 'totalmem' },
		freemem: { type: Sequelize.FLOAT, field: 'freemem' },
		raid: { type: Sequelize.STRING(64), field: 'raid' },
		uptime: { type: Sequelize.FLOAT, field: 'uptime' }

	})

	# set the models
	Models.deviceinfo = sequelize.define('networkinfo', {

		nodeid: { type: Sequelize.INTEGER, field: 'nodeid' },
		mac: { type: Sequelize.INTEGER, field: 'mac' },
		ip: { type: Sequelize.STRING(255), field: 'ip' },
		useragent: { type: Sequelize.INTEGER, field: 'useragent' },
		timestamp: { type: Sequelize.INTEGER, field: 'timestamp' }

	})

	# set the models
	Models.deviceinfo = sequelize.define('deviceinfo', {

		nodeid: { type: Sequelize.INTEGER, field: 'nodeid' },
		bgan_temp: { type: Sequelize.INTEGER, field: 'bgan_temp' },
		bgan_ping: { type: Sequelize.INTEGER, field: 'bgan_ping' },
		bgan_ip: { type: Sequelize.STRING(255), field: 'bgan_ip' },
		bgan_public_ip: { type: Sequelize.STRING(255), field: 'bgan_public_ip' },
		bgan_lat: { type: Sequelize.FLOAT, field: 'bgan_lat' },
		bgan_lng: { type: Sequelize.FLOAT, field: 'bgan_lng' },
		bgan_uptime: { type: Sequelize.FLOAT, field: 'bgan_uptime' },
		bgan_signal: { type: Sequelize.FLOAT, field: 'bgan_signal' },
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

	# set the models
	Models.whitelist = sequelize.define('whitelist', {

		name: { type: Sequelize.STRING(255), field: 'name' },
		domain: { type: Sequelize.STRING(255), field: 'domain' }

	})

	# setup relationships
	Models.whitelist.belongsTo(Models.groups)

	# create our schema
	app.set('models', Models)
	app.set('sequelize', Sequelize)
	app.set('sequelize_instance', sequelize)
