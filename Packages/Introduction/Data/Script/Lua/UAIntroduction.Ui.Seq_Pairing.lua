
--[[--------------------------------------------------------------------------
--
-- File:            UAIntroduction.Ui.Seq_Pairing.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 16, 2010
--
------------------------------------------------------------------------------
--
-- Description:      <Turn on all your T-Blasters>
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIMenuWindow"

--[[ Class -----------------------------------------------------------------]]

UAIntroduction.Ui = UAIntroduction.Ui or {}
UAIntroduction.Ui.Seq_Pairing = UTClass(UIMenuWindow)

-- __ctor -------------------------------------------------------------------

function UAIntroduction.Ui.Seq_Pairing:__ctor(...)

    assert(activity)

	-- window settings

	self.uiWindow.title = activity.name

    -- contents,

    self.uiPanel = self.uiWindow:AddComponent(UIPanel:New(), "uiPanel")
    self.uiPanel.rectangle = self.clientRectangle

    self.uiContents = self.uiPanel:AddComponent(UITitledPanel:New(), "uiContents")
    self.uiContents.rectangle = { 20, 20, 695, 435 }
    self.uiContents.title = l "con025"

    self.uiContents.clientRectangle = {}

    for i = 1, 4 do 
        self.uiContents.clientRectangle[i] = self.uiWindow.rectangle[i] + self.clientRectangle[i] + self.uiContents.rectangle[i]
    end

    self.text = l "con026"

    -- buttons,

    -- no buttons, automatic transition when at least one gut gets connected

end

-- Draw ---------------------------------------------------------------------

function UAIntroduction.Ui.Seq_Pairing:Draw()

    UIMenuWindow.Draw(self)

    -- contents,

    quartz.system.drawing.pushcontext()
    quartz.system.drawing.loadtranslation(unpack(self.uiContents.clientRectangle))
    quartz.system.drawing.loadtranslation(0, UITitledPanel.headerSize)

    -- bitmap

    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
    quartz.system.drawing.loadtexture("base:texture/ui/seq_pairing01.tga")
    quartz.system.drawing.drawtexture(0, 0)

    -- text

    local fontJustification = quartz.system.drawing.justification.bottomleft + quartz.system.drawing.justification.wordbreak
    local rectangle = { 40, 50, 675 - 40, 390 - 20 }

    quartz.system.drawing.loadcolor3f(unpack(self.fontColor))
    quartz.system.drawing.loadfont(UIComponent.fonts.default)
    quartz.system.drawing.drawtextjustified(self.text, fontJustification, unpack(rectangle) )

    quartz.system.drawing.pop()    

end

-- OnOpen --------------------------------------------------------------------

function UAIntroduction.Ui.Seq_Pairing:OnOpen()

    self.uiPopup = UIPopupWindow:New()

    self.uiPopup.title = l "con028"
    self.uiPopup.text = l "con029"

    -- buttons

    self.uiPopup.uiButton2 = self.uiPopup:AddComponent(UIButton:New(), "uiButton2")
    self.uiPopup.uiButton2.rectangle = UIPopupWindow.buttonRectangles[2]
    self.uiPopup.uiButton2.text = l"but006"
    self.uiPopup.uiButton2.tip = l"tip005"

    self.uiPopup.uiButton2.OnAction = function ()

        UIManager.stack:Pop()
        self.uiPopup = nil

        -- !! START PAIRING

        for index, proxy in ipairs(engine.libraries.usb.proxies) do
			assert(proxy)
			assert(proxy.handle)

			quartz.system.usb.sendmessage(proxy.handle, { 0x01, 0x00, 0x13, 0x01 })
		end

    end

    UIManager.stack:Push(self.uiPopup)

    -- gm lock

    self.uiPopup.uiButton2.enabled = false
    game.gameMaster:Play("base:audio/gamemaster/dlg_gm_init_08.wav", function () self.uiPopup.uiButton2.enabled = true end)

end

-- Update -------------------------------------------------------------------

function UAIntroduction.Ui.Seq_Pairing:Update()

    -- close the ui page after the first player was registered,
    -- verify first that the popup was closed (always the case when REG_FIRSTTIME)

    if (not self.uiPopup) then
        if (activity.players and (0 < #activity.players)) then

            UIMenuManager.stack:Pop()

        end
    end

end