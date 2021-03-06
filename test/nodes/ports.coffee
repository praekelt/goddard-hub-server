
# modules
assert = require('assert')
_ = require('underscore')

# checks warnings that we check for
describe 'node', ->

	# require in the service
	node_service = require('../../goddard/services/node')({})

	# handle port settings
	describe 'Ports', ->

		# local instance
		app = null

		# handle the before method
		before (done) ->

			# update it, create the http server
			app = require('../../goddard/httpd')

			# connect and setup database
			require('../../goddard/schema')(app)
			require('../../goddard/services')(app)

			# output the amount
			app.get('sequelize_instance').sync({}).then ->

				# insert our tests
				app.get('models').nodes.create({

						mport: 15001,
						port: 15000

					}).then(-> done()).catch(-> done())

		# handle the settings
		describe 'getMaxTunnelPort()', ->

			# handle the error output
			it 'should return 15001 as the higest port from our dataset', ->

				app.get('services').node.getMaxTunnelPort (err, port) ->

					# do our assertions
					assert(err == null, "Error whould be null")
					assert(port == 15001, "Port should be 15001 as that's the highest")

		# handle the settings
		describe 'getNextTunnelPort()', ->

			# handle the error output
			it 'should return 15004 as the higest port from our dataset', ->

				app.get('services').node.getNextTunnelPort (err, port, mport) ->

					# do our assertions
					assert(err == null, "Error whould be null")
					assert(port == 15004, "Tunnel port should be 15005")
					assert(mport == 15005, "Monitor port should be 15005")

		after (done) ->

			# done !
			app = null

			# close it all
			done()

	

			
		    
