
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.Ui.Revision.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 13, 2010
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
    require "UI/UIProgress"

--[[ Class -----------------------------------------------------------------]]

UTGame.Ui = UTGame.Ui or {}
UTGame.Ui.Revision = UTClass(UIMenuWindow)

-- __ctor --------------------------------------------------------------------

function UTGame.Ui.Revision:__ctor(...)

	-- window settings

	self.uiWindow.title = l "oth008"
	self.uiWindow.icon = "base:video/uianimatedbutton_settings.avi"

	self.text = l "oth009"

    -- contents,

    self.uiPanel = self.uiWindow:AddComponent(UIPanel:New(), "uiPanel")
    self.uiPanel.rectangle = self.clientRectangle

    self.uiContents = self.uiPanel:AddComponent(UITitledPanel:New(), "uiContents")
    self.uiContents.rectangle = { 20, 20, 695, 435 }
    self.uiContents.title = ""

    self.uiContents.clientRectangle = {}

    for i = 1, 4 do 
        self.uiContents.clientRectangle[i] = self.uiWindow.rectangle[i] + self.clientRectangle[i] + self.uiContents.rectangle[i]
    end

    -- progress

    self.uiProgress = self.uiContents:AddComponent(UIProgress:New(), "uiProgress")
    self.uiProgress.rectangle = { 20, 20 + 25, 655, 48 + 25 }

    assert(engine.libraries.usb)
    assert(engine.libraries.usb.proxy)
    assert(engine.libraries.usb.proxy.revisionUpdate)

    -- buttons,

    -- uiButton4: continue

    --self.uiButton4 = self:AddComponent(UIButton:New(), "uiButton4")
    --self.uiButton4.rectangle = UIMenuWindow.buttonRectangles[4]
    --self.uiButton4.text = l "but019"

    --self.uiButton4.enabled = false

    --self.uiButton4.OnAction = function (self) game:PostStateChange("title") end

end

-- Draw ----------------------------------------------------------------------

function UTGame.Ui.Revision:Draw()

    -- base

    UIMenuWindow.Draw(self)

    -- contents,

    quartz.system.drawing.pushcontext()
    quartz.system.drawing.loadtranslation(unpack(self.uiContents.clientRectangle))
    quartz.system.drawing.loadtranslation(0, UITitledPanel.headerSize)
    
    -- bitmap

    --quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
    --quartz.system.drawing.loadtexture("base:texture/ui/connection_plugin.tga")
    --quartz.system.drawing.drawtexture(82, 0)

    -- text

    local fontJustification = quartz.system.drawing.justification.bottomleft + quartz.system.drawing.justification.wordbreak
    local rectangle = { 40, 320, 675 - 40, 390 - 20 }

    quartz.system.drawing.loadcolor3f(unpack(self.fontColor))
    quartz.system.drawing.loadfont(UIComponent.fonts.default)
    quartz.system.drawing.drawtextjustified(self.text, fontJustification, unpack(rectangle) )

    quartz.system.drawing.pop()

end

-- Update --------------------------------------------------------------------

function UTGame.Ui.Revision:Update()

    if (engine.libraries.usb.proxy and engine.libraries.usb.proxy.revisionCandidate) then

        self.uiProgress.minimum = 0
        self.uiProgress.maximum = engine.libraries.usb.proxy.revisionCandidate.checked

        self.uiProgress:SetValue(engine.libraries.usb.proxy.revisionUpdate)
        self.uiContents.title = string.format("%02d%%", self.uiProgress.progress)

    end

    UIMenuWindow.Update(self)
 
end