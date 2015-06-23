
# modules
assert = require('assert')
_ = require('underscore')
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

			# update it, create the http server
			app = require('../../goddard/httpd')

			# connect and setup database
			require('../../goddard/schema')(app)
			require('../../goddard/services')(app)
			require('../../goddard/middleware')(app)
			require('../../goddard/handlers')(app)

			# output the amount
			app.get('sequelize_instance').sync({}).then ->

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
					.get('/metrics.json')
					.expect(200)
					.end((err, res)->
						assert(err != null, 'Was not expecting a error after request')
						console.log(res.text)
					)

		after (done) ->

			# close it all
			done()

		

			
		    
