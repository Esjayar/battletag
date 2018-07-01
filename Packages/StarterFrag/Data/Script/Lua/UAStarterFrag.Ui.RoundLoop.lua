
--[[--------------------------------------------------------------------------
--
-- File:            UAStarterFrag.Ui.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 21, 2010
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

UAStarterFrag.Ui = UAStarterFrag.Ui or {}
UAStarterFrag.Ui.RoundLoop = UTClass(UIMenuPage)

-- __ctor -------------------------------------------------------------------

function UAStarterFrag.Ui.RoundLoop:__ctor(...)

	-- label

    self.uiLabel = self:AddComponent(UILabel:New(), "uiLabel")
    self.uiLabel.fontColor = UIComponent.colors.black
    self.uiLabel.rectangle = { 300, 0, 700, 80 }

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
    self.uiLeaderboard:Build(activity.match.challengers)

    ------------------------------------------------
    -- AFP TEST
    ------------------------------------------------

    activity.uiAFP = self:AddComponent(UIAFP:New(), "uiAFP")
    activity.uiAFP:MoveTo(50, 40)

end

-- __dtor -------------------------------------------------------------------

function UAStarterFrag.Ui.RoundLoop:__dtor()    
end

-- Update -------------------------------------------------------------------

function UAStarterFrag.Ui.RoundLoop:Update()
end
