# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/', app.get('middleware').checkLoggedIn, (req, res) -> 

		# renders the homepage
		res.render 'home'