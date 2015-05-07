--======================================================================--
--== Coronium GS Client
--======================================================================--
local gs = require( 'gs.CoroniumGSClient' ):new()
local widget = require('widget')
local p = gs.p --== Pretty Printer
--======================================================================--
--== Game Code
--======================================================================--

local composer = require( "composer" )

local scene = composer.newScene()

currentLocation = {longitude = 0, latitude = 0, accuracy = 100}





function updateLocation( event )
    p(event)
    currentLocation.latitude = event.latitude
    currentLocation.longitude = event.longitude
    currentLocation.accuracy = event.accuracy
    gs:send(currentLocation)
end

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

local player_cnt = tonumber(numPlayersGet) --initialize the variable


--======================================================================--
--== Game Events
--======================================================================--
function onGameCreate( event )
    p( event.data )
end

function onGameCancel( event )
    p( event.data )
end

function onGameJoin( event )
    p( event.data )
end

function onGameStart( event )
    p( "game started" )

    gameGroup = display.newGroup()
    local image = display.newImageRect( "map2.png", (display.contentWidth+50)*0.8017446, (display.contentWidth+50) ) --1011x1261
    -- image.anchorY = 0
    image.y = display.contentCenterY
    image.x = display.contentCenterX
    -- localGroup:insert(image)

    local imagebg = display.newImageRect( "mapbg.png", display.actualContentHeight+50, display.contentWidth )
    -- imagebg.anchorY = 0
    imagebg.y = display.contentCenterY
    imagebg.x = display.contentCenterX
    imagebg:toBack()
    imagebg:rotate(90)

    yourTeam = display.newText(
    {
        text = "team",     
        x = display.contentCenterX,
        y = 10,
        width = display.contentWidth,
        font = native.systemFontBold,   
        fontSize = 18,
        align = "center"  --new alignment parameter
    })
    yourTeam:setFillColor(.7,0,.5)

    circleGroup = display.newGroup( )
    local circ1 = display.newCircle( display.contentCenterY, display.contentCenterX, 7 )
    circ1:setFillColor( 1,1,1 )
    local circ2 = display.newCircle( display.contentCenterY, display.contentCenterX, 5 )
    circ2:setFillColor( 1,0,0 )
    local circ3 = display.newCircle( display.contentCenterY, display.contentCenterX, 2 )
    circ3:setFillColor( 1,1,1 )

    circleGroup:insert( circ1 )
    circleGroup:insert( circ2 )
    circleGroup:insert( circ3 )
    circleGroup.anchorChildren = true
    circleGroup.x = display.contentCenterX
    circleGroup.y = display.contentCenterX
    circleGroup.anchorX = .5
    circleGroup.anchorY = .5
    
    -->>atrium
    transition.to( circleGroup, {time=1500, x=(display.contentCenterX+32), y=(display.contentCenterY+115)} )

    -- if event.data.location[1] == place[1] then
    -- >>down the hall    transition.to( circleGroup, {time=1500, x=(display.contentCenterX+18), y=(display.contentCenterY+91)} )
    -- end

    -- if event.data.location[2] == place[2] then
    --  candy lab>>   transition.to( circleGroup, {time=1500, x=(display.contentCenterX+18), y=(display.contentCenterY+108)} )
    -- end
end

function onGameData( event )
    p( event.data )
end

function onGameLeave( event )
    p( event.data )
end

function onGameDone()
    p( 'Game Done' )
    display.remove( gameGroup )
    display.remove( my_number )
    local ending = display.newText( {
        text = "Game Over, Let's play again!",
        x = display.contentCenterX,
        y = display.contentCenterY,
        width = display.contentWidth,
        font = native.systemFont,
        fontSize = 24,
        align = 'center'
        } )
    gs:reconnect( 5000 )
    timer.performWithDelay( 4000, function ()
        display.remove( ending )
    end )
end

--======================================================================--
--== Client Events
--======================================================================--
local function onClientData( event )
    p( event.data )
    local data = event.data
    if yourTeam and data.yourTeam then
        yourTeam.text = "Team " .. data.yourTeam.team
        yourTeam:setFillColor(data.yourTeam.color)
    end


--ADD TARGET--
--Reason it's under on client data, is that when he is at the varified location,
--the target moves to another place.

end

local function onClientConnect( event )
    p( "client connected" )
    display.remove(waitingToConnect)
    local asd1 = display.newText( {
        text = "Connected to " .. ipTextGet .. "\n\nClick Play to continue.",
        x = display.contentCenterX,
        y = display.contentCenterY/2,
        width = display.contentWidth,
        font = native.systemFont,
        fontSize = 18,
        align = 'center'
        } )
    local function onButtonTap( event )
        local btn_id = event.target.id
        if btn_id == 'play' then
            gs:send({play=1}) --player_num=player_cnt
            display.remove(connect_grp)
        end
    end
        
    connect_grp = display.newGroup()

    local b1 = widget.newButton( {
        label = "Play",
        id = 'play',
        x = display.contentCenterX,
        y = display.contentCenterY,
        width = display.contentWidth/2,
        onRelease = onButtonTap
        } )
    connect_grp:insert(b1)
    connect_grp:insert(asd1)

    --GPS stuff starts here
    Runtime:addEventListener( "location", updateLocation )


end

local function onClientClose( event )
    p( "client closed" )
end

local function onClientPing( event )
    p( "timestamp: " .. event.data )
end

function onClientError( event )
    p( "error: " .. event.data )
end    


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view


end

--======================================================================--
--== Game Handlers
--======================================================================--
gs.events:on( "GameCreate", onGameCreate )
gs.events:on( "GameCancel", onGameCancel )
gs.events:on( "GameJoin", onGameJoin )
gs.events:on( "GameStart", onGameStart )
gs.events:on( "GameData", onGameData )
gs.events:on( "GameLeave", onGameLeave )
gs.events:on( "GameDone", onGameDone )
--======================================================================--
--== Client Handlers
--======================================================================--
gs.events:on( "ClientData", onClientData )
gs.events:on( "ClientConnect", onClientConnect )
gs.events:on( "ClientClose", onClientClose )
gs.events:on( "ClientPing", onClientPing )
gs.events:on( "ClientError", onClientError )
--======================================================================--
--== Server Connection
--======================================================================--

waitingToConnect = display.newText( {
    text = "Connecting...",
    x = display.contentCenterX,
    y = display.contentCenterY,
    width = display.contentWidth,
    font = native.systemFont,
    fontSize = 24,
    align = 'center'
    } )


local ip = ipTextGet
local keyValue = getKeyValue

local connection = 
{
    host = ip,
    port = 7173,
    handle = "rap10c",
    data = 
    {
        maxPlayers = player_cnt,
        numTeams = numTeamsGet,
    },
    key = keyValue,
    ping = true
}
gs:connect( connection )



-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene