--======================================================================--
--== UI Class for Gotcha
--== Author: Chris Byerley
--== Twitter: @develephant
--======================================================================--
local UI = class()
function UI:__init()
	self.board_grp = display.newGroup()
end
--======================================================================--
--== Lobby UI
--======================================================================--
function UI:drawLobby()

	local grp = display.newGroup()

	local waiting_txt = display.newText({
		text = "Gotcha!",
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = display.contentWidth,
		height = 32,
		font = native.systemFont,
		fontSize = 24,
		align = "center"
	})
	waiting_txt:setTextColor( 67/255 )

	grp:insert( waiting_txt )

	--== Exports
	local ui = 
	{
		grp = grp,
		waiting_txt = waiting_txt
	}

	return ui

end
--======================================================================--
--== Play UI
--======================================================================--
function UI:drawGame()

	local grp = display.newGroup()

	--== Status txt
	local status_txt = display.newText({
		text = "Select 4 spots...",
		x = display.contentCenterX,
		y = 40,
		width = display.contentWidth,
		height = 28,
		font = native.systemFont,
		fontSize = 20,
		align = "center"
	})
	status_txt:setFillColor( { 67/255 } )

	grp:insert( status_txt )

	--== Ping txt
	local ping_txt = display.newText({
		text = "Waiting...",
		x = display.contentCenterX,
		y = 460,
		width = display.contentWidth,
		height = 24,
		font = native.systemFont,
		fontSize = 16,
		align = "center"
	})
	ping_txt:setTextColor( 67/255 )

	grp:insert( ping_txt )

	--== User txt
	local user_txt = display.newText({
		text = "...",
		x = display.contentCenterX,
		y = 480,
		width = display.contentWidth,
		height = 24,
		font = native.systemFont,
		fontSize = 16,
		align = "center"
	})
	user_txt:setTextColor( 67/255 )

	grp:insert( user_txt )

	--== UI Exports
	local ui =
	{
		grp = grp, --== Main group
		status_txt = status_txt, --== Status txt
		ping_txt = ping_txt, --== Ping txt
		user_txt = user_txt --== Username txt
	}

	return ui

end

local function createSpotType( spot_type )
	local spot
	if spot_type == 0 then
		--== Normal
		spot = display.newCircle( 0, 0, 32 )
		spot:setFillColor( 67/255 )
	elseif spot_type == 1 then
		--== Red
		spot = display.newCircle( 0, 0, 24 )
		spot:setFillColor( 244/255 )
		spot.stroke = { 1, 0, 23/255 }
		spot.strokeWidth = 18
	elseif spot_type == 2 then
		spot = display.newGroup()

		--== Red
		d1 = display.newCircle( 0, 0, 24 )
		d1:setFillColor( 244/255 )
		d1.stroke = { 1, 0, 23/255 }
		d1.strokeWidth = 18

		--== Hit spot
		d2 = display.newCircle( 0, 0, 12 )
		d2:setFillColor( 0 )

		spot:insert( d1 )
		spot:insert( d2 )
	elseif spot_type == 3 then
		--== Hit spot
		spot = display.newCircle( 0, 0, 12 )
		spot:setFillColor( 0 )
	elseif spot_type == 4 then
		--== Empty spot
		spot = display.newCircle( 0, 0, 32 )
		spot:setFillColor( 255 )
	end

	return spot
end

function UI:updateBoard( board, onBtnTapped, can_play, turn_over )

	--== Game board
	for b=self.board_grp.numChildren, 1, -1 do
		display.remove( self.board_grp[ b ] )
		b = nil
	end

	local row, col

	--== types
	--== 0: normal
	--== 1: hit
	--== 2: hit/spot
	--== 3: spot
	--== 4: empty
	local board_spot = 1

	for row=1, 4 do
		for col=1, 4 do

			local spot_type
			
			if turn_over then
				spot_type = 0
			else
				spot_type = board[ board_spot ]
			end

			local dot = createSpotType( spot_type )

			if spot_type == 0 then
				if can_play then
					dot:addEventListener( "tap", onBtnTapped )
				end
			elseif spot_type == 1 then
				if can_play then
					dot:addEventListener( "tap", onBtnTapped )
				end
			elseif spot_type == 2 then

			elseif spot_type == 3 then

			elseif spot_type == 4 then

			end

			dot.y = row * 72
			dot.x = col * 72

			dot.row = row
			dot.col = col

			dot.spot = board_spot

			dot.locked = false

			self.board_grp:insert( dot )

			board_spot = board_spot + 1
		end
	end

	self.board_grp.x = -18
	self.board_grp.y = 80

end
--======================================================================--
--== Return class
--======================================================================--
return UI