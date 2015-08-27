module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/tokens', app.get('middleware').checkLoggedIn, app.get('middleware').handlePagination, (req, res) -> 

		# search params
		filter_params = {}

		# was the search given ?
		if req.query.q
			filter_params = { name: { like: '%' + req.query.q + '%' } }

		# get all the nodes
		app.get('models').tokens.findAndCountAll(

				offset: req.requesting_pagination_offset,
				limit: req.requesting_pagination_limit,
				where: filter_params

			).then((result) ->

				# render them out
				res.render 'tokens/list', {

					title: 'Registered Access Tokens',
					description: 'List of registered access tokens',
					items: result.rows,
					limit: req.requesting_pagination_limit,
					offset: req.requesting_pagination_offset,
					total_count: result.count,
					current_page: req.requesting_pagination_page,
					pages: Math.ceil( result.count / req.requesting_pagination_limit )

				}

			).catch(->

				# render them out
				res.render 'tokens/list', {

					title: 'Registered Access Tokens',
					items: [],
					limit: req.requesting_pagination_limit,
					offset: req.requesting_pagination_offset,
					total_count: 0,
					current_page: req.requesting_pagination_page,
					pages: 0

				}

			)