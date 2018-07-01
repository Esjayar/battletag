
--[[--------------------------------------------------------------------------
--
-- File:            UAIntroduction.Ui.Seq_Quit.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 21, 2010
--
------------------------------------------------------------------------------
--
-- Description:     <You're ready to play>
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIMenuPage"

--[[ Class -----------------------------------------------------------------]]

UAIntroduction.Ui = UAIntroduction.Ui or {}
UAIntroduction.Ui.Seq_Quit = UTClass(UIMenuPage)

-- __ctor -------------------------------------------------------------------

function UAIntroduction.Ui.Seq_Quit:__ctor(...)

    assert(activity)

	self.quitDone = false	

end

-- Draw ---------------------------------------------------------------------

function UAIntroduction.Ui.Seq_Quit:Draw()
end

-- Update --------------------------------------------------------------------

function UAIntroduction.Ui.Seq_Quit:Update()

	if (not self.quitDone) then

		for _, player in pairs(activity.players) do
			if not (player.rfGunDevice) then
				-- if a player has no device (is disconnected) then he does not count
			elseif not (player.data.heap.gameover) then
				-- else if the player did not receive the gameover message then we shall wait a little bit longer
				return
			end
		end

		UIManager.stack:Pop()
		UIManager.stack:Pop()
		self.quitDone = true
		engine.libraries.audio:Play("base:audio/musicmenu.ogg",game.settings.audio["volume:music"])
		game:PostStateChange("title")	

	end

end