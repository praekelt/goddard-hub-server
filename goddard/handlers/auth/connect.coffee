# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# required modules
	querystring 			= require('querystring')
	request					= require('request')

	# params to use for the connections
	param_client_id_str 	= process.env.GOOGLE_CLIENT_ID or ''
	param_client_secret_str = process.env.GOOGLE_SECRET_ID or ''
	redirect_uri_str		= process.env.GOOGLE_OAUTH_CALLBACK_URL or 'http://localhost:4000/connect/callback'

	# load in our modules
	app.get '/connect', (req, res) ->

		# parameters to send out
		queryparams = {

			response_type: 'code',
			client_id: param_client_id_str,
			redirect_uri: redirect_uri_str,
			scope: [ 'email', 'profile' ].join(' '),
			state: '',
			access_type: 'online',
			approval_prompt: 'auto'

		}

		# redirect to the Google Auth screen
		res.redirect 'https://accounts.google.com/o/oauth2/auth?' + querystring.stringify(queryparams)

	# load in our modules
	app.get '/connect/callback', (req, res) ->

		# did we get a code ?
		if req.query.code

			# do the request
			request.post {

				url: 'https://www.googleapis.com/oauth2/v3/token',
				form: {

					code: req.query.code,
					client_id: param_client_id_str,
					client_secret: param_client_secret_str,
					redirect_uri: redirect_uri_str,
					grant_type: 'authorization_code'

				}

			}, (err, response, body) ->

				# get the response
				response_parsed_obj = JSON.parse(body)

				# was there a error ?
				if response_parsed_obj.error 
					res.redirect('/login?error=error&description=' + response_parsed_obj.error.message)
				# was this a success ?
				else if response_parsed_obj.access_token

					# local variable
					access_token_str = response_parsed_obj.access_token

					# get the response
					request 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=' + access_token_str, (err, response, body) ->

						# get the response
						response_user_obj = JSON.parse(body)

						# get the parsers
						param_id_str 			= response_user_obj.id
						param_email_str 		= response_user_obj.email
						param_name_str 			= response_user_obj.name
						param_picture_str 		= response_user_obj.picture

						# save in database
						app.get('models').users.find({

								where: {

									uid: param_id_str,
									provider: 'google'

								}

							}).then (user_obj) ->

								# is this user already registered ?
								if not user_obj

									user_obj = app.get('models').users.build({

											provider: 'google',
											uid: param_id_str,
											email: param_email_str,
											name: param_name_str,
											avatar: param_picture_str,
											enabled: false

										})

								# update the params
								user_obj.name 		= param_name_str
								user_obj.avatar	 	= param_picture_str
								user_obj.lastLogin 	= new Date()

								# save it
								user_obj.save().then ->

									# ok so check if we are allowed
									if user_obj.enabled == true

										# all good log them in
										req.session.logged_in_user_id = user_obj.id

										# set as the logged in user
										res.redirect('/')

									else
										res.render 'auth/accessdenied', {

											title: 'Not Allowed',
											user_obj: user_obj,

									}

				else
					res.redirect('/login?error=notoken')

		else 
			res.redirect('/login?error=nocode')
