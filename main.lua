local composer = require( "composer" )

local scene = composer.newScene()

local widget = require ("widget")

local localGroup = display.newGroup()

-----------------------
--text box for ip entry
-----------------------

--globals
ipTextGet = "54.84.5.240" --for testing, Adam's server is "54.84.5.240"
numPlayersGet = 2 --for testing, use any number like 2
getKeyValue = "lol" --this is a given apparently
numTeamsGet = 1

local image = display.newImageRect( "map2.png", (display.contentWidth-100)*0.8017446, (display.contentWidth-100) ) --1011x1261
image.anchorY = 0
image.y = -20
image.x = display.contentCenterX

local imagebg = display.newImageRect( "mapbg.png", display.contentWidth+0, display.contentWidth+0 )
imagebg.anchorY = 0
imagebg.y = -40
imagebg.x = display.contentCenterX
imagebg:toBack()


local mainText = display.newText {
    text = "Welcome to the rest of your life. Enjoy the game.",     
    x = display.contentCenterX,
    y = display.contentHeight-250,
    width = display.contentWidth-20,     
    font = native.systemFontBold,   
    fontSize = 24,
    align = "center"
}
localGroup:insert(mainText)
mainText:setFillColor( 1, 0.2, 0.2 )

local help1 = display.newText {
    text = "Enter IP Address like '54.84.5.240'",     
    x = display.contentCenterX,
    y = display.contentHeight-200,
    width = display.contentCenterX*2,     
    font = native.systemFontBold,   
    fontSize = 18,
    align = "center"
}
localGroup:insert(help1)


local ipText = native.newTextField( display.contentCenterX, display.contentHeight-150, 220, 36 )
ipText.inputType = "text"
ipText.placeholder = "54.84.5.240"
localGroup:insert(ipText)


local help12= display.newText {
    text = "Enter # Players and Teams",     
    x = display.contentCenterX,
    y = display.contentHeight-100,
    width = display.contentCenterX*2,     
    font = native.systemFontBold,   
    fontSize = 18,
    align = "center"
}
localGroup:insert(help12)

local numPlayers = native.newTextField( display.contentCenterX-60, display.contentHeight-50, 100, 36 )
numPlayers.inputType = "number"
numPlayers.placeholder = "Players"
localGroup:insert(numPlayers)

local numTeams = native.newTextField( display.contentCenterX+60, display.contentHeight-50, 100, 36 )
numTeams.inputType = "number"
numTeams.placeholder = "Teams"
localGroup:insert(numTeams)


local function onButtonTap( event )
	if ( not (ipTextGet == "0") and not (numPlayersGet == 0) ) then
			localGroup:removeSelf()
            image:removeSelf()
            imagebg:removeSelf()
			composer.gotoScene( "play" )
	end
end

local start_button = widget.newButton( { 		
	label = "Continue...",
	x = display.contentCenterX,
	y = display.contentHeight,
	width = display.contentWidth/2,
	onRelease = onButtonTap,
	labelColor = { default={ 0, 1, 1 }, over={ 1, 1, 1, 0.5 } }
	} )
localGroup:insert(start_button)



local function ipListener( event )

    if ( event.phase == "submitted" or event.phase == "ended" ) then
        ipTextGet = event.target.text
        native.setKeyboardFocus( numPlayers )
    end
end

ipText:addEventListener( "userInput", ipListener )


local function playerListener( event )

    if ( event.phase == "submitted" or event.phase == "ended" ) then
        numPlayersGet = event.target.text
        native.setKeyboardFocus( numTeams )
    end
end

numPlayers:addEventListener( "userInput", playerListener )

local function teamListener( event )

    if ( event.phase == "submitted" or event.phase == "ended" ) then
        numTeamsGet = event.target.text
        native.setKeyboardFocus( nil )
    end
end

numTeams:addEventListener( "userInput", teamListener )




localGroup:insert( start_button )
localGroup:insert( ipText )
localGroup:insert( numPlayers )


