# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/nodes/:nodeid', app.get('middleware').checkLoggedIn, (req, res) ->

		console.log 'node here' 

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
				app.get('models').deviceinfo.findAll({where: { nodeid: item_obj.id },limit: 1}).then (deviceinfo_objs) ->

					# did we find any ?
					if deviceinfo_objs and deviceinfo_objs.length > 0
						deviceinfo_objs = deviceinfo_objs[0].dataValues
					else
						deviceinfo_objs = []

					# get the metrics
					app.get('models').systeminfo.findAll({where: { nodeid: item_obj.id },limit: 1}).then (systeminfo_objs) ->

						# did we find any ?
						if systeminfo_objs and systeminfo_objs.length > 0
							systeminfo_objs = systeminfo_objs[0].dataValues
						else
							systeminfo_objs = []

						# get the group
						app.get('models').groups.find(1 * obj.groupId).then (group_obj) ->

							console.dir deviceinfo_objs
							console.dir systeminfo_objs

							if group_obj
								group_obj = group_obj.get()

							res.render 'nodes/view', {
								title: 'Node #' + item_obj.serial,
								item_obj: item_obj,
								group_obj: group_obj,
								metrics: {

									devices: deviceinfo_objs,
									system: systeminfo_objs

								}
							}
		)