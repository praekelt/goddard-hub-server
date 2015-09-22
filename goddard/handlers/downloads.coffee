# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# require modules
	fs = require('fs')

	# the homepage for load balancer
	app.get '/downloads/:year/:month/:file', (req, res) ->

		# redirect
		url_str = ['', 'downloads', req.params.year, req.params.month, req.params.file].join('/')

		# was a token given ... ?
		if req.query.token?

			# find the token by key
			app.get('models').tokens.find(

					offset: 0,
					limit: 1,
					where: {
						key: req.query.token
					}

				).then (item_obj) ->

					# check the token given
					if item_obj?

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
								res.status(404).send('no such build was found .. head back <a href="/">here</a>')

					else 

						# redirect away to actually login
						res.status(401).send('Token is not valid, access might have been revoked or no such token exists .. head back <a href="/">here</a>')

		else
			res.status(401).send('?token query string parameter is required .. head back <a href="/">here</a>')
