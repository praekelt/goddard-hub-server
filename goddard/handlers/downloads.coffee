# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# require modules
	fs = require('fs')

	# the homepage for load balancer
	app.get '/downloads/:year/:month/:file', (req, res) ->

		# redirect
		url_str = ['', 'downloads', req.params.year, req.params.month, req.params.file].join('/')

		# check if logged in
		if req.session and req.session.logged_in_user_id

			# base folder
			base_folder_str = process.env.BUILDS_FOLDER_PATH or '/var/goddard/builds'

			# build the file name
			file_name = [base_folder_str, req.params.year, req.params.month, req.params.file].join('/')

			# try to login
			fs.exists file_name, (exists_bool) ->

				# check it
				if exists_bool == true

					# pipe the file
					fs.createReadStream(file_name).pipe(res)

				else 

					# nothing
					res.send('no such build was found .. head back <a href="/">here</a>')

		else 

			# redirect away to actually login
			res.redirect('/connect?return=' + url_str)