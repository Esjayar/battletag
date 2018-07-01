
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.Menu.lua
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

require "Ui/UIPopupWindow" 

--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.Menu = UTClass(UIPopupWindow)

-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.Menu:__ctor(...)

    assert(activity)

	self.title = l"but016"
	self.text = nil

	-- buttons
	
	-- uiButton1: resume

    self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
    self.uiButton1.rectangle = UIPopupWindow.buttonRectangles[3]
	self.uiButton1.text = l"but017"
	self.uiButton1.tip = l"tip063"

	self.uiButton1.OnAction = function (self) 
		activity.mainMenu = nil
		UIManager.stack:Pop() 
	end

	-- uiButton2: quit

    self.uiButton2 = self:AddComponent(UIButton:New(), "uiButton2")
    self.uiButton2.rectangle = UIPopupWindow.buttonRectangles[4]
	self.uiButton2.text = l"but018"
	self.uiButton2.tip = l"tip064"

	self.uiButton2.OnAction = function (self) 

		UIManager.stack:Pop() 
		activity.mainMenu = nil
		activity:PostStateChange("endmatch")

	end

end