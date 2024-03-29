--candy lab { acc = 4, lat = 32.46771913, dir = 132.60000610352, long = -99.70717037, time = 1431035056.197, alt = 461, speed = 2.2289459705353 }
--end of the hall { acc = 6, lat = 32.46786666, dir = 0, long = -99.70718488, time = 1431035209, alt = 496, speed = 0 }

function makePoint ( inX, inY )
   return { shape="point", point= {x= inX, y= inY} }
end

function makeLine ( p1, p2 )
   return { shape="line", points= {p1, p2} }
end

function makePolygon ( points )
   return { shape="polygon", points= points}
end

function makePolyline ( points )
   return { shape="polyline", points= points }
end

function makeCircle ( center, radius )
   return { shape="circle", center= center, radius= radius}
end

function shapeToString ( inShape )
--   p ( 'shapeToString begin')
   s = ""
   if inShape ~= nil then
      if inShape.shape then
	 if inShape.shape == 'line' then
	    local p1 = inShape.points[1].point
	    local p2 = inShape.points[2].point
	    s = "line ".. p1.x.. ','.. p1.y.. ' '.. p2.x.. ','.. p2.y
	 elseif inShape.shape == 'point' then
	    s = "point ".. inShape.point.x.. ','.. inShape.point.y
	 elseif inShape.shape == 'polyline' then
	    local pts= inShape.points
	    s = 'polygon '
	    for i=1,#pts do
	       s = s.. pts[i].point.x.. ','.. pts[i].point.y.. ' '
	    end
	 elseif inShape.shape == 'polygon' then
	    local pts= inShape.points
	    s = 'polyline '
	    for i=1,#pts do
	       s = s.. pts[i].point.x.. ','.. pts[i].point.y.. ' '
	    end
	 elseif inShape.shape == 'circle' then
	    local pt= inShape.center.point
	    s= 'circle '.. pt.x.. ','.. pt.y.. ' radius '.. inShape.radius
	 end
      end
   end
   return s
end


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
-- allTeams[0]={team="Danny BoBanny", color={0,153/255,0} }


numTeamsGame = -1


local function autoNegotiate(client,players,teams)

	local game_count = gs:getGameCount( { players_max = players, game_state = 'open' } )

	if game_count == 0 then
		gs:createGame( client, players, {teams=teams} )
		local game = gs:getPlayerGame(client)
		-- p(game:getId())
		local yellow = game:getData()
		yellow.teams = teams
		-- numTeamsGame = teams
		p("autoNegotiate yellow",yellow,"yellow!!!!")
		game:setData(yellow)
	else
		gs:addToGameQueue( client, players, {teams=teams})
	end


end

--======================================================================--
--== Game Events
--======================================================================--
local function onGameCreate( game )
	p( "--== Game Created ==--" )
	p( game:getId() )
	p("game created",game:getData(),"<<<<------")
	-- game:setData( { teams = tonumber(numTeamsGame) } )
end

local function onGameJoin( game, player )
	p( "--== Game Joined ==--" )
	p( game:getId(), player:getId() )
end

