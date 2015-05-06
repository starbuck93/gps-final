--======================================================================--
--== Coronium GS Client
--======================================================================--
local gs = require( 'gs.CoroniumGSClient' ):new()
local p = gs.p --== Pretty Printer

local widget = require( 'widget' )
--======================================================================--
--== Game Code
--======================================================================--

local function btnRelease( )
	gs:send( { love = 1 } )
end

--== Game Code Goes Here
local btn = widget.newButton({
	label = "Love",
	x = display.contentCenterX,
	y = 400,
	width = 300,
	height = 200,
	fontSize = 24,
	onEvent = btnRelease
})


local p1_love = display.newText({
	text = "P1 Loved: 0",
	x = display.contentCenterX,
	y = 100,
	width = display.contentWidth,
	height = 60,
	fontSize = 16,
	align = 'center'
})

local p2_love = display.newText({
	text = "P2 Loved: 0",
	x = display.contentCenterX,
	y = 180,
	width = display.contentWidth,
	height = 60,
	fontSize = 16,
	align = 'center'
})

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

	btn:setEnabled( true )
end

function onGameData( event )
	p( event.data )

	local d = event.data

	p1_love.text = "P1 Loved: " .. d.p1_loved
	p2_love.text = "P2 Loved: " .. d.p2_loved
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

	--gs:createGame( 2 ) --P1
	gs:joinGame( 2 ) --P2
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
	key = 'abc',
	ping = true
}
gs:connect( connection )