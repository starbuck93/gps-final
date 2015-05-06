--======================================================================--
--== UI Class
--======================================================================--
local pb = require( 'ui.pushButtonClass' )
local widget = require( 'widget' )

local UI = class()
function UI:__init()

end

function UI:draw( fldListener )
	local grp = display.newGroup()

	--== Display
	local ms_txt = display.newText({
		text = "waiting...",
		x = 0,
		y = 30,
		width = display.contentWidth,
		height = 400,
		font = native.systemFont,
		fontSize = 16,
	})

	ms_txt.anchorX = 0
	ms_txt.anchorY = 0

	--== Input
	local in_txt = native.newTextField( display.contentCenterX, display.contentCenterY, display.contentWidth, 32 )
	in_txt.y = 0

	in_txt:setReturnKey( "send" )
	in_txt:addEventListener( "userInput", fldListener )

	--== Send
	--local btn = pb:new( grp, display.contentCenterX, 460, "Send", btnHandler )

	--== Export ui
	local ui = {
		ms_txt = ms_txt,
		in_txt = in_txt
	}

	return ui
end
--======================================================================--
--== Factory
--======================================================================--
return UI