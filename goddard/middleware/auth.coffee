# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get('middleware').checkLoggedIn = (req, res, next) ->

		# check if the user is logged in here
		if req.session and req.session.logged_in_user_id
			next()
		else
			res.redirect('/login?return=' + req.url)