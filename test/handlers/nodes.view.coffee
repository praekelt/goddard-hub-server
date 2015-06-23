
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/nodes/1/{node-id}', ->

		# require in the service
		node_service = require('../../goddard/services/node')({})

		# local instance
		app = null

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
				app.get('models').nodes.create({

						mport: 15001,
						port: 15000

					}).then(->

						app.get('models').users.create({

							name: 'test test'

						}).then(-> done()).catch(-> done())

					).catch(-> done())

		# handle the settings
		describe '#notloggedin', ->

			# handle the error output
			it 'should redirect away', ->

				request(app)
					.get('/nodes/33')
					.expect(302)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

		# handle the settings
		describe '#notloggedin', ->

			# handle the error output
			it 'should redirect away', ->

				request(app)
					.get('/nodes/1')
					.expect(302)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

		# handle the settings
		describe '#response', ->

			# handle the error output
			it 'should always return "ok"', ->

				request(app)
					.get('/nodes/1?logged_in_user_id=1')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

		after (done) ->

			# close it all
			done()

		

			
		    
