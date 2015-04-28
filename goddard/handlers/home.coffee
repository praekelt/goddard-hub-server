# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# runs the db migration
	app.get '/sync', (req, res) -> 
		app.get('sequelize_instance').sync({})
		res.json { status: 'ok' }

	# the homepage for load balancer
	app.get '/', app.get('middleware').checkLoggedIn, (req, res) -> 

		# for now redirect to nodes
		res.redirect '/nodes'

		# renders the homepage
		res.render 'home'