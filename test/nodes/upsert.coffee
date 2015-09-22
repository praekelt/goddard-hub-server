
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
							macaddr: existing_macaddr

						}).then(-> done()).catch(-> done())

				).catch(-> done())

	# handle the settings
	describe 'find()', ->

		# handle the error output
		it 'should just return our node already in the database', ->

			app.get('services').node.find existing_macaddr, 'publickey', (err, node_obj) ->

				# do our assertions
				assert(err == null, "Error whould be null")
				assert(node_obj.port == 15000, "Should return our existing node")

		# handle the error output
		it 'should create a new node as this is a new MAC address', ->

			app.get('services').node.find new_macaddr, 'publickey', (err, node_obj) ->

				# do our assertions
				assert(err == null, "Error whould be null")
				assert(node_obj != null, "Error whould be null")

				# get the data
				node_obj = node_obj.get()

				assert(node_obj.port != null, "Should not be null")
				assert(node_obj.port != 15000, "Should return our existing node")
				assert(node_obj.mport != 15001, "Should return our existing node by monitor port either")

	after (done) ->

		# done !
		app = null

		# close it all
		done()

	

			
		    
