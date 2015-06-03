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
		fn null, 'cd ' + process.env.PLAYBOOK_DIR + ' && ANSIBLE_HOST_KEY_CHECKING=no ansible-playbook -i inventory.py -l ' + target_str + ' node.yml'

	# run a build and update using the build obj given
	Build.run = (build_obj, fn) ->

		# disabled for now
		fn(null)

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