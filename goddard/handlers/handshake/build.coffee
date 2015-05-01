# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# require the modules
	_ 			= require('underscore')

	# handle any metric coming our way
	app.get '/build.json', (req, res) ->

		# get the params
		param_target_str = req.query.target

		# create a build that can run
		app.get('models').builds.create({

				target: param_target_str,
				status: 1,
				result: null

			}).then((build_obj)->

				# output now
				if build_obj
					build_pub_obj = build_obj.get()

					# try to find the app they are refereing to ...
					exec = require('child_process').exec;
					exec 'cd ' + process.env.PLAYBOOK_DIR + ' && ansible-playbook -i inventory.py -l ' + param_target_str + ' node.yml', (error, stdout, stderr) ->
						console.log('stdout: ' + stdout)
						console.log('stderr: ' + stderr)
						if error != null
							console.log('exec error: ' + error)

						# update it
						build_pub_obj.status = 2
						build_pub_obj.save().then ->
							# done !
							console.log 'done'

					# end HTTP request here
					res.json {

						status: 'ok',
						uid: build_pub_obj.id

					}
				else
					# nope
					res.json {

						status: 'error',
						message: 'Something went wrong'

					}
			)