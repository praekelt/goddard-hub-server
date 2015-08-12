
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
							groupId: 1

						}).then(-> done()).catch(-> done())

				).catch(-> done())

	# handle the settings
	describe 'update()', ->

		# handle the error output
		it 'should just return our node already in the database', ->

			# handle getting the existing mac
			app.get('services').node.find existing_macaddr, 'publickey', (err, node_obj) ->

				# do our assertions
				assert(err == null, "Error whould be null")
				assert(node_obj != null, "Should return our existing node")

				# should update our node's ts
				app.get('services').node.update node_obj, (err, updated_node_obj) ->

					# do our assertions
					assert(err == null, "Error whould be null")
					assert(updated_node_obj.macaddr == existing_macaddr, "Should return our existing node")
					assert(updated_node_obj.serial == '0000' + node_obj.id, "Should return our existing node")

	after (done) ->

		# done !
		app = null

		# close it all
		done()

	

			
		    
