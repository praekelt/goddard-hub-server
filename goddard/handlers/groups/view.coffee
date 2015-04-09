# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/groups/:groupid', app.get('middleware').checkLoggedIn, (req, res) -> 

		app.get('models').groups.find(req.params.groupid).then((item_obj) ->
			if not item_obj
				res.redirect '/groups'
				return

			item_obj = item_obj.get()
			res.render 'groups/view', {

				title: item_obj.name,
				item_obj: item_obj

			}
		)

	# the homepage for load balancer
	app.post '/groups/:groupid', app.get('middleware').checkLoggedIn, (req, res) -> 

		app.get('models').groups.find(req.params.groupid).then((item_obj) ->
			if not item_obj
				res.redirect '/groups'
				return

			item_obj.name = req.body.name
			item_obj.description = req.body.description
			item_obj.save().then -> res.redirect '/groups'
		)