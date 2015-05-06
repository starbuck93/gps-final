--======================================================================--
--== Coronium GS Client
--======================================================================--
local gs = require( 'gs.CoroniumGSClient' ):new()
local p = gs.p --== Pretty Printer
--======================================================================--
--== Game Code
--======================================================================--

--== Game Code Goes Here
local UI = require( 'ui.UI' ):new()
local ui

local function onFldListener( e )

	if e.phase == "ended" or e.phase == "submitted" then
		gs:send( { msg = ui.in_txt.text } )
	end

end
ui = UI:draw( onFldListener )
--======================================================================--
--== Game Events
--======================================================================--
function onGameCreate( event )
	p( event.data )
end

function onGameJoin( event )
	p( event.data )
end

function onGameStart( event )
	p( "game started" )
	p( event.data )
end

function onGameData( event )
	p( event.data )
end

function onGameLeave( event )
	p( event.data )
end

function onGameDone()
	p( 'Game Done' )
end
--======================================================================--
--== Client Events
--======================================================================--
local function onClientData( event )
	p( event.data )

	if event.data.msg then
		ui.ms_txt.text = ui.ms_txt.text .. "\n" .. event.data.msg
	end
end

local function onClientConnect( event )
	p( "client connected" )

	gs:joinGame( 0, { world = 1 } )
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
--======================================================================--
--== Game Handlers
--======================================================================--
gs.events:on( "GameCreate", onGameCreate )
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
local connection = 
{
	host = 'ec2-54-84-5-240.compute-1.amazonaws.com',
	port = 7173,
	handle = 'Nickname',
	data = 
	{
		color = "blue",
	},
	key = 'abc',
	ping = true
}
gs:connect( connection )