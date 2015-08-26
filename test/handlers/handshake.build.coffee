
# modules
assert = require('assert')
_ = require('underscore')
fs = require('fs')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/build.json', ->

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

				# done !
				done()

		# handle the settings
		describe '#response', ->

			# handle the error output
			it 'should always return "ok"', ->

				request(app)
					.get('/build.json')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						response_obj = JSON.parse(res.text)
						assert(response_obj != null, "Did not return valid JSON")
						assert(response_obj.status == 'ok', "Response for the status was something else than 'ok'")
					)

		# handle the settings
		describe '#webhook.txt', ->

			# handle the error output
			it 'should create a webhook file', ->

				request(app)
					.get('/build.json')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						response_obj = JSON.parse(res.text)
						assert(response_obj != null, "Did not return valid JSON")
						assert(response_obj.status == 'ok', "Response for the status was something else than 'ok'")

						# and check the file
						assert( fs.existsSync('/tmp/webhook.txt'), 'Webhook.txt file should exist after calling build.json' )

						# delete it
						fs.unlinkSync('/tmp/webhook.txt')
					)

		after (done) ->

			# close it all
			done()

		

			
		    
