--======================================================================--
--== Coronium GS
--======================================================================--
local gs = require( 'CoroniumGS' ):new( 7173, 'abc' )
local table = require( 'table' )
local string = require( 'string' )
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

	local game_data = {
		game_phase = "starting",
		player_1_board = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		player_2_board = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
		player_1_spots = {},
		player_2_spots = {},
		player_turn = 1,
		player_1_ready = false,
		player_2_ready = false,
	}
	game:setData( game_data )
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
	--== Pull game
	local game = gs:getPlayerGame( client )
	local players = game:getPlayers()

	local player_num = client:getPlayerNum()

	--======================================================================--
	--== Board request
	--======================================================================--
	if data.get_board then
		--== Pull game data
		p( 'board' )
		local player_board = game.data[ "player_"..player_num.."_board" ]
		client:send( { player_board = 1, board = player_board } )
	--======================================================================--
	--== Add a spot
	--======================================================================--
	elseif data.spot then
		table.insert( game.data[ "player_"..player_num.."_spots" ], data.spot )
	--======================================================================--
	--== Player is ready
	--======================================================================--
	elseif data.player_ready then

		game.data["player_"..player_num.."_ready"] = true

		if not err then
			if game.data.player_1_ready and game.data.player_2_ready then
				for _, player in ipairs( players ) do
					local p_num = player:getPlayerNum()
					local player_board = game.data[ "player_"..p_num.."_board" ]
					player:send( { 
						players_ready = 1, 
						starting_player = 1, 
						board = player_board
					 } )
				end
			else
				client:send( { set_phase = 1, phase = "waiting" } )
			end
		end
	--======================================================================--
	--== Try a spot
	--======================================================================--
	elseif data.try_spot then

		local spot = data.try_spot

		local check_num
		if player_num == 1 then
			check_num = 2
		else
			check_num = 1
		end

		local player_hit = 0
		local player_missed = 0

		for s=1, #game.data[ "player_"..check_num.."_spots" ] do
			local chk_spot = game.data[ "player_"..check_num.."_spots" ][ s ]
			if chk_spot == spot then
				player_hit = check_num
				game.data[ "player_"..check_num.."_spots" ][ s ] = 0
				break
			end
		end
		--======================================================================--
		--== Player hit
		--======================================================================--
		if player_hit > 0 then
		
			--player who hit
			if game.data[ "player_"..player_num.."_board" ][ spot ] == 1 then
				game.data[ "player_"..player_num.."_board" ][ spot ] = 2
			else
				game.data[ "player_"..player_num.."_board" ][ spot ] = 3
			end
			local player = game:getPlayerByNumber( player_num )
			player:send( { did_hit = 1, board = game.data[ "player_"..player_num.."_board" ] } )

			--player who got hit
			if game.data[ "player_"..check_num.."_board" ][ spot ] == 3 then
				game.data[ "player_"..check_num.."_board" ][ spot ] = 2
			else
				game.data[ "player_"..check_num.."_board" ][ spot ] = 1	
			end
			local player = game:getPlayerByNumber( check_num )
			player:send( { got_hit = 1, board = game.data[ "player_"..check_num.."_board" ]} )
		else
			--missed
			if game.data[ "player_"..player_num.."_board" ][ spot ] ~= 1 then
				game.data[ "player_"..player_num.."_board" ][ spot ] = 4
			end

			for _, player in ipairs( players ) do
				local player_num = player:getPlayerNum()
				player:send( { missed = 1, player_turn = check_num, board = game.data[ "player_"..player_num.."_board" ] } )
			end
		end

		--======================================================================--
		--== Check winner
		--======================================================================--
		if not err then

			--check for winner
			local losing_player = nil
			for _, player in ipairs( players ) do
				local p_num = player:getPlayerNum()
				local spots = game.data[ "player_"..p_num.."_spots" ]
				--add em up
				local result = 0
				for s=1, #spots do
					result = result + spots[ s ]
				end
				if result == 0 then --lost
					losing_player = player
				end
			end

			if losing_player then
				--game done
				local winning_player = 0
				if losing_player:getPlayerNum() == 1 then
					winning_player = 2
				else
					winning_player = 1
				end

				game:broadcast( { game_done = 1, winning_player = winning_player } )

			end
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
