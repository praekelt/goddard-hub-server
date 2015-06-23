
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/apps.json', ->

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

						id: 1,
						mport: 15001,
						port: 15000

					}).then(->

						# insert our tests
						app.get('models').apps.create({

								id: 1,
								name: 'mama',
								key: 'mama'

							}).then(->

								# insert our tests
								app.get('models').groups.create({

										id: 1,
										name: 'Default'

									}).then(->

										# add install
										app.get('sequelize_instance')
										.query('INSERT INTO installs("groupId", "AppId", "nodeId") VALUES(1,1,1);')
										.then (pages_stat_objs)->

											# insert our tests
											done()

									).catch(-> done())

							).catch(-> done())

					).catch(-> done())

		# handle the settings
		describe '#response', ->

			# handle the error output
			it 'should return with a error if no id is given', ->

				request(app)
					.get('/apps.json')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						response_obj = JSON.parse(res.text)
						assert(response_obj != null, "Did not return valid JSON")
						assert(response_obj.status == "error", "Had to return a error ...")
					)

			# handle the error output
			it 'should always return "ok"', ->

				request(app)
					.get('/apps.json?uid=1')
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						response_obj = JSON.parse(res.text)
						assert(response_obj != null, "Did not return valid JSON")
					)

		after (done) ->

			# close it all
			done()

		

			
		    
