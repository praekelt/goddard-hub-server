# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/nodes', app.get('middleware').checkLoggedIn, (req, res) -> 

		# get all the nodes
		app.get('models').nodes.findAll().then (objs) ->

			console.dir objs

			# render them out
			res.render 'nodes/list', {

				title: 'Nodes',
				items: objs

			}