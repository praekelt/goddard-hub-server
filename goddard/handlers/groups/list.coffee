# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/groups', (req, res) -> 

		app.get('models').nodes.findAll().then((objs) ->
			res.json objs
		)