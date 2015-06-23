
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/', ->

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
		describe '#logout', ->

			# handle the error output
			it 'should show a logout button', ->

				request(app)
					.get('/')
					.expect(200)
					.end((err, res)->
						assert(err != null, 'Was not expecting a error after request')
						assert(res.text.toLowerCase().indexOf('/logout') != -1, "Logout button was not found")
					)

		# handle the settings
		describe '#loggedin', ->

			# handle the error output
			it 'should save a list of hosts that came in from a metric update', ->

				request(app)
					.get('/?logged_in_user_id=1')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						assert(res.text.toLowerCase().indexOf('login with your google account') == -1, "Was not expecting the login button to be present")
						
					)

		# handle the settings
		describe '#unauthed', ->

			# handle the error output
			it 'should save a list of hosts that came in from a metric update', ->

				request(app)
					.get('/')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						assert(res.text.toLowerCase().indexOf('login with your google account') != -1, "Was expecting the login button to be present")
					)

		after (done) ->

			# close it all
			done()

		

			
		    
