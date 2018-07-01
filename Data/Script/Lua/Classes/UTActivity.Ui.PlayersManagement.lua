
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.PlayersManagement.lua
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
require "UTGame.Ui.Associate"

    require "Ui/UIContextualMenu"
    require "Ui/UIPlayerSlotGrid"

--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.PlayersManagement = UTClass(UIMenuWindow)

-- default

-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.PlayersManagement:__ctor(...)

    assert(activity)

	-- window settings

	self.uiWindow.title = l "titlemen012"

    -- panel 

		self.uiPanel = self.uiWindow:AddComponent(UIPanel:New(), "uiPanel")
		self.uiPanel.rectangle = self.clientRectangle

    -- picture and text on left

    	self.uiPicture1 = self.uiPanel:AddComponent(UIPicture:New(), "uiPicture1")
		self.uiPicture1.color = UIComponent.colors.white
		self.uiPicture1.rectangle = { -10, 10, -10 + 400, 10 + 350 }
		self.uiPicture1.texture = "base:texture/ui/TBlaster_TurnOn.tga"

    	self.uiLabel1 = self.uiPanel:AddComponent(UILabel:New(), "uiLabel1")
		self.uiLabel1.font = UIComponent.fonts.header
		self.uiLabel1.fontColor = UIComponent.colors.darkgray
		self.uiLabel1.fontJustification = quartz.system.drawing.justification.topleft + quartz.system.drawing.justification.wordbreak
		self.uiLabel1.rectangle = { 45, 15, 380, 55 }
		self.uiLabel1.text = l"oth023"

    	self.uiPicture2 = self.uiPanel:AddComponent(UIPicture:New(), "uiPicture2")
		self.uiPicture2.color = UIComponent.colors.white
		self.uiPicture2.rectangle = { 5, 310, 15 + 128, 310 + 128}
		self.uiPicture2.texture = "base:texture/ui/warning.tga"--128 128
		
    	self.uiLabel2 = self.uiPanel:AddComponent(UILabel:New(), "uiLabel1")
		self.uiLabel2.font = UIComponent.fonts.default
		self.uiLabel2.fontColor = UIComponent.colors.orange
		self.uiLabel2.fontJustification = quartz.system.drawing.justification.topleft + quartz.system.drawing.justification.wordbreak
		self.uiLabel2.rectangle = { 155, 320, 335, 440 }
		self.uiLabel2.text = l"oth063"
    
    -- my slot grid

		self.slotGrid = self.uiPanel:AddComponent(UIPlayerSlotGrid:New(activity.maxNumberOfPlayer, activity.settings.numberOfTeams), "slotGrid")
		self.slotGrid:MoveTo( 390, 40 )
		

	-- uiButton1: back

		self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
		self.uiButton1.rectangle = UIMenuWindow.buttonRectangles[1]
		self.uiButton1.text = l"but003"
		self.uiButton1.tip = l"tip006"
		self.uiButton1.OnAction = function (self) 

			quartz.framework.audio.loadsound("base:audio/ui/back.wav")
			quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
			quartz.framework.audio.playsound()
		
			if (activity.forward) then game:PostStateChange("selector") 
			else activity:PostStateChange("playground")
			end

		end

	-- uiButton3: invite player

		if ((activity.category == UTActivity.categories.single) or (GEAR_CFG_COMPILE == GEAR_COMPILE_DEBUG)) then

			self.uiButton3 = self:AddComponent(UIButton:New(), "uiButton3")
			self.uiButton3.rectangle = UIMenuWindow.buttonRectangles[3]
			self.uiButton3.text = l"but015"
			self.uiButton3.tip = l"tip048"

			self.uiButton3.OnAction = function (self) 
				activity.states["playersmanagement"]:CreatePlayer() 
			end

		end

	-- uiButton4: accept

	    self.uiButton4 = self:AddComponent(UIButton:New(), "uiButton4")
	    self.uiButton4.rectangle = UIMenuWindow.buttonRectangles[4]
		self.uiButton4.text = l"but014"
		self.uiButton4.tip = l"tip019"
		
		self.uiButton4.OnAction = function (self)

			-- check whether any of the required gun devices needs to be updated
			-- possible updates include: firmware, data banks

			local updateRequired = false

			for _, player in pairs(activity.players) do
				updateRequired = updateRequired or (player.rfGunDevice and player.rfGunDevice.updateRequired)
			end

			if (updateRequired) then

				-- lock the usb proxy so as to refuse any further connection requests

				engine.libraries.usb.proxy:Lock()

				-- create a popup to warn user(s) about the pending updates
				-- the popup offers no other choice than to accept the updates

				local uiPopup = UIPopupWindow:New()

				uiPopup.title = ""
				uiPopup.text = l"oth017"

				-- buttons

	            uiPopup.uiButton2 = uiPopup:AddComponent(UIButton:New(), "uiButton2")
		        uiPopup.uiButton2.rectangle = UIPopupWindow.buttonRectangles[2]
			    uiPopup.uiButton2.text = l"but019"

				uiPopup.uiButton2.OnAction = function ()

					UIManager.stack:Pop()
					activity:PostStateChange("revision", "bytecode")

				end

				UIManager.stack:Push(uiPopup)

			else

				quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
				quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
				quartz.framework.audio.playsound()
				activity:PostStateChange("bytecode")

			end

		end

		self.uiButton4.enabled = false

	-- timer

	self.timer = quartz.system.time.gettimemicroseconds()

end

-- CheckNumberOfPlayers ------------------------------------------------------

function UTActivity.Ui.PlayersManagement:CheckNumberOfPlayers()

	-- check updating profile

	for i = 1, #self.slotGrid.uiPlayerSlots do

