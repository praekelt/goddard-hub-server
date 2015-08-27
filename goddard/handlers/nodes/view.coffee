# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/nodes/:nodeid', app.get('middleware').checkLoggedIn, (req, res) ->

		# check for the id
		if not req.params.nodeid
			res.redirect('/nodes')
			return

		# find by the given id
		app.get('models').nodes.find(1 * req.params.nodeid).then((obj) ->

			# was it found ?
			if not obj
				res.redirect('/nodes')
				return
			else

				# get a usable item
				item_obj = obj.get()

				# get the metrics
				app.get('models').deviceinfo.findAll({where: { nodeid: item_obj.id },limit: 1,order: '"createdAt" DESC'}).then (deviceinfo_objs) ->

					# did we find any ?
					if deviceinfo_objs and deviceinfo_objs.length > 0
						deviceinfo_objs = deviceinfo_objs[0].dataValues
					else
						deviceinfo_objs = []

					# get the metrics
					app.get('models').systeminfo.findAll({where: { nodeid: item_obj.id },limit: 1,order: '"createdAt" DESC'}).then (systeminfo_objs) ->

						# did we find any ?
						if systeminfo_objs and systeminfo_objs.length > 0
							systeminfo_objs = systeminfo_objs[0].dataValues
						else
							systeminfo_objs = []

						# get the group
						app.get('models').groups.find(1 * obj.groupId).then (group_obj) ->

							if group_obj
								group_obj = group_obj.get()

							# delete all installs
							app.get('sequelize_instance')
							.query('SELECT SUM(h1) as h1, SUM(h24) as h24, SUM(h48) as h48, SUM(d7) as d7, SUM(d31) as d31, SUM(365) as d365 FROM node_dashboard_page_views WHERE "nodeId" = ' + item_obj.id)
							.then((stat_objs)->

								# try to get the stats
								pages_stat_obj = stat_objs[0][0]

								# delete all installs
								app.get('sequelize_instance')
								.query('SELECT SUM(h1) as h1, SUM(h24) as h24, SUM(h48) as h48, SUM(d7) as d7, SUM(d31) as d31, SUM(365) as d365 FROM node_dashboard_macs WHERE "nodeId" = ' + item_obj.id)
								.then((stat_objs)->

									# try to get the stats
									mac_stat_obj = stat_objs[0][0]

									# warnings
									try
										warning_objs = JSON.parse(item_obj.warnings or '[]')
									catch e
										warning_objs = []

									res.render 'nodes/view', {
										title: 'Node #' + item_obj.serial,
										item_obj: item_obj,
										group_obj: group_obj,
										warning_objs: warning_objs,
										metrics: {

											devices: deviceinfo_objs,
											system: systeminfo_objs,
											pages: pages_stat_obj,
											macs: mac_stat_obj

										}
									}

								)

							)
		)