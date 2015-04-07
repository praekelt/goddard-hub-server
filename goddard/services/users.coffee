# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# pull in required modules
	S 				= require('string')

	# start the users service
	Users = {}

	# returns the user if the username / password are correct
	Users.login = (username_str, password_str, fn) ->

		# validate
		if S(username_str).isEmpty()
			fn null, new Error('Username is required')
		else if S(password_str).isEmpty()
			fn null, new Error('Password is required')
		else

			# check the database now
			app.get('models').users.find({

					where: {

						username: username_str

					}

				}).then (user_response_obj) ->

					# did we find the user ?
					if user_response_obj

						# get a local object we can use
						user_obj = user_response_obj.get()

						# awesome done !
						fn null, null, user_obj

					else
						fn null, new Error('Authentication Failed')

	# expose it
	return Users