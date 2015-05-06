--======================================================================--
--== Coronium GS Client-side
--== Gotcha : A multiplayer demo
--======================================================================--
--== Hide status bar
display.setStatusBar( display.HiddenStatusBar )
--== Background
local bg = display.newRect( 
	display.contentCenterX, 
	display.contentCenterY, 
	display.actualContentWidth, 
	display.actualContentHeight
)

bg:setFillColor( 244/255 )
--======================================================================--
--== Load Coronium GS client module
--======================================================================--
local CoroniumGS = require( 'gs.CoroniumGSClient' )
--======================================================================--
--== Game class (global)
--======================================================================--
local globals = require( 'globals' )
globals.gs = CoroniumGS:new()
globals.phase = 'starting'
--======================================================================--
--== Load Composer module
--======================================================================--
local composer = require( 'composer' )
composer.gotoScene( 'scene_lobby' )
