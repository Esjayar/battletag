
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.Matchmaking.lua
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

require "Ui/UIMenuWindow"

--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.Matchmaking = UTClass(UIMenuWindow)

-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.Matchmaking:__ctor(...)

    assert(activity)

	-- window settings

	self.uiWindow.title = ""
	self.uiWindow.text = ""

    -- buttons,

	-- uiButton4: accept 

    self.uiButton4 = self:AddComponent(UIButton:New(), "uiButton4")
    self.uiButton4.rectangle = UIMenuWindow.buttonRectangles[4]
	self.uiButton4.text = ""

	self.uiButton4.OnAction = function (self) activity:PostStateChange("playerssetup") end

end
