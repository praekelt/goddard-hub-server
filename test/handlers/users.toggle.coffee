
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/users/toggle', ->

		# require in the service
		node_service = require('../../goddard/services/node')({})

		# local instance
		app = null

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

							name: 'test test',
							admin: false,
							enabled: false

						}).then(-> done()).catch((err)->
							done()
						)

		# handle the settings
		describe '#notloggedin', ->

			# handle the error output
			it 'should redirect away', ->

				request(app)
					.get('/users/1/toggle/enabled')
					.expect(302)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

		# handle the settings
		describe '#notfound', ->

			# handle the error output
			it 'should redirect if the user was not found', ->

				app.get('models').users.find(1).then((before_change_user_obj) ->

						# check the returned user obj
						assert(before_change_user_obj != null, 'was expecting a user obj ...')

						request(app)
							.get('/users/4/toggle/none?logged_in_user_id=1')
							.expect(302)
							.end((err, res)->
								assert(err == null, 'Was not expecting a error after request')
							)

					).catch((err) -> assert.fail())

		# handle the settings
		describe '#admin', ->

			# handle the error output
			it 'should mark the user as admin based on toggle', ->

				app.get('models').users.find(1).then((before_change_user_obj) ->

						# check the returned user obj
						assert(before_change_user_obj != null, 'was expecting a user obj ...')

						request(app)
							.get('/users/1/toggle/none?logged_in_user_id=1')
							.expect(302)
							.end((err, res)->
								assert(err == null, 'Was not expecting a error after request')
								assert(res.headers.location == '/users?error=nosuchtype', 'Was expecting a redirect with a error')
							)

					).catch((err) -> assert.fail())

		# handle the settings
		describe '#admin', ->

			# handle the error output
			it 'should mark the user as admin based on toggle', ->

				app.get('models').users.find(1).then((before_change_user_obj) ->

						# check the returned user obj
						assert(before_change_user_obj != null, 'was expecting a user obj ...')

						request(app)
							.get('/users/1/toggle/admin?logged_in_user_id=1')
							.expect(302)
							.end((err, res)->
								assert(err == null, 'Was not expecting a error after request')

								app.get('models').users.find(1).then((user_obj) ->

										# check the returned user obj
										assert(user_obj != null, 'was expecting a user obj ...')

										# check the 
										assert(user_obj.admin != before_change_user_obj.admin, 'User must be admin but still listed as disabled')

									).catch((err) -> assert.fail())
							)

					).catch((err) -> assert.fail())

		# handle the settings
		describe '#enabled', ->

			# handle the error output
			it 'should enable/disable the user for the toggle', ->

				app.get('models').users.find(1).then((before_change_user_obj) ->

						# check the returned user obj
						assert(before_change_user_obj != null, 'was expecting a user obj ...')

						request(app)
							.get('/users/1/toggle/enabled?logged_in_user_id=1')
							.expect(302)
							.end((err, res)->
								assert(err == null, 'Was not expecting a error after request')

								app.get('models').users.find(1).then((user_obj) ->

										# check the returned user obj
										assert(user_obj != null, 'was expecting a user obj ...')

										# check the 
										assert(user_obj.enabled != before_change_user_obj.enabled, 'User must be enabled but still listed as disabled')

									).catch((err) -> assert.fail())
							)

					).catch((err) -> assert.fail())

		after (done) ->

			# close it all
			done()

		

			
		    
