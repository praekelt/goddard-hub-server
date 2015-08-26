
# modules
assert = require('assert')
_ = require('underscore')
fs = require('fs')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/setup.json', ->

		# require in the service
		node_service = require('../../goddard/services/node')({})

		# local instance
		app = null

		# local vars
		existing_mac_addr = '01:02:03:04'
		new_mac_addr = '01:02:03:05'

		# handle the before method
		before (done) ->

			# returns the app details
			require('./harness') (app_obj) ->

				# set the local instance
				app = app_obj

				# output the amount
				app.get('sequelize_instance').sync({ force: true }).then ->

					app.get('models').nodes.create({

							name: 'test node',
							publickey: 'test',
							macaddr: existing_mac_addr

						}).then(->

							# insert our tests
							app.get('models').groups.create({

									name: 'Default'

								}).then(->

									done()

								).catch(-> done())

						).catch(-> done())

		# handle the settings
		describe '#response', ->

			# handle the error output
			it 'should return 404 when trying to HEAD', ->

				request(app)
					.head('/setup.json')
					.expect(404)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

			# handle the error output
			it 'should return 404 when trying to GET', ->

				request(app)
					.get('/setup.json')
					.expect(404)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

			# handle the error output
			it 'should create new node when new details are given', ->

				request(app)
					.post('/setup.json')
					.send({ key: 'testing', mac: new_mac_addr })
					.expect(200)
					.end((err, res)->

						# handle errors
						assert(err == null, 'Was not expecting a error after request')

						# check for JSON
						response_obj = JSON.parse(res.text)
						assert(response_obj != null, "Did not return valid JSON")

						app.get('models').nodes.find( 1 * response_obj.serial.replace('0', '')).then((pre_node_obj) ->

							# check node obj
							assert(pre_node_obj != null, 'Was expecting a node to be created with that id ...')

						).catch(->assert.fail())
					)

		after (done) ->

			# close it all
			done()

		

			
		    
