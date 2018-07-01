
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.PlayersSetupOpen.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 24, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIMenuWindow"

	require "Ui/UIPlayerPanel"
	require "Ui/UIPlayerSlot"
	require "Ui/UIPicture"

--[[ Class -----------------------------------------------------------------]]

UAOldFashionDuel.Ui.PlayersSetup = UTClass(UIMenuWindow)

-- __ctor -------------------------------------------------------------------

function UAOldFashionDuel.Ui.PlayersSetup:__ctor(...)

    assert(activity)

	-- window settings

	self.uiWindow.title = l"titlemen015"

    -- main panel 

		self.uiPanel = self.uiWindow:AddComponent(UIPanel:New(), "uiPanel")
		self.uiPanel.rectangle = self.clientRectangle

	-- next match panel 

	self.uiNextMatchPanel = self.uiPanel:AddComponent(UITitledPanel:New(), "uiNextMatchPanel")
	self.uiNextMatchPanel.rectangle = { 20, 20, 695, 235 }
    self.uiNextMatchPanel.title = l"oth016"

	-- all match list 

	self.uiMatchListPanel = self.uiPanel:AddComponent(UITitledPanel:New(), "uiMatchListPanel")
    self.uiMatchListPanel.rectangle = { 20, 245, 695, 435 }
    self.uiMatchListPanel.title = l"titlemen020"

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

		end
	
	self.setupFailed = false
	
end

-- OnClose  --------------------------------------------------------------------

function UAOldFashionDuel.Ui.PlayersSetup:OnClose()

    if (engine.libraries.usb.proxy) then
    
		engine.libraries.usb.proxy._DeviceRemoved:Remove(self, UAOldFashionDuel.Ui.PlayersSetup.OnDeviceRemoved)
		
	end

end

-- OnDataChanged -------------------------------------------------------------

function UAOldFashionDuel.Ui.PlayersSetup:OnDataChanged(_entity, _key, _value)

	-- check harness

	if ("harnessOn" == _key) then

		if (_value) then

			if (_entity.data.heap.harnessFx) then

				UIManager:RemoveFx(_entity.data.heap.harnessFx)
				_entity.data.heap.harnessFx = nil

			end
			self.uiNextPlayerPanel[_entity].uiHarness.texture = "base:texture/ui/icons/32x/Harness_On.tga"

		else
			if (not _entity.data.heap.harnessFx) then

				_entity.data.heap.harnessFx = UIManager:AddFx("value", { timeOffsey = math.random(0.0, 0.2), duration = 0.6,
						__self = self.uiNextPlayerPanel[_entity].uiHarness , value = "texture", from = "base:texture/ui/icons/32x/Harness_Off.tga",
						to = "base:texture/ui/icons/32x/Harness.tga", type = "blink"})
			end
		end

	end

end

-- OnDeviceRemoved -----------------------------------------------------------

function UAOldFashionDuel.Ui.PlayersSetup:OnDeviceRemoved(device)

