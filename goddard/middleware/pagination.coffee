# acts as the homepage for the dashboard
module.exports = exports = (app) ->

	# the homepage for load balancer
	app.get('middleware').handlePagination = (req, res, next) ->

		# the defaults
		offset_int = 0
		limit_int = 15
		page_int = 1

		# check if the page is defined
		if req.query.page and 1 * req.query.page > 0
			page_int = 1 * req.query.page

		# check for a limit
		if req.query.limit and 1 * req.query.limit > 0 and 1 * req.query.limit < 50
			limit_int = 1 * req.query.limit

		# check for a offset
		if req.query.page and 1 * req.query.page > 0
			offset_int = limit_int*(page_int-1)

		# assign
		req.requesting_pagination_offset = offset_int
		req.requesting_pagination_limit = limit_int
		req.requesting_pagination_page = page_int

		# annnnd done
		next()