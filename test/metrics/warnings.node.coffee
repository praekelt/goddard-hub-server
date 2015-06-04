
# modules
assert = require('assert')
_ = require('underscore')

##
# Examples payloads to test
##
payloads = {

	HIGHLOAD: {

		node: {

			load: [2.3,1,3].join(' ')

		}

	},

	LOWLOAD: {

		node: {

			load: [0.5,1,3].join(' ')

		}

	},
	HIGHDISK: {

		node: {

			disk: { free: 1000 * 20 }

		}

	},
	EQUALDISK: {

		node: {

			disk: { free: 1000 * 10 }

		}

	},
	LOWDISK: {

		node: {

			disk: { free: 1000 * 5 }

		}

	},
	HIGHMEMORY: {

		node: {

			memory: { free: 2048 * 1000 * 1000 }

		}

	},
	EQUALMEMORY: {

		node: {

			memory: { free: 1024 * 1000 * 1000 }

		}

	},
	LOWMEMORY: {

		node: {

			memory: { free: 512 * 1000 * 1000 }

		}

	},
	NONE: {

		node: {}

	},
	BLANK: {}

}

# sample object for a node in the database
sample_node_obj = {}

# checks warnings that we check for
describe 'metrics', ->

	# require in the service
	metric_service = require('../../goddard/services/metric')({})

	# handle the settings
	describe 'check()', ->

		# handle the error output
		it 'should give a few warnings if the payload is blank', ->

			# test the check
			metric_service.check sample_node_obj, payloads.BLANK, (err, warning_strs) ->

				# check that error is none
				assert( not err , 'Error was given' )

				# get the warning
				assert( warning_strs.length > 0 , 'no warnings should be returned for a blank payload' )

		# handle the settings
		describe 'NODE', ->

			# handle the error output
			it 'should give a warning if the node did not have a payload', ->

				# test the check
				metric_service.check sample_node_obj, payloads.BLANK, (err, warning_strs) ->

					# check that error is none
					assert( not err , 'error was thrown' )

					# bgan error
					error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('report back any data') != -1

					# get the warning
					assert( error_str? , 'no warning given for bgan assuming bad' )

			# handle the settings
			describe 'memory', ->

				# handle the error output
				it 'should give a warning if no memory status was reported back', ->

					# test the check
					metric_service.check sample_node_obj, payloads.NONE, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('report back on memory information') != -1

						# get the warning
						if not error_str
							assert.fail('no warning was given')

				# handle the error output
				it 'should give a warning if free memory is below 1GB', ->

					# test the check
					metric_service.check sample_node_obj, payloads.LOWMEMORY, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('on node is 1gb or under') != -1

						# get the warning
						if not error_str
							assert.fail('no warning was given')

				# handle the error output
				it 'should give a warning if free memory is equal to 1GB', ->

					# test the check
					metric_service.check sample_node_obj, payloads.EQUALMEMORY, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('on node is 1gb or under') != -1

						# get the warning
						if not error_str
							assert.fail('no warning was given')

				# handle the error output
				it 'should not give a warning if memory is higher than 1GB', ->

					# test the check
					metric_service.check sample_node_obj, payloads.HIGHMEMORY, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('on node is 1gb or under') != -1

						# get the warning
						if error_str
							assert.fail('warning was given')

			# handle the settings
			describe 'disk', ->

				# handle the error output
				it 'should give a warning if no disk status was reported back', ->

					# test the check
					metric_service.check sample_node_obj, payloads.NONE, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('not report back on disk information') != -1

						# get the warning
						if not error_str
							assert.fail('no warning was given')

				# handle the error output
				it 'should give a warning if free disk space is below 10GB', ->

					# test the check
					metric_service.check sample_node_obj, payloads.LOWDISK, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('on node is 10gb or under') != -1

						# get the warning
						if not error_str
							assert.fail('no warning was given')

				# handle the error output
				it 'should give a warning if free disk space is equal to 10GB', ->

					# test the check
					metric_service.check sample_node_obj, payloads.EQUALDISK, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('on node is 10gb or under') != -1

						# get the warning
						if not error_str
							assert.fail('no warning was given')

				# handle the error output
				it 'should not give a warning if disk space is higher than 10GB', ->

					# test the check
					metric_service.check sample_node_obj, payloads.HIGHDISK, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('on node is 10gb or under') != -1

						# get the warning
						if error_str
							assert.fail('warning was given')

			# handle the settings
			describe 'load', ->

				# handle the error output
				it 'should give a warning if no load status was reported back', ->

					# test the check
					metric_service.check sample_node_obj, payloads.NONE, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('did not report back on system load') != -1

						# get the warning
						if not error_str
							assert.fail('no warning was given')

				# handle the error output
				it 'should give a warning if the 5 minute load is under 2', ->

					# test the check
					metric_service.check sample_node_obj, payloads.LOWLOAD, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('was over 2 for the last 5 minutes') != -1

						# get the warning
						if error_str
							assert.fail('no warning was given')

				# handle the error output
				it 'should give a warning if the 5 minute load is over 2', ->

					# test the check
					metric_service.check sample_node_obj, payloads.HIGHLOAD, (err, warning_strs) ->

						# check that error is none
						if err
							assert.fail('error was thrown')

						# bgan error
						error_str = _.find warning_strs or [], (error_str) -> error_str.toLowerCase().indexOf('was over 2 for the last 5 minutes') != -1

						# get the warning
						if not error_str
							assert.fail('no warning was given')
		    
