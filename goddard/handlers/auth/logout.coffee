# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/logout', (req, res) -> 

		# set the user as logged in
		req.session.logged_in_user_id = null

		# set as the logged in user
		res.redirect('/login')