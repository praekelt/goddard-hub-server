
# modules
assert = require('assert')
_ = require('underscore')
request = require('supertest')

# checks warnings that we check for
describe 'Handlers', ->

  describe '/whitelist', ->

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
          app.get('models').whitelist.create({

              name: 'test test',
              domain: 'goddard.com'

            }).then(-> done()).catch((err)->done())

    # handle the settings
    describe '#notloggedin', ->

      # handle the error output
      it 'should redirect away', ->

        request(app)
          .get('/whitelist')
          .expect(302)
          .end((err, res)->
            assert(err == null, 'Was not expecting a error after request')
            assert(res.text.indexOf('/login') != -1, "Can't use the whitelist")
          )

    after (done) ->

      # close it all
      done()

    

      
        
