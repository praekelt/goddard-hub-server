# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# required modules
	S = require('string')

	# the homepage for load balancer
	app.get '/tokens/:tokenid/revoke', app.get('middleware').checkLoggedIn, (req, res) -> 

		app.get('models').tokens.find(req.params.tokenid).then (item_obj) ->
			if item_obj?
				item_obj.destroy().then ->
					res.redirect('/tokens')
			else
				res.redirect('/tokens')