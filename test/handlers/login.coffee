
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/login', ->

		# require in the service
		node_service = require('../../goddard/services/node')({})

		# nothing
		app = null

		# handle the before method
		before (done) ->

			# returns the app details
			require('./harness') (app_obj) ->

				# set the local instance
				app = app_obj

				# done !
				done()

		# handle the error output
		it 'should show the login page', ->

			request(app)
				.get('/login')
				.expect(200)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
					assert(res.text.toLowerCase().indexOf('login with your google account') != -1, "Was expecting the login button to be present")
				)

		after (done) ->

			# close it all
			done()

		

			
		    
