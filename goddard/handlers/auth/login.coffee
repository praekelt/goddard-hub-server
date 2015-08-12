# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/login', (req, res) -> 

		# render the actual page
		res.render 'auth/login', {

			title: 'Login'

		}