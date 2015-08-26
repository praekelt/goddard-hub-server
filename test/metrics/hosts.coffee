
# modules
assert = require('assert')
_ = require('underscore')

# checks warnings that we check for
describe 'node', ->

	# require in the service
	node_service = require('../../goddard/services/node')({})

	# local instance
	app = null

	# handle the before method
	before (done) ->

		# setup the harness
		require('../handlers/harness') (app_obj) ->

			# handle app
			app = app_obj

			# insert our tests
			app.get('models').nodes.create({

					mport: 15001,
					port: 15000

				}).then(-> done()).catch(-> done())

	# handle the settings
	describe 'saveHosts()', ->

		# handle the error output
		it 'should save a list of hosts that came in from a metric update', ->

			app.get('services').node.getMaxTunnelPort (err, port) ->

				# do our assertions
				assert(err == null, "Error whould be null")
				assert(port == 15001, "Port should be 15001 as that's the highest")

	

			
		    
