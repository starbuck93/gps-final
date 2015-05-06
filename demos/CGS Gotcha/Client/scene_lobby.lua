--======================================================================--
--== Coronium GS Gotcha 'Lobby' Scene
--== Author: Chris Byerley
--== Twitter: @develephant
--======================================================================--
local globals = require( 'globals' )
local gs = globals.gs
local p = gs.p

local composer = require( "composer" )
local scene = composer.newScene()

local UI = require( 'ui.UI' )
local ui = UI:new()

local widget = require( 'widget' )
--======================================================================--
--== Game handlers
--======================================================================--
local function onGameStart( event )
    p( event.data )

    local d = event.data
    
    globals.game_id = d.game_id
    globals.player_name = d.player_name
    globals.player_num = d.player_num

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

        globals.phase = 'waiting'

        ui_lobby = ui:drawLobby()
        sceneGroup:insert( ui_lobby.grp )

    elseif ( phase == "did" ) then

    local function onClientConnect( event )

        local createBtn, joinBtn

        local function onCreateGame( btn )
            gs:createGame( 2 )
            createBtn.isVisible = false
            joinBtn.isVisible = false

            ui_lobby.waiting_txt.text = "Waiting..."
        end

        local function onJoinGame( btn )
            gs:joinGame( 2 )
            createBtn.isVisible = false
            joinBtn.isVisible = false

            ui_lobby.waiting_txt.text = "Waiting..."
        end

        --== Add some buttons
        createBtn = widget.newButton({
            label = "Create game",
            x = display.contentCenterX,
            y = 60,
            width = 200,
            height = 80,
            onRelease = onCreateGame
        })

        joinBtn = widget.newButton({
            label = "Join game",
            x = display.contentCenterX,
            y = 120,
            width = 200,
            height = 80,
            onRelease = onJoinGame
        })

        sceneGroup:insert( createBtn )
        sceneGroup:insert( joinBtn )

    end

        --== Listen for game started
        gs.events:on( "ClientConnect", onClientConnect )
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
        gs.events:removeEventListener( "GameStart", onGameStart )
        gs.events:removeEventListener( "ClientConnect", onClientConnect )

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