# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/login', (req, res) -> 

		# render the actual page
		res.render 'auth/login', {

			title: 'Login'

		}