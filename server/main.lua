local shapes = require('shapes')

--======================================================================--
--== Coronium GS
--======================================================================--
local gs = require( 'CoroniumGS' ):new( 7173, 'lol' )
--======================================================================--
--== Game Code
--======================================================================--

allTeams = {}
allTeams[1]={team="Purple Wildcats", color={51/255,0,51/255} }
allTeams[2]={team="Blinken Finken", color={0,204/255,0} }
allTeams[3]={team="Fire Nation", color={1,0,0} }
allTeams[4]={team="Galactic Republic", color={0,0,204/255} }
allTeams[5]={team="CIS", color={1,1,51/255} }
allTeams[6]={team="Toodle Dums", color={153/255,153/255,255} }
allTeams[7]={team="Pollo", color={1,1,0} }
allTeams[8]={team="Jakel's Minions", color={1,1,0} }
allTeams[9]={team="Corona Bandits", color={1,0,127} }
allTeams[0]={team="Danny BoBanny", color={0,153/255,0} }

staticPoints = {}
staticPoints[0] = { point = makePoint(0,0) }
staticPoints[1] = { point = makePoint(0,0) }
staticPoints[2] = { point = makePoint(0,0) }
staticPoints[3] = { point = makePoint(0,0) }
staticPoints[4] = { point = makePoint(0,0) }

numTeamsGame = 0


local function autoNegotiate(client,players,teams)

	local game_count = gs:getGameCount( { players_max = players, game_state = 'open' } )

	if game_count == 0 then
		gs:createGame( client, players, {teams=teams} )
	else
		gs:addToGameQueue( client, players, {teams=teams})
	end

	local game = gs:getPlayerGame(client)
	p(game:getId())
	numTeamsGame = teams
end

local function startGame( game, players )
	
	for key,value in players do
		if()
			
		end

	end
	game:broadcast( {  } )
end

local function checkTeams( game, players )
	while gameNotOver do

	end
end

--======================================================================--
--== Game Events
--======================================================================--
local function onGameCreate( game )
	p( "--== Game Created ==--" )
	p( game:getId() )
	game:setData( { teams = numTeamsGame } )
end

local function onGameJoin( game, player )
	p( "--== Game Joined ==--" )
	p( game:getId(), player:getId() )
end

local function onGameStart( game, players )
	p( "--== New Game Started " .. game:getId() .. " ==--" )
	p( "Games", gs:getGameCount() )
	p( players )

	game:setData( { teams = numTeamsGame } )
	local playersTable = game:getPlayers()
	p(playersTable)
	p(game:getData())

	teamGameTable = {}

	local i = 1
	for key,value in pairs(playersTable) do 

		index = game.data.teams%i
	    data = playersTable[key]:getPlayerData()
	    data.team = allTeams[index]
	    playersTable[key]:setPlayerData( data )
	    playersTable[key]:send( { yourTeam = allTeams[index] } )
	    teamGameTable[index].players[i] = playersTable[key] --holding onto each client in the team table to make sending easier later
	    						--to nerf through this array we will need to mod by the number of teams
	    i = i+1
	end

	local x = {1=100,2=200,3=300,4=400,5=500}
	local y = {1=100,2=200,3=300,4=400,5=500}

	for i=1,game.data.teams do --set up the main teams data table
		teamGameTable[i] = {
			name = allTeams[i], 
			roundsComplete = 0, 
			currentChallenge = { 
				point=shapes.makePoint(x[i],y[i]),
				shape="point",
				done=false 
			},
		}
	end


	game:setData( { teamData = teamGameTable } )

	local player_cnt = game:getPlayerCount()

	startGame(game,players)
	checkTeams(game,players)

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
	p( data )

	local blee = client:getPlayerData()

	if (data.play) then
		autoNegotiate( client,tonumber(blee.maxPlayers),tonumber(blee.numTeams))
	elseif (data.gpsUpdate) then
		setData = client:getPlayerData()
		setData.currentPos = { lat = data.latitude, long = data.longitude, accuracy = data.accuracy }
		client:setPlayerData( setData )
	end
end

local function onClientConnect( client )
	p( '--== Client Connected ==--' )
	p( client:getHost() )
	client.team = "default"
	client:send({yourTeam="default"})

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
