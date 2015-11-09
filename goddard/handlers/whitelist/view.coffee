# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# required modules
	S = require('string')

	# the homepage for load balancer
	app.get '/whitelist/:whitelistid', app.get('middleware').checkLoggedIn, (req, res) ->

		# get all the groups
		app.get('models').groups.findAll().then (group_objs) ->

			app.get('models').whitelist.find(req.params.whitelistid).then((item_obj) ->
				if not item_obj
					res.redirect '/whitelist'
					return

				item_obj = item_obj.get()
				res.render 'whitelist/view', {

					title: item_obj.name,
					item_obj: item_obj,
					group_objs: group_objs

				}
			)

	# the homepage for load balancer
	app.post '/whitelist/:whitelistid', app.get('middleware').checkLoggedIn, (req, res) ->

		app.get('models').whitelist.find(req.params.whitelistid).then((item_obj) ->
			if not item_obj
				res.redirect '/whitelist'
				return

			# handle the item
			item_obj.name = req.body.name
			item_obj.domain = req.body.domain
			item_obj.save()
			.then(->res.redirect '/whitelist')
			.catch(->res.redirect '/whitelist')

		)
