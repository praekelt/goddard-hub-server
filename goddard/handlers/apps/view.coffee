# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# required modules
	S = require('string')

	# the homepage for load balancer
	app.get '/apps/:appid', app.get('middleware').checkLoggedIn, (req, res) -> 

		app.get('models').apps.find(req.params.appid).then((item_obj) ->
			if not item_obj
				res.redirect '/apps'
				return

			item_obj = item_obj.get()
			res.render 'apps/view', {

				title: item_obj.name,
				item_obj: item_obj

			}
		)

	# the homepage for load balancer
	app.post '/apps/:appid', app.get('middleware').checkLoggedIn, (req, res) -> 

		app.get('models').apps.find(req.params.appid).then((item_obj) ->
			if not item_obj
				res.redirect '/apps'
				return

			item_obj.name = req.body.name
			item_obj.description = req.body.description
			item_obj.key = req.body.key
			item_obj.portal = req.body.portal == '1'
			item_obj.visible = req.body.visible == '1'
			item_obj.slug = S(req.body.name).slugify().s
			item_obj.save().then -> res.redirect '/apps'
		)