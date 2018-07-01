
--[[--------------------------------------------------------------------------
--
-- File:            UALastManStanding.Ui.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 03, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIAFP"
require "Ui/UILeaderboard"

--[[ Class -----------------------------------------------------------------]]

UALastManStanding.Ui = UALastManStanding.Ui or {}
UALastManStanding.Ui.RoundLoop = UTClass(UIMenuPage)

-- __ctor -------------------------------------------------------------------

function UALastManStanding.Ui.RoundLoop:__ctor(...)

	-- label

    self.uiLabel = self:AddComponent(UILabel:New(), "uiLabel")
    self.uiLabel.fontColor = UIComponent.colors.black
    self.uiLabel.rectangle = { 300, 0, 700, 80 }
    -- self.uiLabel.text = "Default game loop for " .. activity.name

    ------------------------------------------------
    -- LEADERBOARD TEST
    ------------------------------------------------

    self.uiLeaderboard = self:AddComponent(UILeaderboard:New(), "uiLeaderboardTest")
    self.uiLeaderboard:MoveTo(520, 40)

    -- key / icon / position / justification

	if (activity.scoringField) then
		for i, field in ipairs(activity.scoringField) do
			self.uiLeaderboard:RegisterField(unpack(field))
		end
	end
	
    self.uiLeaderboard:Build(activity.match.players)

    ------------------------------------------------
    -- AFP
    ------------------------------------------------

    activity.uiAFP = self:AddComponent(UIAFP:New(true), "uiAFP")
    activity.uiAFP:MoveTo(50, 40)

end

-- __dtor -------------------------------------------------------------------

function UALastManStanding.Ui.RoundLoop:__dtor()    
end

-- Update -------------------------------------------------------------------

function UALastManStanding.Ui.RoundLoop:Update()
end
