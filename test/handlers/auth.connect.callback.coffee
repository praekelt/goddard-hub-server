
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/connect/callback', ->

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

		# handle the error output
		it 'should redirect if already logged in', ->

			request(app)
				.get('/connect/callback?logged_in_user_id=1')
				.expect(302)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
				)

		# handle the error output
		it 'should redirect if no code was given', ->

			request(app)
				.get('/connect/callback?logged_in_user_id=1')
				.expect(302)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
					assert(res.text.indexOf('nocode') != -1, 'Was expecting to be redirect with error')
				)

		# handle the error output
		it 'should redirect if code was invalid', ->

			request(app)
				.get('/connect/callback?logged_in_user_id=1&code=test')
				.expect(302)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
				)

		after (done) ->

			# close it all
			done()

		

			
		    
