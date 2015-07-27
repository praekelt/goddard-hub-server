# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/users/:userid/toggle/:type', app.get('middleware').checkLoggedIn, (req, res) -> 

		# check for the id
		if not req.params.userid or not req.params.type
			res.redirect('/users')
			return

		# find by the given id
		app.get('models').users.find(1 * req.params.userid).then((obj) ->

			# was it found ?
			if not obj
				res.redirect('/users')
				return
			else
				# according to type
				if req.params.type == 'enabled'
					obj.enabled = if obj.enabled == true then false else true
					if obj.enabled == false
						obj.admin = false
					obj.save().then -> res.redirect('/users')
				else if req.params.type == 'admin'
					obj.admin = if obj.admin == true then false else true
					obj.save().then -> res.redirect('/users')
				else
					res.redirect '/users?error=nosuchtype'
		)