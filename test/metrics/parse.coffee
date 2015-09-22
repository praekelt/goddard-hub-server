
# modules
assert = require('assert')
_ = require('underscore')

##
# Examples payloads to test
##
payloads = {

	BLANK: {},
	SAMPLE: {

		nodeid: 5,
		number: 1,
		chars: 'test'

	}

}

# sample object for a node in the database
sample_node_obj = {}

# checks warnings that we check for
describe 'metrics', ->

	# require in the service
	metric_service = require('../../goddard/services/metric')({})

	# handle the settings
	describe 'parse()', ->

		# handle the error output
		it 'should return a blank payload if payload is blank too', ->

			# test the check
			metric_service.parse payloads.BLANK, (err, metric_obj) =>

				# check that error is none
				assert( not err , 'Error was given' )

				# get the warning
				if _.keys(metric_obj) == 0
					assert.fail('returned payload was not blank')

		# handle the error output
		it 'should return a payload with 2 keys from our example', ->

			# test the check
			metric_service.parse payloads.SAMPLE, (err, metric_obj) =>

				# check that error is none
				assert( not err , 'Error was given' )

				# get the warning
				if _.keys(metric_obj).length != 2
					assert.fail('expected 2 keys to be returned but only found ' + _.keys(metric_obj).length)

