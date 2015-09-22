
# modules
assert = require('assert')
_ = require('underscore')

# checks warnings that we check for
describe 'node', ->

	# require in the service
	node_service = require('../../goddard/services/node')({})

	# local instance
	app = null
	existing_macaddr = '05:06:07:08'
	new_macaddr = '05:06:07:09'

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
			app.get('models').groups.create({

					name: 'Default'

				}).then(->

					# insert our tests
					app.get('models').nodes.create({

							mport: 15001,
							port: 15000,
							macaddr: existing_macaddr,
							groupId: 1,
							name: 'test',
							publickey: 'device-test'

						}).then(-> done()).catch(-> done())

				).catch(-> done())

	# handle the settings
	describe 'format()', ->

		# handle the error output
		it 'should return a formatted response', ->

			# handle getting the existing mac
			app.get('services').node.find existing_macaddr, 'publickey', (err, node_obj) ->

				# do our assertions
				assert(err == null, "Error should be null")
				assert(node_obj != null, "Should return our existing node")

				# should update our node's ts
				app.get('services').node.formatResponse node_obj, (err, formatted_node_obj) ->

					# do our assertions
					assert(err == null, "Error should be null")
					assert(formatted_node_obj != null, "Should not return null ...")
					assert(formatted_node_obj.serial == '0000' + node_obj.id, "Should return the updated serial for the node")
					assert(formatted_node_obj.uid == node_obj.id, "Should return the 'uid' or ID of the device")
					assert(formatted_node_obj.publickey == 'test', "Should return the public key of the server ..")
					assert(formatted_node_obj.name == 'test', "Should return the updated serial for the node")
					assert(formatted_node_obj.port != null, "Should return a port object we can check")
					assert(formatted_node_obj.port.tunnel == node_obj.port, "Should return the tunnel port")
					assert(formatted_node_obj.port.monitor == node_obj.mport, "Should return the actual monitor port")

	after (done) ->

		# done !
		app = null

		# close it all
		done()

	

			
		    
