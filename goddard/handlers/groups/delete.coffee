# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.del '/groups/:appid', (req, res) -> 

		app.get('models').nodes.findAll().then((objs) ->
			res.json objs
		)