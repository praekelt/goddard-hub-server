module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get '/tokens', app.get('middleware').checkLoggedIn, app.get('middleware').handlePagination, (req, res) -> 

		# search params
		filter_params = {}

		# was the search given ?
		if req.query.q
			filter_params = { name: { like: '%' + req.query.q + '%' } }

		# get all the nodes
		app.get('models').whitelist.findAndCountAll(

				offset: req.requesting_pagination_offset,
				limit: req.requesting_pagination_limit,
				where: filter_params

			).then((result) ->

				# render them out
				res.render 'whitelist/list', {

					title: 'Domains users are allowed to browse',
					description: 'Domains users are allowed to browse',
					items: result.rows,
					limit: req.requesting_pagination_limit,
					offset: req.requesting_pagination_offset,
					total_count: result.count,
					current_page: req.requesting_pagination_page,
					pages: Math.ceil( result.count / req.requesting_pagination_limit )

				}

			).catch((err) ->

				# render them out
				res.render 'whitelist/list', {

					title: 'Domains users are allowed to browse',
					items: [],
					limit: req.requesting_pagination_limit,
					offset: req.requesting_pagination_offset,
					total_count: 0,
					current_page: req.requesting_pagination_page,
					pages: 0

				}

			)