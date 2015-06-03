# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# local params
	_ = require('underscore')

	# setup our locals for all the views
	app.use (req, res, next) ->

		# set the send params
		res.locals.post_params = _.extend({}, req.body)
		res.locals.post_params = _.extend( res.locals.post_params, req.query )

		# check type
		if req.url != '/logout'

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

						# set as a local
						res.locals.user_obj = req.requesting_user_obj

						# continue
						next()

					else

						# logout then ...
						res.redirect '/logout?notfound=1'

			else next()

		else next()
