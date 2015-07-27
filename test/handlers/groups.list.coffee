
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

	describe '/groups', ->

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
					app.get('models').users.create({

							name: 'test test'

						}).then(->

							app.get('models').groups.create({

								name: 'Default'

							}).then(-> done()).catch(-> done())

						).catch(-> done())

		# handle the error output
		it 'should redirect away if not logged in', ->

			request(app)
				.get('/groups')
				.expect(302)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
					assert(res.text.indexOf('/login') != -1, "Can't use the group")
				)

		# handle the error output
		it 'should redirect away if item was does exist', ->

			request(app)
				.get('/groups?q=0002')
				.expect(200)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
					assert(res.text.toLowerCase().indexOf('default') == -1, "Group 'default' should not be present after search")
				)

		# handle the error output
		it 'should show list page', ->

			request(app)
				.get('/groups?logged_in_user_id=1')
				.expect(200)
				.end((err, res)->
					assert(err == null, 'Was not expecting a error after request')
					assert(res.text.indexOf('/groups/create') != -1, "Can't use the group")
				)

		after (done) ->

			# close it all
			done()

		

			
		    
