
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
    self.uiProgress.rectangle = { 20, self.uiContents.rectangle[4] - 28 - 30, 655, self.uiContents.rectangle[4] - 30 }

    assert(engine.libraries.usb)
	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		assert(proxy)
		assert(proxy.revisionUpdate)
	end

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

	-- logo

    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
    quartz.system.drawing.loadtexture("base:texture/ui/Loading_Logo.tga")
    quartz.system.drawing.drawtexture(120, 0, 120 + 433, 250)

    -- text

    local fontJustification = quartz.system.drawing.justification.center + quartz.system.drawing.justification.wordbreak
    local rectangle = { 40, 220, 675 - 40, 220 + 140 }

    quartz.system.drawing.loadcolor3f(unpack(self.fontColor))
    quartz.system.drawing.loadfont(UIComponent.fonts.default)
    quartz.system.drawing.drawtextjustified(self.text, fontJustification, unpack(rectangle) )

    quartz.system.drawing.pop()

end

-- Update --------------------------------------------------------------------

function UTGame.Ui.Revision:Update()

	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		if (proxy and proxy.revisionCandidate) then

			self.uiProgress.minimum = 0
			self.uiProgress.maximum = proxy.revisionCandidate.checked

			self.uiProgress:SetValue(proxy.revisionUpdate)
			self.uiContents.title = string.format("%02d%%", self.uiProgress.progress)

		end
	end

    UIMenuWindow.Update(self)
 
end