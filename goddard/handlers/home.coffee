# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# runs the db migration
	app.get '/sync', (req, res) -> 
		app.get('sequelize_instance').sync({})
		res.json { status: 'ok' }

	# the homepage for load balancer
	app.get '/', app.get('middleware').checkLoggedIn, (req, res) -> 

		# delete all installs
		app.get('sequelize_instance')
		.query('SELECT SUM(h1) as h1, SUM(h24) as h24, SUM(h48) as h48, SUM(d7) as d7, SUM(d31) as d31, SUM(365) as d365 FROM node_dashboard_page_views')
		.then((stat_objs)->

			# try to get the stats
			stat_obj = stat_objs[0][0]

			# renders the homepage
			res.render 'home', {

				metrics: {

					pages: stat_obj

				}

			}

		)