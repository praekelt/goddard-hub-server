# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.post '/login', (req, res) -> 

		# try a login ?
		app.get('services').users.login req.body.username, req.body.password, (err, err_msg, user_obj) ->

			# check for a error
			if user_obj

				# set the user as logged in
				req.session.logged_in_user_id = user_obj.id

				# set as the logged in user
				res.redirect('/')

			else 

				# get the message
				message_str = 'Something went wrong, try again later'

				# if a actual public error was given
				if err_msg then message_str = err_msg.message

				# render the actual page
				res.render 'auth/login', {

					title: 'Login',
					error: message_str

				}

	# the homepage for load balancer
	app.get '/login', (req, res) -> 

		# render the actual page
		res.render 'auth/login', {

			title: 'Login'

		}