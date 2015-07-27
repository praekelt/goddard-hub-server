
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')
metric_obj = {

	"nodeid": 1,
	"timestamp": "",
	"node": {

		"cpus": 4,
		"load": "1.0, 0.6, 0.4",
		"uptime": 13,

		"memory": {

			"free": 468,
			"total": 1024

		},
		"disk": {

			"free": 14300,
			"total": 19900,
			"raid": [ "ACTIVE","ACTIVE" ]

		}

	},
	"bgan": {

		"uptime": 1,
		"lat": "33.123",
		"lng": "18.134",
		"temp": 38.4,
		"ping": 1300

	},
	"router": {

		"uptime": 100

	},
	"wireless": {

		"uptime": 100

	},
	"relays": [ 1,0,0,0 ]

}

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

				# output the amount
				app.get('sequelize_instance').sync({ force: true }).then ->

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
					.get('/metric.json')
					.expect(404)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
					)

			# handle the error output
			it 'should log our actual metric test', ->

				request(app)
					.post('/metric.json')
					.send(metric_obj)
					.expect(200)
					.end((err, res)->
						assert(err == null, 'Was not expecting a error after request')
						response_obj = JSON.parse(res.text)
						assert(response_obj != null, "Did not return valid JSON")
						assert(response_obj.status == 'ok', "Response for the status was something else than 'ok'")
					)

		after (done) ->

			# close it all
			done()

		

			
		    
