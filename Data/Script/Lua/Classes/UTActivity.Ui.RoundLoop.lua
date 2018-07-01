
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

end

-- OnClose -------------------------------------------------------------------

function UTActivity.Ui.RoundLoop:OnClose()

	if (self.uiLeaderboard) then
	
		self.uiLeaderboard:RemoveDataChangedEvents()
	
	end

end
