
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.BeginRound.lua
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

--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.BeginRound = UTClass(UIMenuPage)

-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.BeginRound:__ctor(...)

	-- label

    self.uiLabel = self:AddComponent(UILabel:New(), "uiLabel")
    self.uiLabel.fontColor = UIComponent.colors.black
    self.uiLabel.rectangle = { 300, 350, 700, 380 }
    self.uiLabel.text = "" .. activity.name -- Default round begin for 

    -- fake skip button

    self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
    self.uiButton1.rectangle = { 410, 420, 547, 454 }
    self.uiButton1.text = l"but007"
    
    self.uiButton1.OnAction = function (self) activity:PostStateChange("roundloop") end

end