-- !! stop carrying about deconnection here ...
--[[
    -- lookup the player with the matching device,

    --for _, player in pairs(activity.match.players) do
    for _, player in pairs(activity.players) do

        if (player.rfGunDevice == device) then

			-- deconnection : quit now !!!

			if (not self.setupFailed) then

				self.uiPopup = UIPopupWindow:New()

				self.uiPopup.title = "Fail ..."
				self.uiPopup.text = "A T-Blaster is deconnected !"

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

-- OnOpen  --------------------------------------------------------------------

function UAOldFashionDuel.Ui.PlayersSetup:OnOpen()

	self.player = {}
	self.player[1] = activity.match.challengers[1]
	self.player[2] = activity.match.challengers[2]

	-- next players : generic component

	self.uiNextPlayerPanel = {}
	self.uiNextPlayerPanel[self.player[1]] = self.uiNextMatchPanel:AddComponent(UIPlayerPanel:New(self.player[1], { 10, 40 }), "uiNextPlayerPanel1")
	self.player[1].data.heap.harnessOn = false
	self.player[1].data.heap.harnessFx = UIManager:AddFx("value", { timeOffsey = math.random(0.0, 0.2), duration = 0.6,
			__self = self.uiNextPlayerPanel[self.player[1]].uiHarness , value = "texture", from = "base:texture/ui/icons/32x/Harness_Off.tga",
			to = "base:texture/ui/icons/32x/Harness.tga", type = "blink"})
	self.uiNextPlayerPanel[self.player[2]] = self.uiNextMatchPanel:AddComponent(UIPlayerPanel:New(self.player[2], { 675 - UIPlayerPanel.width - 10, 40 }), "uiNextPlayerPanel2")
	self.player[2].data.heap.harnessOn = false
	self.player[2].data.heap.harnessFx = UIManager:AddFx("value", { timeOffsey = math.random(0.0, 0.2), duration = 0.6,
			__self = self.uiNextPlayerPanel[self.player[2]].uiHarness , value = "texture", from = "base:texture/ui/icons/32x/Harness_Off.tga",
			to = "base:texture/ui/icons/32x/Harness.tga", type = "blink"})

	self.player[1]._DataChanged:Add(self, self.OnDataChanged)
	self.player[2]._DataChanged:Add(self, self.OnDataChanged)

	-- VS

	self.uiVsLabel = self.uiNextMatchPanel:AddComponent(UILabel:New(), "uiVsLabel")
	self.uiVsLabel.font = UIComponent.fonts.header
	self.uiVsLabel.fontColor = UIComponent.colors.orange
	self.uiVsLabel.rectangle = { 675 * 0.5 - 20, 60 }
	self.uiVsLabel.text = "VS"

	-- get first last three matchs 

	self.uiMatchSlot = {}
	self.uiMatchVsLabel = {}
	for i = 1, math.min(#activity.matches, 3) do

		local match = activity.matches[i]
		self.uiMatchSlot[i] = {}
		local player = match.challengers[1]
		self.uiMatchSlot[i][1] = self.uiMatchListPanel:AddComponent(UIPlayerSlot:New() ,"uiMatchSlot" .. i)
		self.uiMatchSlot[i][1]:SetPlayer(player)
		self.uiMatchSlot[i][1]:MoveTo(10, 40 + (50 * (i - 1)))
		
		player = match.challengers[2]
		self.uiMatchSlot[i][2] = self.uiMatchListPanel:AddComponent(UIPlayerSlot:New() ,"uiMatchSlot" .. i)
		self.uiMatchSlot[i][2]:SetPlayer(player)
		self.uiMatchSlot[i][2]:MoveTo(675 - 290, 40 + (50 * (i - 1)))

		self.uiMatchVsLabel[i] = self.uiMatchListPanel:AddComponent(UILabel:New(), "uiVsLabel")
		self.uiMatchVsLabel[i].font = UIComponent.fonts.header
		self.uiMatchVsLabel[i].fontColor = UIComponent.colors.orange
		self.uiMatchVsLabel[i].rectangle = { 675 * 0.5 - 22, 50 * i }
		self.uiMatchVsLabel[i].text = "VS"

	end		

	engine.libraries.usb.proxy._DeviceRemoved:Add(self, UAOldFashionDuel.Ui.PlayersSetup.OnDeviceRemoved)

	-- special voice for fucking incoherent design 

	self.introductionVoiceDone = false
	if (math.random(0,2) == 0) then
		game.gameMaster:Play("base:audio/gamemaster/DLG_GM_OW_DUEL_01.wav", function () self.introductionVoiceDone = true end)
	else
		game.gameMaster:Play("base:audio/gamemaster/DLG_GM_OW_DUEL_02.wav", function () self.introductionVoiceDone = true end)
	end

end

-- Update  -----------------------------------------------------------------

function UAOldFashionDuel.Ui.PlayersSetup:Update()

	-- display harness if needed by activity

	self.uiButton4.enabled = self.introductionVoiceDone
	for i, player in ipairs(activity.match.players) do

		if (player.rfGunDevice and not player.data.heap.harnessOn) then self.uiButton4.enabled = false
		end

	end

end
