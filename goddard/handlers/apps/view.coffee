# acts as the homepage for the dashboard
module.exports = exports = (app) ->

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
			item_obj.image = req.body.image
			item_obj.save().then -> res.redirect '/apps'
		)