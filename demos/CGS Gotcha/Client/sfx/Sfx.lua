--======================================================================--
--== Sound effects class
--== Author: Chris Byerley
--== Twitter: @develephant
--======================================================================--
local Sfx = class()
function Sfx:__init()

	self["bomb"] = audio.loadSound( "sfx/bomb.wav" )
	self["cheer"] = audio.loadSound( "sfx/cheer.wav" )
	self["miss"] = audio.loadSound( "sfx/miss.wav" )
	self["turn"] = audio.loadSound( "sfx/turn.wav" )
	self["tap"] = audio.loadSound( "sfx/tap.wav" )

end

function Sfx:playSound( snd_id )
	audio.play( self[ snd_id ] )
end

return Sfx