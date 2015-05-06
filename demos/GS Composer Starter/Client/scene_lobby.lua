--======================================================================--
--== Coronium GS PANIC 'Lobby' Scene
--== Author: Chris Byerley
--== Twitter: @develephant
--======================================================================--
local game = require( 'game' )
local gs = game.gs
local p = gs.p

local composer = require( "composer" )
local scene = composer.newScene()

local function onClientConnect( event )
    gs:createGame( 2 )
end
--======================================================================--
--== Game handlers
--======================================================================--
local function onGameStart( event )
    p( event.data )

    local d = event.data
    
    game.game_id = d.game_id
    game.player_name = d.player_name
    game.player_num = d.player_num

    composer.gotoScene( 'scene_game' )

end

--======================================================================--
--== Scene handlers
--======================================================================--

--== "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

end

--== "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then

        --== Listen for client connect
        gs.events:on( "ClientConnect", onClientConnect )

        --== Listen for game started
        gs.events:on( "GameStart", onGameStart )

        --== Connect GS
        local connection = 
        {
            host = 'ping.coronium.gs',
            port = 7173,
            key = 'abc',
            ping = true
        }
        gs:connect( connection )

        print( 'lobby' )
    end
end

--== "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        
        --== Remove GS listeners
        gs.events:removeEventListener( "ClientConnect", onClientConnect )
        gs.events:removeEventListener( "GameStart", onGameStart )

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end

--== "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end

--======================================================================--
--== Listeners
--======================================================================--

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene