# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# setup our locals for all the views
	app.use (req, res, next) ->

		# set our locals to use
		res.locals.logged_in_user_id = req.session.logged_in_user_id

		# get the user
		if req.session.logged_in_user_id

			# get the user obj
			app.get('models').users.find( req.session.logged_in_user_id ).then (user_response_obj) ->

				# did we find it ???
				if user_response_obj

					# set the requesting user
					req.requesting_user_obj = user_response_obj.get()

					console.dir req.requesting_user_obj

					# set as a local
					res.locals.user_obj = req.requesting_user_obj

					# continue
					next()

				else

					# logout then ...
					res.redirect '/logout?notfound=1'

		else next()