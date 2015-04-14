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

				# get the group
				app.get('models').groups.find(1 * obj.groupId).then (group_obj) ->

					if group_obj
						group_obj = group_obj.get()

					res.render 'nodes/view', {
						title: 'Node #' + item_obj.serial,
						item_obj: item_obj,
						group_obj: group_obj
					}
		)