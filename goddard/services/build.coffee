# loads all the modules and the subdirs for the app
module.exports = exports = (app) ->

	# pull in required modules
	S 				= require('string')
	exec 			= require('child_process').exec

	# start the Build service
	Build = {}

	# builds the path to run
	Build.buildPath = (target_str, fn) ->

		# done
		fn null, 'cd ' + process.env.PLAYBOOK_DIR + ' && ansible-playbook -i inventory.py -l ' + target_str + ' node.yml'

	# run a build and update using the build obj given
	Build.run = (build_obj, fn) ->

		# is there a func
		if build_obj.get
			build_public_obj = build_obj.get()

		# get the path to run
		Build.buildPath build_public_obj.target, (err, path_str) ->

			# try to find the app they are refereing to ...
			exec path_str, (error, stdout, stderr) ->
				
				# update it
				build_obj.status = 2
				build_obj.output = stdout
				build_obj.save().then(->fn(null)).catch(fn)

	# returns the user if the username / password are correct
	Build.create = (target_str, fn) ->

		# start the build for the target
		# create a build that can run
		app.get('models').builds.create({

			target: target_str,
			status: 1,
			result: null

		}).then((build_obj) -> fn(null, build_obj)).catch(fn)

	# expose it
	return Build