
# modules
assert = require('assert')
_ = require('underscore')
fs = require('fs')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/nodes/edit', ->

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

					# insert our tests
					app.get('models').users.create({

							name: 'test test'

						}).then(

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

					).catch(-> done())

		# handle the settings
		describe '#notloggedin', ->

			# handle the error output
			it 'should redirect to login', ->

				request(app)
					.get('/nodes/2/edit')
					.expect(302)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

		# handle the settings
		describe '#response', ->

			# handle the error output
			it 'should redirect when trying to GET node that doesnt exist', ->

				request(app)
					.get('/nodes/2/edit?logged_in_user_id=1')
					.expect(302)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

			# handle the error output
			it 'should show the name of the node', ->

				request(app)
					.get('/nodes/1/edit?logged_in_user_id=1')
					.expect(200)
					.end((err, res)->

						# handle errors
						assert(err == null, 'Was not expecting a error after request')
						assert(res.text.indexOf('test node') != -1, 'Was expecting the name of the node to appear ...')
					)

			# handle the error output
			it 'should update the name of the node when posting', ->

				request(app)
					.post('/nodes/1/edit?logged_in_user_id=1')
					.send({ name: 'test2', group: 1 })
					.expect(302)
					.end((err, res)->

						# handle errors
						assert(err == null, 'Was not expecting a error after request')

						# check if we can see it in the database
						app.get('models').nodes.find(1).then((node_obj) ->

							# check the returned user obj
							assert(node_obj != null, 'was expecting a nodes obj ...')

							# check the 
							assert(node_obj.name == 'test2', 'Name must be test2 after the update')

						).catch((err) -> assert.fail())

					)

		after (done) ->

			# close it all
			done()

		

			
		    
