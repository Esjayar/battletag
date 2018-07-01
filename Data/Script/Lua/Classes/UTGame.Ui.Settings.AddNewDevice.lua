
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.Ui.Settings.AddNewDevice.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 2, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIOption"
require "Ui/UIPanel"
require "Ui/UITitledPanel"
require "Ui/UIPopupWindow"

--[[ Class -----------------------------------------------------------------]]

UTGame.Ui.Settings = UTGame.Ui.Settings or {}
UTGame.Ui.Settings.AddNewDevice = UTClass(UITitledPanel)

require "UTGame.Ui.Settings.AddNewDevice.Pairing"

UTGame.Ui.Settings.AddNewDevice.backgroundTexture = "base:texture/ui/Option_Device.tga"
UTGame.Ui.Settings.AddNewDevice.hasPopup = false
-- __ctor --------------------------------------------------------------------

function UTGame.Ui.Settings.AddNewDevice:__ctor()
    
    -- uiButton2: link
    
	self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
	self.uiButton1.rectangle = { 0, 0, 220, 34 }
	self.uiButton1:MoveTo(82,190)
	self.uiButton1.text = l"sett005"
	self.uiButton1.tip = l"tip075"
	self.uiButton1.direction = DIR_HORIZONTAL
	UTGame.Ui.Settings.AddNewDevice.hasPopup = false


	self.uiButton1.OnAction = function (_self) 
		
		UIManager.stack:Push(UTGame.Ui.Settings.AddNewDevice.Pairing)
	
		quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()
		UTGame.Ui.Settings.AddNewDevice.hasPopup = true
		
	end

end

-- Draw ---------------------------------------------------------------------

function UTGame.Ui.Settings.AddNewDevice:Draw()

	UITitledPanel.Draw(self)
	
	local rectangle = {15, 35, 361, 180}

    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
    quartz.system.drawing.loadtexture("base:texture/ui/components/uipanel05.tga")
    quartz.system.drawing.drawwindow(unpack(rectangle))
	
    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
    quartz.system.drawing.loadtexture(self.backgroundTexture)
    quartz.system.drawing.drawtexture(30, 40)

end
