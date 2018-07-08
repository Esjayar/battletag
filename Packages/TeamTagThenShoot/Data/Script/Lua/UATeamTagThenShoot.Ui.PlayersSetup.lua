
--[[--------------------------------------------------------------------------
--
-- File:            UATeamTagThenShoot.Ui.PlayersSetup.lua
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

require "Ui/UIMenuWindow"

	require "Ui/UIPlayerPanel"
	require "Ui/UIPlayerSlot"
	require "Ui/UIPicture"

--[[ Class -----------------------------------------------------------------]]

UATeamTagThenShoot.Ui = UATeamTagThenShoot.Ui or {}
UATeamTagThenShoot.Ui.PlayersSetup = UTClass(UIMenuWindow)

-- __ctor -------------------------------------------------------------------

function UATeamTagThenShoot.Ui.PlayersSetup:__ctor(...)

    assert(activity)
    
	-- animate	
	
	self.slideBegin = true
	self.slideEnd = false

	-- window settings

	self.uiWindow.title = l"titlemen015"
    UIPlayerSlotGrid.horizontalPadding = activity.horizontalPadding or 0
    UIPlayerSlotGrid.slots = activity.slots or 0
    UIPlayerSlotGrid.playeroffset = activity.playeroffset or 0

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
			--game:PostStateChange("selector")
			--self.enabled = false

		end

		-- uiButton5: players ready for countdown

		self.uiButton5 = self:AddComponent(UIButton:New(), "uiButton5")
		self.uiButton5.rectangle = UIMenuWindow.buttonRectangles[5]
		self.uiButton5.text = l"but008"
		self.uiButton5.tip = l"tip020"
		--self.uiButton5.enabled = false

		self.uiButton5.OnAction = function(self)
		
			if (activity.settings and 1 == activity.settings.gameLaunch) then
				activity.settings.gameLaunch = 1
				UATeamTagThenShoot.Ui.PlayersSetup.hasPopup = true
				UIManager.stack:Push(UTActivity.Ui.ManualLaunch)
			else
				activity:PostStateChange("beginmatch") 
			end
			--self.enabled = false

		end

	self.setupFailed = false
	uploadbytecode = false
	gametypeloaded = directoryselected

end

-- OnClose  --------------------------------------------------------------------

function UATeamTagThenShoot.Ui.PlayersSetup:OnClose()

	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		if (proxy) then
		
			proxy._DeviceRemoved:Remove(self, UATeamTagThenShoot.Ui.PlayersSetup.OnDeviceRemoved)
			
		end
	end

end

-- OnDeviceRemoved -----------------------------------------------------------

function UATeamTagThenShoot.Ui.PlayersSetup:OnDeviceRemoved(device)

	if (disconnectsoundenabled) then
		quartz.framework.audio.loadsound("base:audio/ui/gundisconnected.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:gd"])
		quartz.framework.audio.playsound()
		disconnectsoundenabled = false
	end



end

-- OnOpen  --------------------------------------------------------------------

function UATeamTagThenShoot.Ui.PlayersSetup:OnOpen()

	self.player = activity.match.challengers[1]

	-- next player : generic component

	self.uiNextPlayerPanel = self.uiNextMatchPanel:AddComponent(UIPlayerPanel:New(self.player, { 337.5 - UIPlayerPanel.width, 40 }), "uiNextPlayerPanel")

	-- tell player to take a gun

	if (self.player.rfGunDevice) then

		-- hud picture

		self.uiHudPicture = self.uiNextMatchPanel:AddComponent(UIPicture:New(), "uiHudPicture")
		self.uiHudPicture.color = UIComponent.colors.white
		self.uiHudPicture.texture = "base:texture/ui/pictograms/128x/Hud_" .. self.player.rfGunDevice.classId .. ".tga"
		self.uiHudPicture.rectangle = { 450, 40, 578, 168 }

		-- text

		self.uiHudLabel = self.uiNextMatchPanel:AddComponent(UILabel:New(), "uiHudLabel")
		self.uiHudLabel.font = UIComponent.fonts.default
		self.uiHudLabel.fontColor = UIComponent.colors.orange
		self.uiHudLabel.fontJustification = quartz.system.drawing.justification.center + quartz.system.drawing.justification.wordbreak
		self.uiHudLabel.text = l"oth061" .. self.player.rfGunDevice.classId
		self.uiHudLabel.rectangle = { 450, 170, 578, 220 }

	end

	-- get first last three matchs 

	self.uiMatchSlot = {}
	for i = 1, math.min(#activity.matches, 3) do

		local match = activity.matches[i]
		for j, team in ipairs(activity.teams) do
			
			local player = match.challengers.players[1]
			self.uiMatchSlot[j][i] = self.uiMatchListPanel:AddComponent(UIPlayerSlot:New() ,"uiMatchSlot" .. j .. i)
			self.uiMatchSlot[j][i]:SetPlayer(player)
			self.uiMatchSlot[j][i]:MoveTo(97.5 + 50 * j, 40 + 50 * (i - 1))
		end

	end	

	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		proxy._DeviceRemoved:Add(self, UATeamTagThenShoot.Ui.PlayersSetup.OnDeviceRemoved)
	end

end

-- Update --------------------------------------------------------------------

function UATeamTagThenShoot.Ui.PlayersSetup:Update()

	-- end of configuration 

	--self.uiButton5.enabled = activity.states["playerssetup"].configDone

end
