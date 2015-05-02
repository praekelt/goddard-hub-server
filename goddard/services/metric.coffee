# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# pull in required modules
	_ 				= require('underscore')

	# start the Metric service
	Metric = {}

	# Checks for warnings
	Metric.check = (node_obj, metric_obj, fn) ->

		# errors to save
		warning_strs = []

		# handle it
		if metric_obj.bgan

			# check the temp
			if metric_obj.bgan.temp
				if metric_obj.bgan.temp > 50
					warning_strs.push "BGAN temperature seems high at " + metric_obj.bgan.temp "C"
			else
				warning_strs.push "BGAN temperature is missing, presuming bad."

			# check the temp
			if metric_obj.bgan.signal
				if metric_obj.bgan.signal < 30
					warning_strs.push "BGAN signal is very low at " + metric_obj.bgan.signal
			else
				warning_strs.push "BGAN signal is missing, presuming bad."

		else
			warning_strs.push "BGAN doesn't seem to be connected."

		# check the system
		if metric_obj.node
			# check disk
			if metric_obj.node.memory
				if metric_obj.node.memory
					if metric_obj.node.memory.free <= 1024*1000*1000
						warning_strs.push "Disk space on node is 1GB or under"
				else
					warning_strs.push "Node did not report back on free disk space"
			else
				warning_strs.push "Node did not report back on disk information"

			# check disk
			if metric_obj.node.load
				if metric_obj.node.load
					try
						if 1 * metric_obj.node.load.split(' ')[0] >= 2
							warning_strs.push "System load was over 2 for the last 5 minutes"
					catch e
						# nothing ..
			else
				warning_strs.push "Node did not report back on system load"

			# check disk
			if metric_obj.node.disk
				if metric_obj.node.disk
					if metric_obj.node.disk.free <= 10000
						warning_strs.push "Disk space on node is 10GB or under"
				else
					warning_strs.push "Node did not report back on free disk space"
			else
				warning_strs.push "Node did not report back on disk information"
		else
			warning_strs.push "Node didn't report back any data."

		# update with warnings
		node_obj.warnings = warning_strs
		node_obj.save().then(->fn(null, warning_strs)).catch(fn)

	# updates the last ping of a node
	Metric.addDeviceInfo = (node_obj, metric_obj, fn) ->

		# then save the device info
		app.get('models').deviceinfo.create({

			bgan_temp: metric_obj.bgan.temp,
			bgan_ping: metric_obj.bgan.ping,
			bgan_uptime: metric_obj.bgan.uptime,
			bgan_lat: metric_obj.bgan.lat,
			bgan_lng: metric_obj.bgan.lng,
			bgan_signal: metric_obj.bgan.signal,

			router_uptime: metric_obj.router.uptime,
			wireless_uptime: metric_obj.wireless.uptime,

			relays: metric_obj.relays.join(' ')

			nodeid: node_obj.id

			}).then(->

				# update it
				fn(null)

			).catch(fn)

	# updates the last ping of a node
	Metric.addSystemInfo = (node_obj, metric_obj, fn) ->

		# save according to our registered params
		app.get('models').systeminfo.create({

				cpus: metric_obj.node.cpus,
				load: metric_obj.node.load,
				uptime: metric_obj.node.uptime,

				totalmem: metric_obj.node.memory.total,
				freemem: metric_obj.node.memory.free,

				totaldisk: metric_obj.node.disk.total,
				freedisk: metric_obj.node.disk.free,
				raid: (metric_obj.node.disk.raid or []).join(' '),

				nodeid: node_obj.id

			}).then(->

				# update it
				fn(null)

			).catch(fn)

	# updates the last ping of a node
	Metric.updateLastPing = (node_obj, metric_obj, fn) ->

		# update the ndoe
		node_obj.lastping = new Date()
		if metric_obj.bgan
			node_obj.lat = metric_obj.bgan.lat
			node_obj.lng = metric_obj.bgan.lng

		# save the details
		node_obj.save().then(->fn(null, node_obj)).catch(fn)

	# Metrics the path to run
	Metric.parse = (body_params, fn) ->

		# metrics parsed out
		metric_obj = {}

		# loop all the passed keys of metrics
		for key_str in _.keys(body_params or {})

			# if this is not in our reserved list
			if key_str.toString().toLowerCase() not in [ 'nodeid' ]

				# build our metric value ?
				metric_obj[ (key_str or '').toLowerCase() ] = body_params[ key_str ]

		# done
		fn null, metric_obj

	# expose it
	return Metric