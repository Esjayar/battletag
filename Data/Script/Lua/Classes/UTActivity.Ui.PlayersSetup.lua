
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.PlayersSetup.lua
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

require "UI/UIMenuWindow"

	require "Ui/UIPlayerSlotGrid"
	require "UTActivity.Ui.ManualLaunch"


--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.PlayersSetup = UTClass(UIMenuWindow)

-- default

UTActivity.Ui.PlayersSetup.padding = { horizontal = 15, vertical = 20 }

-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.PlayersSetup:__ctor(...)

    assert(activity)

	-- window settings

	self.uiWindow.title = l"titlemen015"

    -- panel 

		self.uiPanel = self.uiWindow:AddComponent(UIPanel:New(), "uiPanel")
		self.uiPanel.rectangle = self.clientRectangle

    -- picture and text on left

    	self.uiPicture1 = self.uiPanel:AddComponent(UIPicture:New(), "uiPicture1")
		self.uiPicture1.color = UIComponent.colors.white
		self.uiPicture1.rectangle = { 20, 0, 20 + 350, 0 + 350 }
		self.uiPicture1.texture = "base:texture/ui/TBlaster_Connect.tga"

    	self.uiLabel1 = self.uiPanel:AddComponent(UILabel:New(), "uiLabel1")
		self.uiLabel1.font = UIComponent.fonts.default
		self.uiLabel1.fontColor = UIComponent.colors.darkgray
		self.uiLabel1.fontJustification = quartz.system.drawing.justification.topleft + quartz.system.drawing.justification.wordbreak
		self.uiLabel1.rectangle = { 40, 360, 325, 440 }
		self.uiLabel1.text = l"pm006"

    -- my slot grid

		self.slotGrid = self.uiPanel:AddComponent(UIPlayerSlotGrid:New(activity.maxNumberOfPlayer, activity.settings.numberOfTeams), "slotGrid")
		self.slotGrid:MoveTo( 390, 40 )
		for i, player in ipairs(activity.match.players) do
			local slot = self.slotGrid:AddSlot(player)
			slot.harnessFx = UIManager:AddFx("value", { timeOffsey = math.random(0.0, 0.2), duration = 0.6, __self = slot , value = "icon", from = "base:texture/ui/icons/32x/harness_off.tga", to = "base:texture/ui/icons/32x/harness.tga", type = "blink"})
		end

    -- buttons,

		-- uiButton1: back to player management

		self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
		self.uiButton1.rectangle = UIMenuWindow.buttonRectangles[1]
		self.uiButton1.text = l "but003"
		self.uiButton1.tip = l"tip006"

		self.uiButton1.OnAction = function(self)
		
			UIMenuManager.stack:Pop()
			activity.matches = nil
			activity:PostStateChange("playersmanagement")
			self.enabled = false

		end

		-- uiButton4: players ready for countdown

		self.uiButton4 = self:AddComponent(UIButton:New(), "uiButton4")
		self.uiButton4.rectangle = UIMenuWindow.buttonRectangles[4]
		self.uiButton4.text = l"but008"
		self.uiButton4.tip = l"tip020"
		self.uiButton4.enabled = false

		self.uiButton4.OnAction = function(self)
		
			if (activity.settings and (1 == activity.settings.gameLaunch)) then
				UIManager.stack:Push(UTActivity.Ui.ManualLaunch)
			else
				activity:PostStateChange("beginmatch") 
			end
			self.enabled = false

		end

	self.setupFailed = false

end

-- OnClose -------------------------------------------------------------------

function UTActivity.Ui.PlayersSetup:OnClose()

   -- unregister to datachanged for player

	for i, player in ipairs(activity.match.players) do
		player._DataChanged:Remove(self, self.OnDataChanged)
	end

	engine.libraries.usb.proxy._DeviceRemoved:Remove(self, UTActivity.Ui.PlayersSetup.OnDeviceRemoved)

end

-- OnDataChanged -------------------------------------------------------------

function UTActivity.Ui.PlayersSetup:OnDataChanged(_entity, _key, _value)

	-- check harness

	if ("harnessOn" == _key) then

		for _, slot in ipairs(self.slotGrid.uiPlayerSlots) do

			if (slot.player and (slot.player == _entity)) then

				if (_value) then

					if (slot.harnessFx) then

						UIManager:RemoveFx(slot.harnessFx)
						slot.harnessFx = nil

					end

					slot.icon = "base:texture/ui/icons/32x/harness_on.tga"

				else
					if (not slot.harnessFx) then
						slot.harnessFx = UIManager:AddFx("value", { timeOffsey = math.random(0.0, 0.2), duration = 0.6, __self = slot , value = "icon", from = "base:texture/ui/icons/32x/harness_off.tga", to = "base:texture/ui/icons/32x/harness.tga", type = "blink"})
					end
				end

			end

		end

	end

end

-- OnDeviceRemoved -----------------------------------------------------------

function UTActivity.Ui.PlayersSetup:OnDeviceRemoved(device)

-- !! stop carrying about deconnection here ...
--[[

    -- lookup the player with the matching device,

    for _, player in pairs(activity.match.players) do

        if (player.rfGunDevice == device) then

			-- deconnection : quit now 

			if (not self.setupFailed) then

				self.uiPopup = UIPopupWindow:New()

				self.uiPopup.title = l"con037"
				self.uiPopup.text = l"con048"

				-- buttons

				self.uiPopup.uiButton2 = self.uiPopup:AddComponent(UIButton:New(), "uiButton2")
				self.uiPopup.uiButton2.rectangle = UIPopupWindow.buttonRectangles[2]
				self.uiPopup.uiButton2.text = l "but019"

				self.uiPopup.uiButton2.OnAction = function ()

					UIManager.stack:Pop()
					activity:PostStateChange("end") 
					game:PostStateChange("title")

				end

				self.setupFailed = true
				UIManager.stack:Push(self.uiPopup)	

			end

        end

    end
--]]

end

-- OnOpen --------------------------------------------------------------------

function UTActivity.Ui.PlayersSetup:OnOpen()

   -- register to datachanged for player

	for i, player in ipairs(activity.match.players) do
		player._DataChanged:Add(self, self.OnDataChanged)
	end

	engine.libraries.usb.proxy._DeviceRemoved:Add(self, UTActivity.Ui.PlayersSetup.OnDeviceRemoved)

end

-- Update --------------------------------------------------------------------

function UTActivity.Ui.PlayersSetup:Update()

	-- display harness if needed by activity

	self.uiButton4.enabled = true
	if (not (activity.category == UTActivity.categories.single)) then

		for i, player in ipairs(activity.match.players) do

			if (player.rfGunDevice and not player.data.heap.harnessOn) then
				self.uiButton4.enabled = false
			end

		end

	end

end