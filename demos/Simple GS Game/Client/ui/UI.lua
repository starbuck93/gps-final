--======================================================================--
--== UI Class
--======================================================================--
local pb = require( 'ui.pushButtonClass' )

local UI = class()
function UI:__init()

end

function UI:draw( btnHandler )
	local grp = display.newGroup()

	local btnRoll = pb:new( grp, display.contentCenterX, 200, "Roll", btnHandler )
	local btnStats = pb:new( grp, display.contentCenterX, 400, "Stats", btnHandler )

end
--======================================================================--
--== Factory
--======================================================================--
return UI