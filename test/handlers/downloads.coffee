
# modules
assert = require('assert')
_ = require('underscore')
fs = require('fs')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/downloads', ->

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

				# output the amount
				# app.get('database').sync({}).then -> done()

				# insert our tests
				app.get('models').users.create({

						name: 'test test'

					}).then(-> done()).catch(-> done())

		# handle the error output
		it 'should give a 404', ->

			request(app)
				.get('/downloads/2015/01/123123.txt?logged_in_user_id=1')
				.expect(404)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
				)

		# handle the error output
		it 'should redirect if not logged  in', ->

			request(app)
				.get('/downloads/2015/01/123123.txt')
				.expect(302)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
				)

		# handle the error output
		it 'should download the test file if present and logged in', ->

			# content to write to file
			content_to_write_str = 'test content: ' + new Date().getTime()

			# write a file to test
			fs.mkdir '/tmp/goddard', ->
				fs.mkdir '/tmp/goddard/2015', ->
					fs.mkdir '/tmp/goddard/2015/01', ->

						# write out test file
						fs.writeFileSync('/tmp/goddard/2015/01/123.txt', content_to_write_str)

						# do a request to the app
						request(app)
							.get('/downloads/2015/01/123.txt?logged_in_user_id=1')
							.expect(302)
							.end((err, res)->
								assert(err == null, 'Was not expecting a error after request')
								assert(res.text == content_to_write_str, 'Was expecting the response to match random generated file content we wrote')
							)

		after (done) ->

			# close it all
			done()

		

			
		    
