
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/apps', ->

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
				app.get('database').sync({}).then ->

					# insert our tests
					app.get('models').users.create({

							name: 'test test'

						}).then(-> done()).catch(-> done())


		# handle the settings
		describe '#notloggedin', ->

			# handle the error output
			it 'should redirect away', ->

				request(app)
					.get('/apps')
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
					.get('/apps?logged_in_user_id=1')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						assert(res.text.indexOf('/apps/create') != -1, "Can't use the app create function, assuming page bad")
					)

		after (done) ->

			# close it all
			done()

		

			
		    
