
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.Ui.Connection.lua
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

require "UI/UIPage"
require "UI/UIMenuPage"
require "UI/UIMenuWindow"
require "UI/UITitledPanel"

--[[ Class -----------------------------------------------------------------]]

UTGame.Ui = UTGame.Ui or {}
UTGame.Ui.Connection = UTClass(UIMenuWindow)

-- __ctor --------------------------------------------------------------------

UTGame.Ui.Connection.hasPopup = false
		
function UTGame.Ui.Connection:__ctor(...)

	-- window settings

	self.uiWindow.title = l "con001"
	self.uiWindow.icon = "base:video/uianimatedbutton_settings.avi"

	self.text = l "con004"

    -- contents,

    self.uiPanel = self.uiWindow:AddComponent(UIPanel:New(), "uiPanel")
    self.uiPanel.rectangle = self.clientRectangle

    self.uiContents = self.uiPanel:AddComponent(UITitledPanel:New(), "uiContents")
    self.uiContents.rectangle = { 20, 20, 695, 435 }
    self.uiContents.title = l "con002"

    self.uiContents.clientRectangle = {}

    for i = 1, 4 do 
        self.uiContents.clientRectangle[i] = self.uiWindow.rectangle[i] + self.clientRectangle[i] + self.uiContents.rectangle[i]
    end

    self.uiButtonQuit = self:AddComponent(UIButton:New(), "uiButtonµQuit")
    self.uiButtonQuit.rectangle = UIMenuWindow.buttonRectangles[1]
    self.uiButtonQuit.text = l"menu06"
    self.uiButtonQuit.tip = l"tip013"

    self.uiButtonQuit.OnAction = function (self) 

		quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()
		
		local uiPopup = UIPopupWindow:New()
		uiPopup.icon = "base:/video/uianimatedbutton_quit.avi"

        uiPopup.title = l"menu06"
        uiPopup.text = string.format(l"menu06pop")
        
        local uiButtonYes = uiPopup:AddComponent(UIButton:New(), "uiButtonYes")
        uiButtonYes.text = l"but001"
		uiButtonYes.tip = l"tip013"
        uiButtonYes.rectangle = uiPopup.buttonRectangles[1]
        
        uiButtonYes.OnAction = function (self) 			
			UTGame.Ui.Connection.hasPopup = false
			application.postbreakexecution() 
        end

        local uiButtonNo = uiPopup:AddComponent(UIButton:New(), "uiButtonNo")
        uiButtonNo.text = l"but002"
		uiButtonNo.tip = l"tip006"
        uiButtonNo.rectangle = uiPopup.buttonRectangles[2]
        
        uiButtonNo.OnAction = function (self) 
			UTGame.Ui.Connection.hasPopup = false
			UIManager.stack:Pop() 
        end

		UTGame.Ui.Connection.hasPopup = true
        UIManager.stack:Push(uiPopup)

    end

end

-- __dtor --------------------------------------------------------------------

function UTGame.Ui.Connection:__dtor()
end

-- Draw ----------------------------------------------------------------------

function UTGame.Ui.Connection:Draw()

    -- base

    UIPage.Draw(self)

    -- contents,

    quartz.system.drawing.pushcontext()
    quartz.system.drawing.loadtranslation(unpack(self.uiContents.clientRectangle))
    quartz.system.drawing.loadtranslation(0, UITitledPanel.headerSize)
    
    -- bitmap

    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
    quartz.system.drawing.loadtexture("base:texture/ui/connection_plugin.tga")
    quartz.system.drawing.drawtexture(0, 0)

    -- text

    local fontJustification = quartz.system.drawing.justification.bottomleft + quartz.system.drawing.justification.wordbreak
    local rectangle = { 40, 50, 675 - 40, 390 - 20 }

    quartz.system.drawing.loadcolor3f(unpack(self.fontColor))
    quartz.system.drawing.loadfont(UIComponent.fonts.default)
    quartz.system.drawing.drawtextjustified(self.text, fontJustification, unpack(rectangle) )

    quartz.system.drawing.pop()

end
