
# modules
assert = require('assert')
_ = require('underscore')

# sample object for a node in the database
sample_node_obj = {

	name: 'test',
	serial: '001',
	port: 1,
	mport: 2,
	id: 33,
	server: 'tunnel.goddard.com'

}

# checks warnings that we check for
describe 'node', ->

	# require in the service
	node_service = require('../../goddard/services/node')({})

	# handle the settings
	describe 'formatResponse()', ->

		# handle the error output
		it 'should return the basic structure as given', ->

			# test the check
			node_service.formatResponse sample_node_obj, (err, response_obj) ->

				# check that error is none
				assert( not err , 'Error was given' )

				# get the warning
				if response_obj.name != sample_node_obj.name
					assert.fail('Name did not match the input')

				# get the warning
				if response_obj.server != sample_node_obj.server
					assert.fail('Server did not match the input')

				# get the warning
				if response_obj.port.tunnel != sample_node_obj.port
					assert.fail('Tunnel Port did not match the input')

				# get the warning
				if response_obj.port.monitor != sample_node_obj.mport
					assert.fail('Monitor Port did not match the input')

		# handle the error output
		it 'should return a serial number that is padded to 5 characters', ->

			# test the check
			node_service.formatResponse sample_node_obj, (err, response_obj) ->

				# check that error is none
				assert( not err , 'Error was given' )

				# get the warning
				if response_obj.serial.length != 5
					assert.fail('Serial number returned was not padded to 5 characters')
	

			
		    
