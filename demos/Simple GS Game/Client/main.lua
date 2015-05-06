--======================================================================--
--== Coronium GS Client
--======================================================================--
local gs = require( 'gs.CoroniumGSClient' ):new()
local p = gs.p --== Pretty Printer

local UI = require( 'ui.UI' )
--======================================================================--
--== Game Code
--======================================================================--

local function btnHandler( target )
	local btn_name = target:getText()
	if btn_name == "Roll" then
		local roll = math.random( 12 )
		gs:send( { roll = 1, value = roll } )
	elseif btn_name == "Stats" then
		gs:send( { stats = 1 } )
	end
end
local ui = UI:draw( btnHandler )

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
end

local function onClientConnect( event )
	p( "client connected" )

	gs:joinGame( 2 )
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
	host = 'ping.coronium.gs',
	port = 7173,
	handle = 'Nickname',
	key = 'abc',
	ping = true
}
gs:connect( connection )