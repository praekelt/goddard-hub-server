
# modules
assert = require('assert')
_ = require('underscore')

##
# Examples payloads to test
##
payloads = {

	HIGH: {

		bgan: {

			signal: 60,
			temp: 51

		}

	},
	EQUAL: {

		bgan: {

			signal: 60,
			temp: 50

		}

	},
	LOW: {

		bgan: {

			signal: 20,
			temp: 26

		}

	},
	NONE: {

		bgan: {}

	},
	BLANK: {}

}

# sample object for a node in the database
sample_node_obj = {}

# checks warnings that we check for
describe 'metrics', ->

	# require in the service
	metric_service = require('../../goddard/services/metric')({})

	# checks warnings that we check for
	describe 'warnings', ->

		# handle the settings
		describe 'check()', ->

			# handle the error output
			it 'should give a few warnings if the payload is blank', ->

				# test the check
				metric_service.check sample_node_obj, payloads.BLANK, (err, warning_strs) ->

					# check that error is none
					assert( not err , 'Error was given' )

					# get the warning
					assert( warning_strs.length > 0 , 'warnings should be returned for a blank payload' )

			# handle the settings
			describe 'BGAN', ->

				# handle the error output
				it 'should give a warning if the BGAN did not have a payload', ->

					# test the check
					metric_service.check sample_node_obj, payloads.BLANK, (err, warning_strs) ->

						# check that error is none
						assert( not err , 'error was thrown' )

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('seem to be connected') != -1

						# get the warning
						assert( error_str? , 'no warning given for bgan assuming bad' )

				# handle the error output
				it 'should give a warning if the BGAN had a blank payload', ->

					# test the check
					metric_service.check sample_node_obj, payloads.NONE, (err, warning_strs) ->

						# check that error is none
						assert( not err , 'error was thrown' )

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('seem to be connected') != -1

						# get the warning
						assert( error_str? , 'no warning given for bgan assuming bad' )

				# handle the settings
				describe 'signal', ->

					# handle the error output
					it 'should give a warning if bgan signal is under 30', ->

						# test the check
						metric_service.check sample_node_obj, payloads.LOW, (err, warning_strs) ->

							# check that error is none
							if err
								assert.fail('error was thrown')

							# bgan error
							error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('signal is very low at') != -1

							# get the warning
							if not error_str
								assert.fail('no warning was given')

					# handle the error output
					it 'should not give a warning if bgan signal is over or equal to 30', ->

						# test the check
						metric_service.check sample_node_obj, payloads.HIGH, (err, warning_strs) ->

							# check that error is none
							if err
								assert.fail('error was thrown')

							# bgan error
							error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('signal is very low at') != -1

							# output
							if error_str
								assert.fail('warning should not have been given')

				# handle the settings
				describe 'temp', ->

					# handle the error output
					it 'should not give a warning if below 50', ->

						# test the check
						metric_service.check sample_node_obj, payloads.LOW, (err, warning_strs) ->

							# check that error is none
							if err
								assert.fail('error was thrown')

							# bgan error
							error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('temperature seems high at') != -1

							# get the warning
							# if error_str
							#	assert.fail('no warning given for temperature but there should be one')
							if error_str
								assert.fail('warning was not expected expected')

					# handle the error output
					it 'should give a warning if bgan temperature is more than 50 degrees', ->

						# test the check
						metric_service.check sample_node_obj, payloads.HIGH, (err, warning_strs) ->

							# check that error is none
							if err
								assert.fail('error was thrown')

							# bgan error
							error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('temperature seems high at') != -1

							# output
							if not error_str
								assert.fail('no warning given for temperature but there should be one')

					# handle the error output
					it 'should give a warning if bgan temperature is equal to 50 degrees', ->

						# test the check
						metric_service.check sample_node_obj, payloads.EQUAL, (err, warning_strs) ->

							# check that error is none
							if err
								assert.fail('error was thrown')

							# bgan error
							error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('temperature seems high at') != -1

							# output
							if not error_str
								assert.fail('no warning given for temperature but there should be one')

		

			
		    