local function onGameStart( game, players )
	p( "--== New Game Started " .. game:getId() .. " ==--" )
	p( "Games", gs:getGameCount() )
	p( players )

	-- game:setData( { teams = numTeamsGame } )
	local playersTable = game:getPlayers()
	-- p(playersTable)
	p("Game Started data",game:getData(),"<<<<<<------")

	teamGameTable = {}

	local i = 1
	for key,value in pairs(playersTable) do 

		index = i%game.data.teams+1
	    data = playersTable[key]:getPlayerData()
	    data.team = allTeams[index].team
	    p("client is on this team",allTeams[index].team)
	    data.done = false
	    playersTable[key]:setPlayerData( data )
	    p(index,data)
	    playersTable[key]:send( { yourTeam = allTeams[index].team } )
	    -- teamGameTable[index].players = {}
	    -- teamGameTable[index].players[i] = playersTable[key] --holding onto each client in the team table to make sending easier later
	    						--to nerf through this array we will need to mod by the number of teams
	    i = i+1
	end

	p("Here are the team number",game.data.teams)
	for i=1,game.data.teams do --set up the main teams data table
		teamGameTable[i] = {
			name = allTeams[i].team, 
			roundsComplete = 0, 
			currentChallenge = { 
				name="CandyLab",
				pointX=-99.70717037,
				pointY=-99.70717037,
				accuracy = 6,
				shape="point",
				done=false 
			},
		}
	end


	local asdf = game:getData()
	asdf.teamData = teamGameTable
	game:setData( asdf )

	local player_cnt = game:getPlayerCount()

	-- startGame(game,players)
	-- checkTeams(game,players)

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
	local game = gs:getPlayerGame( client )

	if (data.play) then
		autoNegotiate( client,tonumber(blee.maxPlayers),tonumber(blee.numTeams))

	elseif (data.gpsUpdate) then

		local setData = client:getPlayerData()
		setData.currentPos = { lat = data.gpsUpdate.latitude, long = data.gpsUpdate.longitude, accuracy = data.gpsUpdate.accuracy }
		client:setPlayerData( setData )
		blee = client:getPlayerData()

		--which location your team is currently on
		local myTeam = client:getPlayerData().team
		local teamIndex = -1
		local goal = {}
		p("This is how many teams:",game:getData().teams)
		for i=1,game:getData().teams do --grab the current challenge(x,y) of the team by looping through until thisTeam = the game.data.teamData[i]
			p("i = ", i, "<<<---=-=-=-=-=-")
			p("teamName",game.data.teamData[i])
			p("thisteam",myTeam)
			if (game.data.teamData[i].name == myTeam) then
				teamIndex = i
				p("IMPORTNATASD",teamIndex)
				goal = game.data.teamData[teamIndex].currentChallenge
			end 
		end
		p("There should be data here ---->>>>",game.data.teamData[teamIndex],"<<<<----")
	    -- local latData = (( data.latitude - goal.pointX ) * 110895.047493596 )
	    -- local longData = (( data.longitude - goal.pointY ) * 94007.9131628372 )

	    --Let's check if the client is done
	    -- we need to take into account the accuracy of the GPS and the delta that we're given
	    --convert the delta to GPS decimal stuff
	    local delta = goal.accuracy/11
	    delta = delta*(1/1000)
	    delta = tonumber(delta)

	    local clientAcc = blee.currentPos.accuracy/11
	    clientAcc = clientAcc*(1/1000)
	    clientAcc = tonumber(clientAcc)

	    if( ((blee.currentPos.lat+clientAcc <= goal.pointY+delta) and (blee.currentPos.lat+clientAcc >= goal.pointY-delta)) and ((blee.currentPos.long+clientAcc <= goal.pointX+delta) and (blee.currentPos.long+clientAcc >= goal.pointX-delta)) or
	    	((blee.currentPos.lat-clientAcc <= goal.pointY+delta) and (blee.currentPos.lat-clientAcc >= goal.pointY-delta)) and ((blee.currentPos.long-clientAcc <= goal.pointX+delta) and (blee.currentPos.long-clientAcc >= goal.pointX-delta))) then

	    	blee.done = true
	    	client:setPlayerData( blee )
	    	blee = client:getPlayerData()
	    end

	    --check if an entire team is done
	    --loop through every client and grab their team name
	    --for each client, if the team name matches the current client's team then see if they're done
	    --if they're done then alert the team data that the currentChallenge is done
	    local isMyTeamDone = {}

	    local j = 1
	    if(blee.done) then
			for key,value in pairs(playersTable) do 
			    teammate = playersTable[key]:getPlayerData()
			    if (teammate.team == blee.team) then --and not (teammate == blee))
		    		isMyTeamDone[j] = teammate.done
		    		j = j + 1
			    end
			end
		end
		p("is my team done?",isMyTeamDone,"<<<<<<<<<<<<<<<<<<<<")
		for i=1,j do
			if ( not (isMyTeamDone[i] == true) ) then
				break
			end
			--if I've reached this point then that means the team is done and we can move on to the next challenge
			game.data.teamData[teamIndex].currentChallenge.done = true -- might need to get and set the game data...
		end

	    --if your team is at the location, move the location to the next one!
	    if(game.data.teamData[teamIndex].currentChallenge.done) then
	    	local blue = game:getData()
	    	blue.teamData[teamIndex].roundsComplete = blue.teamData[teamIndex].roundsComplete + 1
	    	
	    	if( blue.teamData[teamIndex].roundsComplete == 1) then
	    		blue.teamData[teamIndex].currentChallenge.name = "southSideMaybee"
	    		blue.teamData[teamIndex].currentChallenge.pointX=32.46747
	    		blue.teamData[teamIndex].currentChallenge.pointY=-99.70690
	    		blue.teamData[teamIndex].currentChallenge.accuracy = 5
	    	elseif ( blue.teamData[teamIndex].roundsComplete == 2 ) then
	    		blue.teamData[teamIndex].currentChallenge.name = "stuff"
	    		blue.teamData[teamIndex].currentChallenge.pointX=x
	    		blue.teamData[teamIndex].currentChallenge.pointY=y
	    		blue.teamData[teamIndex].currentChallenge.accuracy = 8
	    	end
    		
    		blue.teamData[teamIndex].currentChallenge.done = false

    		game:setData(blue) --return the data
	    end
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
