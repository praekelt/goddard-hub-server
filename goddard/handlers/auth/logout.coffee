# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/logout', (req, res) -> 

		# sanity check for session
		if req.session?

			# delete the user
			delete req.session.logged_in_user_id
			delete req.session.logged_in_user

		# return to homepage
		res.redirect('/')