--		print("value :  " .. i .. " --------------------------------" ) 
		if (self.slotGrid.uiPlayerSlots[i].player and self.slotGrid.uiPlayerSlots[i].updating) then	
			self.uiButton4.enabled = false
			return 
		end		

	end

	-- check number of player

	if (0 < #activity.teams) then

		-- enable only if no team is empy

	    self.uiButton4.enabled = true
		for i, team in ipairs(activity.teams) do

			local minimumNumberOfPlayer = 0
			if (minimumNumberOfPlayer >= #team.players) then

				self.uiButton4.enabled = false
				break

			end
		end

	else

	    -- enable button only if number of players is enough

		if (activity.category == UTActivity.categories.single) then

			-- need at least on rfgundevice

			self.uiButton4.enabled = false
			for _, player in ipairs(activity.players) do

				if ((player ~= player_) and player.rfGunDevice) then
					self.uiButton4.enabled = true
				end	

			end

		else

	        local numberOfPlayers = activity.players and (#activity.players + (offset or 0))
	        if (player_) then numberOfPlayers = numberOfPlayers - 1
	        end
		    self.uiButton4.enabled = (activity.minNumberOfPlayer <= numberOfPlayers)

		end

	end

end

-- OnClose -------------------------------------------------------------------

function UTActivity.Ui.PlayersManagement:OnClose()

    if (activity) then

        activity.states["playersmanagement"]._PlayerAdded:Remove(self, self.OnPlayerAdded)
        activity.states["playersmanagement"]._PlayerRemoved:Remove(self, self.OnPlayerRemoved)

    end

    if (engine.libraries.usb.proxy) then
	    engine.libraries.usb.proxy._DispatchMessage:Remove(self, UTActivity.Ui.PlayersManagement.OnDispatchMessage)	
	end

	-- check updating profile

	for i = 1, #self.slotGrid.uiPlayerSlots do
		if (self.slotGrid.uiPlayerSlots[i].profileUpdated and
		self.slotGrid.uiPlayerSlots[i].player and 
		self.slotGrid.uiPlayerSlots[i].player.rfGunDevice) then
			self.slotGrid.uiPlayerSlots[i]._ProfileUpdated:Remove(self, UTActivity.Ui.PlayersManagement.OnProfileUpdated)
		end
	end

end

-- OnDispatchMessage --------------------------------------------------------------------

function UTActivity.Ui.PlayersManagement:OnDispatchMessage(device, addressee, command, arg)

	if (0xC2 == command) then

		-- can change team ?
		if (1 == arg[1]) then

			if (not device.owner.buttonPressed) then

				activity.states["playersmanagement"]:ChangeTeam(device.owner)
				device.owner.buttonPressed = true

			end

		else

			device.owner.buttonPressed = false

		end

	end

end

-- OnPlayerAdded -------------------------------------------------------------

function UTActivity.Ui.PlayersManagement:OnPlayerAdded(player)

    assert(player:IsKindOf(UTPlayer))

	-- add in slot

	if (not player.rfGunDevice) then
		self.slotGrid:AddSlot(player, true)
		player._ProfileUpdated:Invoke(player)
	else
		local slot = self.slotGrid:AddSlot(player)
		slot._ProfileUpdated:Add(self, UTActivity.Ui.PlayersManagement.OnProfileUpdated)
		slot.profileUpdated = true
	end

	-- check number of player

	--self:CheckNumberOfPlayers()

end

-- OnPlayerRemoved -----------------------------------------------------------

function UTActivity.Ui.PlayersManagement:OnPlayerRemoved(player)

    assert(player:IsKindOf(UTPlayer))

	-- remove last

	local slot = self.slotGrid:RemoveSlot(player)
	if (player.rfGunDevice and slot.profileUpdated) then
		slot._ProfileUpdated:Remove(self, UTActivity.Ui.PlayersManagement.OnProfileUpdated)
		slot.profileUpdated = false
	end

	-- check number of player

	--self:CheckNumberOfPlayers()

	-- !! TO CORRECT AFTER RELEASE : unlock proxy 

	--if (#activity.players < activity.maxNumberOfPlayer) then engine.libraries.usb.proxy:Unlock()
	--end

end

-- OnProfileUpdated ----------------------------------------------------------

function UTActivity.Ui.PlayersManagement:OnProfileUpdated(slot)

	-- then check number of player

	--self:CheckNumberOfPlayers()

	-- !! TO CORRECT AFTER RELEASE :  lock proxy 

	--if (#activity.players >= activity.maxNumberOfPlayer) then engine.libraries.usb.proxy:Lock()
	--end

end

-- OnOpen --------------------------------------------------------------------

function UTActivity.Ui.PlayersManagement:OnOpen()

    -- add event listener

    activity.states["playersmanagement"]._PlayerAdded:Add(self, self.OnPlayerAdded)
    activity.states["playersmanagement"]._PlayerRemoved:Add(self, self.OnPlayerRemoved)

	-- register	to proxy message received

	engine.libraries.usb.proxy._DispatchMessage:Add(self, UTActivity.Ui.PlayersManagement.OnDispatchMessage)	

end

-- Update -------------------------------------------------------------------

function UTActivity.Ui.PlayersManagement:Update()

	-- check buttons !!!

	self:CheckNumberOfPlayers()

--[[

	-- send msg each 250ms for team chgt
	local elapsedTime = quartz.system.time.gettimemicroseconds() - self.timer
	if (elapsedTime > 250000) then

		self.timer = quartz.system.time.gettimemicroseconds()

		-- test button msg

		if (0 < #activity.teams) then

			self.msg = {0x00, 0xff, 0xC2, }
			quartz.system.usb.sendmessage(engine.libraries.usb.proxy.handle, self.msg)

		end


	end
--]]

end
