
--[[--------------------------------------------------------------------------
--
-- File:            UAFreeFrag.Ui.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 27, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.Ui.RoundLoop"
require "Ui/UIAFP"
require "Ui/UILeaderboard"

--[[ Class -----------------------------------------------------------------]]

UAFreeFrag.Ui = UAFreeFrag.Ui or {}
UAFreeFrag.Ui.RoundLoop = UTClass(UIMenuPage)

-- __ctor -------------------------------------------------------------------

function UAFreeFrag.Ui.RoundLoop:__ctor(...)

	-- label

    self.uiLabel = self:AddComponent(UILabel:New(), "uiLabel")
    self.uiLabel.fontColor = UIComponent.colors.black
    self.uiLabel.rectangle = { 300, 0, 700, 80 }
    -- self.uiLabel.text = "Default game loop for " .. activity.name

    ------------------------------------------------
    -- Afp
    ------------------------------------------------

    activity.uiAFP = self:AddComponent(UIAFP:New(), "uiAFP")
    activity.uiAFP:MoveTo(50, 40)

    ------------------------------------------------
    -- Leaderboard
    ------------------------------------------------

    self.uiLeaderboard = self:AddComponent(UILeaderboard:New(), "uiLeaderboardTest")
    self.uiLeaderboard.showSlotEmpty = true
    self.uiLeaderboard:MoveTo(520, 40)

    -- key / icon / position / justification

	if (activity.scoringField) then
		for i, field in ipairs(activity.scoringField) do
			self.uiLeaderboard:RegisterField(unpack(field))
		end
	end

    self.uiLeaderboard:Build(activity.match.challengers)

end

-- __dtor -------------------------------------------------------------------

function UAFreeFrag.Ui.RoundLoop:__dtor()    
end

-- Update -------------------------------------------------------------------

function UAFreeFrag.Ui.RoundLoop:Update()
end
