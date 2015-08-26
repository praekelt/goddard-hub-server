# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get('middleware').checkLoggedIn = (req, res, next) ->

		# should we skip ?
		if process.env.NODE_ENV == 'testing'
			req.session.logged_in_user_id = req.params.logged_in_user_id or req.query.logged_in_user_id or req.headers.logged_in_user_id or null
		
		# check if the user is logged in here
		if req.session and req.session.logged_in_user_id
			next()
		else
			res.redirect('/login?return=' + req.url)