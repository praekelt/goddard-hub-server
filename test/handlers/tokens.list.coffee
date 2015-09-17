
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/tokens', ->

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

							name: 'test test'

						}).then(-> done()).catch((err)->

							# insert our tests
							app.get('models').tokens.create({

									name: 'test test'

								}).then(-> done()).catch((err)->
									done()
								)

					)

		# handle the settings
		describe '#notloggedin', ->

			# handle the error output
			it 'should redirect away', ->

				request(app)
					.get('/tokens')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						assert(res.text.indexOf('/login') != -1, "Can't use the group")
					)

		# handle the settings
		describe '#response', ->

			# handle the error output
			it 'should always return "ok"', ->

				request(app)
					.get('/tokens?logged_in_user_id=1')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

		after (done) ->

			# close it all
			done()

		

			
		    
