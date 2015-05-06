--======================================================================--
--== Coronium GS
--======================================================================--
local gs = require( 'CoroniumGS' ):new( 7173, 'abc' )
--======================================================================--
--== Game Code
--======================================================================--

--== Game Code Goes Here

--======================================================================--
--== Game Events
--======================================================================--
local function onGameCreate( game )
	p( "--== Game Created ==--" )
	p( game:getId() )

	game:setData({
		won = 0,
		lost = 0,
		tied = 0
	})
end

local function onGameJoin( game, player )
	p( "--== Game Joined ==--" )
	p( game:getId(), player:getId() )
end

local function onGameStart( game, players )
	p( "--== New Game Started " .. game:getId() .. " ==--" )
	p( "Games", gs:getGameCount() )
end

local function onGameLeave( game, player )
	p( "--== Game Leave ==--" )
	p( game:getId(), player:getId() )
end

local function onGameClose( game_id )
	p( "--== Game Closed ==--" )
	p( game_id )
end
--======================================================================--
--== Client Events
--======================================================================--
local function onClientData( client, data )
	local game = gs:getPlayerGame( client )
	if game then
		if data.roll then
			local player_roll = data.value
			local server_roll = math.random( 12 )

			if player_roll > server_roll then
				--won
				game.data.won = game.data.won + 1
			elseif player_roll < server_roll then
				--lost
				game.data.lost = game.data.lost + 1
			else
				--tie
				game.data.tied = game.data.tied + 1
			end

		elseif data.stats then
			game:publishGameData()
		end
	end
end

local function onClientConnect( client )
	p( '--== Client Connected ==--' )
	p( client:getHost() )
end

local function onClientClose( client )
	p( '--== Client Closed ==--' )
end

local function onClientTimeout( client )
	p( '--== Client Timeout ==--' )
	p( client:getHost()  )
end

local function onClientError( client, error )
	p( '--== Client Error ==--' )
	p( error )
end
--======================================================================--
--== GameManager Handlers
--======================================================================--
gs:on( "GameStart", onGameStart )
gs:on( "GameCreate", onGameCreate )
gs:on( "GameJoin", onGameJoin )
gs:on( "GameLeave", onGameLeave )
gs:on( "GameClose", onGameClose )
--======================================================================--
--== Client Handlers
--======================================================================--
gs:on( "ClientConnect", onClientConnect )
gs:on( "ClientData", onClientData )
gs:on( "ClientError", onClientError )
gs:on( "ClientClose", onClientClose )
gs:on( "ClientTimeout", onClientTimeout )
