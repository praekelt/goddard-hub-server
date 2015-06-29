
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

						# then save the device info
						app.get('models').deviceinfo.create({

							bgan_temp: 31,
							bgan_ping: 1012,
							bgan_uptime: 2,
							bgan_lat: '9.9.9.9',
							bgan_lng: '9.9.9.9',
							bgan_signal: 62,
							bgan_public_ip: '127.0.0.1',

							router_uptime: 5,
							wireless_uptime: 1,

							relays: '0 0 0 0',

							nodeid: 1

							}).then(->

								# save according to our registered params
								app.get('models').systeminfo.create({

										cpus: 4,
										load: '0 0 0',
										uptime: 5,

										totalmem: 1000,
										freemem: 300,

										totaldisk: 500,
										freedisk: 1000,
										raid: 'UP UP',

										nodeid: 1

									}).then(->

										# finish !
										app.get('models').users.create({

											name: 'test test'

										}).then(-> done()).catch(-> done())

									).catch(-> done())

							).catch(-> done())

					).catch(-> done())

		# handle the error output
		it 'should redirect away if not logged in', ->

			request(app)
				.get('/nodes/1')
				.expect(302)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
				)

		# handle the error output
		it 'should redirect away if it doesnt exist', ->

			request(app)
				.get('/nodes/33')
				.expect(302)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
				)

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

		

			
		    
