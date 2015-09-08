
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/report.json', ->

		# local instance
		app = null

		# handle the before method
		before (done) ->

			# returns the app details
			require('./harness') (app_obj) ->

				# set the local instance
				app = app_obj

				# insert our tests
				app.get('models').nodes.create({

						mport: 15001,
						port: 15000

					}).then(-> done()).catch(-> done())

		# handle the settings
		describe '#response', ->

			# handle the error output
			it 'should always return "ok"', ->

				request(app)
					.get('/report.json?uid=1&status=done&message=test')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						parsed_item_obj = JSON.parse(res)
						if not parsed_item_obj
							assert.fail('Parsed JSON returned was invalid')
						assert(parsed_item_obj.status == 'ok', 'Status returned needs to be "ok"')
					)

			# handle the error output
			it 'should always return "error" if no uid was given', ->

				request(app)
					.get('/report.json?status=done&message=test')
					.expect(400)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						parsed_item_obj = JSON.parse(res)
						if not parsed_item_obj
							assert.fail('Parsed JSON returned was invalid')
						assert(parsed_item_obj.status == 'error', 'Status returned needs to be "error"')
					)

			# handle the error output
			it 'should work even if a invalid nodeId was given, this will allow reporting even on failures', ->

				request(app)
					.get('/report.json?uid=22&status=done&message=test')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						parsed_item_obj = JSON.parse(res)
						if not parsed_item_obj
							assert.fail('Parsed JSON returned was invalid')
						assert(parsed_item_obj.status == 'ok', 'Status returned needs to be "ok"')
					)

		after (done) ->

			# close it all
			done()

		

			
		    
