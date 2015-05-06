--======================================================================--
--== Coronium Cloud connector
--== @copyright Chris Byerley @develephant
--== @year 2014
--== @version 1
--== @license 2-clause BSD
--======================================================================--
local http = require( 'http' )
local json = require( 'json' )
local string = require( 'string' )

local Emitter = require( 'core' ).Emitter
local Cloud = Emitter:extend()

--- Create a new Cloud connector instance
-- @function new
-- @tparam string The Coronium Cloud instance
-- host address.
-- @tparam string The Coronium Cloud instance
-- API KEY.
-- @usage local cc = Cloud:new('coronium.host.ip', 'CORONIUM_API_KEY')
function Cloud:initialize( endpoint, api_key )
	self.endpoint = endpoint
	self.api_key = api_key
end

--- Run a cloud code file on the Coronium instance.
-- @tparam string lua_file_ref The code file to run.
-- Do not include the .lua extension.
-- @tparam[opt=nil] table params_tbl An optional parameter table
-- for the cloud code to utilize.
-- @usage cc:on( "CloudData", function( result )
--    p( result )--== Result is a table
-- end )
-- cc:run( 'some_cloud_file', { param = value } )
function Cloud:run( lua_file_ref, params_tbl )

	local content_len = 0
	local content = ""

	if params_tbl then
		local success, result = pcall( json.stringify, params_tbl )
		if success then
			content_len = string.len( result )
			content = result
		else
			self:emit( "CloudError", "Table data could not be converted to JSON" )
		end
	end

	local options =
	{
		host = self.endpoint,
		port = '80',
		path = '/1/code/' .. lua_file_ref,
		method = 'POST',
		headers =
		{
			["X-Coronium-API-KEY"] = self.api_key,
			["Content-Length"] = content_len
		}
	}

	local req = http.request( options, function( res )

		local postBuffer = ''
		res:on( 'data', function( chunk )
			postBuffer = postBuffer .. chunk
		end)
		res:on( 'end', function()
			local success, result = pcall( json.parse, postBuffer )
			if success then
				self:emit( "CloudData", result )
			else
				self:emit( "CloudError", nil )
			end
		end)
	end)

	req:write( content )
	req:done()
end

--== Return class
return Cloud
