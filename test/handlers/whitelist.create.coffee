
# modules
assert = require('assert')
_ = require('underscore')
fs = require('fs')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

  describe '/whitelist/create', ->

    # local instance
    app = null

    # local vars
    existing_mac_addr = '01:02:03:04'
    new_mac_addr = '01:02:03:05'

    # handle the before method
    before (done) ->

      # returns the app details
      require('./harness') (app_obj) ->

        # set the local instance
        app = app_obj

        # insert our tests
        app.get('models').whitelist.create({

            name: 'test test',
            domain: 'io.co.za'

          }).then(

            app.get('models').groups.create({

              name: 'test'

            }).then(

              done()

          ).catch(-> done())

        ).catch(-> done())

    # handle the settings
    describe '#notloggedin', ->

      # handle the error output
      it 'should redirect to login', ->

        request(app)
          .get('/whitelist/create')
          .expect(302)
          .end((err, res)->
            assert(err == null, 'Was not expecting a error after request')
          )

    # handle the settings
    describe '#response', ->

      # handle the error output
      it 'should be able to get a form when trying to create a token', ->

        request(app)
          .get('/whitelist/create')
          .expect(200)
          .end((err, res)->
            assert(err == null, 'Was not expecting a error after request')
          )

      # handle the error output
      it 'should create the the token when posting', ->

        request(app)
          .post('/whitelist/create?logged_in_user_id=1')
          .send({ name: 'test2', domain: 'test2', group: 1 })
          .expect(302)
          .end((err, res)->

            # handle errors
            assert(err == null, 'Was not expecting a error after request')

            # check if we can see it in the database
            app.get('models').whitelist.find(2).then((whitelist_obj) ->

              # check the returned user obj
              assert(whitelist_obj != null, 'was expecting a whitelist obj ...')

              # check the 
              assert(whitelist_obj.name == 'test2', 'Name of token created must be "test2" after checking DB')

            ).catch((err) -> assert.fail())

          )

    after (done) ->

      # close it all
      done()

    

      
        
