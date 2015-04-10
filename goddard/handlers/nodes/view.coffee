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
				item_obj = obj.get()
				res.render 'nodes/view', {
					title: 'Node #' + item_obj.serial,
					item_obj: item_obj
				}
		)