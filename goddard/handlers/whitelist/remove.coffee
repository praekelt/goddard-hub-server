# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

  # required modules
  S = require('string')

  # the homepage for load balancer
  app.get '/whitelist/remove/:whitelistid', app.get('middleware').checkLoggedIn, (req, res) -> 

    app.get('models').whitelist.find(req.params.whitelistid).then (item_obj) ->
      if item_obj?
        item_obj.destroy().then ->
          res.redirect('/whitelist')
      else
        res.redirect('/whitelist')