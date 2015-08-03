# acts as the homepage for the dashboard
### istanbul ignore next ###
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/groups', app.get('middleware').checkLoggedIn, app.get('middleware').handlePagination, (req, res) -> 

		# search params
		filter_params = {}

		# was the search given ?
		if req.query.q
			search_param = req.query.q
			filter_params = app.get('sequelize').or(
				{

					name: { like: '%' + search_param + '%' }

				},
				{

					description: { like: '%' + search_param + '%' }

				})

		# get all the nodes
		app.get('models').groups.findAndCountAll(

				offset: req.requesting_pagination_offset,
				limit: req.requesting_pagination_limit,
				where: filter_params

			).then (result) ->

				# render them out
				res.render 'groups/list', {

					title: 'Registered groups',
					items: result.rows,
					limit: req.requesting_pagination_limit,
					offset: req.requesting_pagination_offset,
					total_count: result.count,
					current_page: req.requesting_pagination_page,
					pages: Math.ceil( result.count / req.requesting_pagination_limit ),

			}