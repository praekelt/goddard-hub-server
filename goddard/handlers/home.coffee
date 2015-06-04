# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	### istanbul ignore next ###
	app.get '/', app.get('middleware').checkLoggedIn, (req, res) -> 

		# defaults
		node_count_obj = {

			active: 0,
			warning: 0,
			down: 0,
			disabled: 0

		}

		# delete all installs
		app.get('sequelize_instance')
		.query('SELECT SUM(h1) as h1, SUM(h24) as h24, SUM(h48) as h48, SUM(d7) as d7, SUM(d31) as d31, SUM(d365) as d365 FROM node_dashboard_macs')
		.then((stat_objs)->

			# try to get the stats
			mac_stat_obj = stat_objs[0][0]

			# delete all installs
			app.get('sequelize_instance')
			.query('SELECT SUM(h1) as h1, SUM(h24) as h24, SUM(h48) as h48, SUM(d7) as d7, SUM(d31) as d31, SUM(d365) as d365 FROM node_dashboard_page_views')
			.then((pages_stat_objs)->

				# try to get the stats
				pages_stat_obj = pages_stat_objs[0][0]

				# delete all installs
				app.get('sequelize_instance')
				.query('SELECT COUNT(id) as count FROM nodes WHERE nodes.enabled = true and ((SELECT systeminfos."createdAt" FROM systeminfos WHERE systeminfos.nodeId=nodes.id ORDER BY systeminfos."createdAt" DESC LIMIT 1) > NOW() - INTERVAL \'40 minutes\' OR nodes."createdAt" > NOW() - INTERVAL \'40 minutes\')')
				.then((node_stat_obj)->

					# check the nodes
					if node_stat_obj and node_stat_obj[0] and node_stat_obj[0][0]
						node_count_obj.active = 1 * node_stat_obj[0][0].count

					# delete all installs
					app.get('sequelize_instance')
					.query('SELECT COUNT(id) as count FROM nodes WHERE nodes.enabled =true and ((SELECT systeminfos."createdAt" FROM systeminfos WHERE systeminfos.nodeId=nodes.id ORDER BY systeminfos."createdAt" DESC LIMIT 1) < NOW() - INTERVAL \'40 minutes\')')
					.then((node_stat_obj)->

						# check the nodes
						if node_stat_obj and node_stat_obj[0] and node_stat_obj[0][0]
							node_count_obj.down = 1 * node_stat_obj[0][0].count

						# delete all installs
						app.get('sequelize_instance')
						.query('SELECT COUNT(id) as count FROM nodes WHERE nodes.enabled =true and warnings IS NOT NULL AND array_length(warnings, 1) > 0')
						.then((node_stat_obj)->

							# check the nodes
							if node_stat_obj and node_stat_obj[0] and node_stat_obj[0][0]
								node_count_obj.warning = 1 * node_stat_obj[0][0].count

							# delete all installs
							app.get('sequelize_instance')
							.query('SELECT COUNT(id) as count FROM nodes WHERE nodes.enabled = false or nodes.enabled is NULL')
							.then((node_stat_obj)->

								# check the nodes
								if node_stat_obj and node_stat_obj[0] and node_stat_obj[0][0]
									node_count_obj.disabled = 1 * node_stat_obj[0][0].count

								# renders the homepage
								res.render 'home', {

									metrics: {

										pages: pages_stat_obj,
										nodes: node_count_obj,
										macs: mac_stat_obj

									}

								}

							)

						)
					)
				)

			)

		)