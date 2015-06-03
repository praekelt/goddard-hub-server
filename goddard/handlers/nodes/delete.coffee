# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.delete '/nodes/:appid', (req, res) -> 

		# get all the nodes
		app.get('models').nodes.findAll().then(objs) ->

			# render them out
			res.render 'nodes/list', {

				title: 'Nodes',
				items: objs

			}