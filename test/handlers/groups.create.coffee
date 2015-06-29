
# modules
assert = require('assert')
_ = require('underscore')
fs = require('fs')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/groups/create', ->

		# local instance
		app = null

		# local vars
		existing_mac_addr = '01:02:03:04'
		new_mac_addr = '01:02:03:05'

		# handle the before method
		before (done) ->

			# update it, create the http server
			app = require('../../goddard/httpd')

			# connect and setup database
			require('../../goddard/schema')(app)
			require('../../goddard/services')(app)
			require('../../goddard/middleware')(app)
			require('../../goddard/handlers')(app)

			# output the amount
			app.get('sequelize_instance').sync({ force: true }).then ->

				# insert our tests
				app.get('models').users.create({

						name: 'test test'

					}).then(

						app.get('models').nodes.create({

							name: 'test group',
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
					.get('/groups/create')
					.expect(302)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

		# handle the settings
		describe '#response', ->

			# handle the error output
			it 'should be able to get a form when trying to create a group', ->

				request(app)
					.get('/groups/create')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

			# handle the error output
			it 'should create the the group when posting', ->

				request(app)
					.post('/groups/create?logged_in_user_id=1')
					.send({ name: 'test2', description: 'test2' })
					.expect(302)
					.end((err, res)->

						# handle errors
						assert(err == null, 'Was not expecting a error after request')

						# check if we can see it in the database
						app.get('models').groups.find(2).then((group_obj) ->

							# check the returned user obj
							assert(group_obj != null, 'was expecting a groups obj ...')

							# check the 
							assert(group_obj.name == 'test2', 'Name of group created must be "test2" after checking DB')

						).catch((err) -> assert.fail())

					)

		after (done) ->

			# close it all
			done()

		

			
		    
