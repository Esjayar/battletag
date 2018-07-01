
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.ConnectGun.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 28, 2010
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
UTActivity.Ui.ConnectGun = UTClass(UIPopupWindow)

-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.ConnectGun:__ctor(...)

    assert(activity)

	self.title = l"oth040"
	self.text = nil

	-- msg timer

	self.msgTimer = 0
	self.timer = quartz.system.time.gettimemicroseconds()

	-- panel

	self.uiPanel = self:AddComponent(UIPanel:New(), "uiPanel")
	self.uiPanel.color = UIComponent.colors.lightgray
	self.uiPanel.background = "base:texture/ui/Components/UIPanel07.tga"
	self.uiPanel.rectangle = {
		self.clientRectangle[1],
		self.clientRectangle[2] + 25,
		self.clientRectangle[3],
		self.clientRectangle[2] + 25 + 15,
	}

	-- picture

	self.uiPicture1 = self:AddComponent(UIPicture:New(), "uiPicture1")
	self.uiPicture1.color = UIComponent.colors.white

	-- text

	self.uiLabel1 = self:AddComponent(UILabel:New(), "uiLabel1")
	self.uiLabel1.font = UIComponent.fonts.default
	self.uiLabel1.fontColor = UIComponent.colors.orange
	self.uiLabel1.fontJustification = quartz.system.drawing.justification.topleft + quartz.system.drawing.justification.wordbreak

	if (activity.category == UTActivity.categories.single) then

		self.uiPicture1.texture = "base:texture/ui/PopUp_TurnOnGun.tga"
		self.uiPicture1.rectangle = { 140, -60, 140 + 512, -60 + 512 }
		self.uiLabel1.text = l"oth023"
		self.uiLabel1.rectangle = {
			self.clientRectangle[1] + 20,
			self.clientRectangle[2] + 80,
			self.clientRectangle[3] - 200,
			self.clientRectangle[4] - 20,
		}

	else

		self.uiPicture1.texture = "base:texture/ui/PopUp_TurnOnGunAndVest.tga"
		self.uiPicture1.rectangle = { 20, -60, 20 + 512, -60 + 512 }
		self.uiLabel1.text = l"pm006"
		self.uiLabel1.rectangle = {
			self.clientRectangle[1] + 60,
			self.clientRectangle[2] + 60,
			self.clientRectangle[3] - 100,
			self.clientRectangle[4] - 20,
		}

	end

end

-- OnClose -------------------------------------------------------------------

function UTActivity.Ui.ConnectGun:OnClose()
end

-- OnOpen --------------------------------------------------------------------

function UTActivity.Ui.ConnectGun:OnOpen()
end

-- Update --------------------------------------------------------------------

function UTActivity.Ui.ConnectGun:Update()

	if (0 < #activity.players) then
		UIManager.stack:Pop()
	end

end
