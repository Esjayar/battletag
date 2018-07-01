
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 27, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIMenuPage"

    require "Ui/UIAFP"
    require "Ui/UILeaderboard"

--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.RoundLoop = UTClass(UIMenuPage)

-- __ctor --------------------------------------------------------------------

function UTActivity.Ui.RoundLoop:__ctor(...)

    -- !! PROVIDE STANDARD ROUNDLOOP WITH STANDARD UI = AFP + DEFAULT LEADERBOARD
    -- !! HANDLE TIMER IF ACTIVITY HAS ROUND DURATION SET

    -- Afp

    self.uiAFP = self:AddComponent(UIAFP:New(), "uiAFP")
    self.uiAFP:MoveTo(50, 50)

    local theAFP = self.uiAFP
    local count = 0

    -- Leaderboard

    self.uiLeaderboard = self:AddComponent(UILeaderboard:New(), "uiLeaderboardTest")
    self.uiLeaderboard.showItemsHeader = (0 < #activity.teams)
    self.uiLeaderboard:MoveTo(520, 50)

    self.uiLeaderboard:RegisterField("icon", UIGridLine.IconCellStyle:New(32, 32), 40)
    self.uiLeaderboard:RegisterField("name", UIGridLine.RowTitleCellStyle:New(), 150)
    self.uiLeaderboard:RegisterField("ammunitions")
    self.uiLeaderboard:RegisterField("hit")
    self.uiLeaderboard:RegisterField("death")
    self.uiLeaderboard:RegisterField("life")
    self.uiLeaderboard:RegisterField("score", UIGridLine.RightCellStyle:New(), 50)

    self.uiLeaderboard:SetFieldHeader("life", UIGridLine.DefaultCellStyle, "vie")
    
    self.uiLeaderboard:Build(activity.match.challengers)
end

-- OnClose -------------------------------------------------------------------

function UTActivity.Ui.RoundLoop:OnClose()

    self.uiLeaderboard:RemoveDataChangedEvents()

end