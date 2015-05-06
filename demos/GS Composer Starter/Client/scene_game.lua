--======================================================================--
--== Coronium GS PANIC 'Game' Scene
--== Author: Chris Byerley
--== Twitter: @develephant
--======================================================================--
local game = require( 'game' )
local gs = game.gs
local p = gs.p

local composer = require( "composer" )
local scene = composer.newScene()

--======================================================================--
--== Game/Client handlers
--======================================================================--
local function onGameData( event )
    p( event.data )
end

local function onClientData( event )
    p( event.data )
end

local function onClientPing( event )
    p( event.data )
end

local function onClientClose( event )
    p( event.data )
end
--======================================================================--
--== Scene handlers
--======================================================================--

--== "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

--== "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then

        --== Listen for GameData
        gs.events:on( "GameData", onGameData )

        --== Listen for ClientData
        gs.events:on( "ClientData", onClientData )

        --== Listen for pingu
        gs.events:on( "ClientPing", onClientPing )

        --== Listen for ClientClose
        gs.events:on( "ClientClose", onClientClose )

        print( 'game' )
        
    end
end

--== "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        --== Clear GS listeners
        gs.events:removeEventListener( "GameData", onGameData )
        gs.events:removeEventListener( "ClientData", onClientData )
        gs.events:removeEventListener( "ClientPing", onClientPing )
        gs.events:removeEventListener( "ClientClose", onClientClose )

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