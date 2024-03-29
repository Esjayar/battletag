
--[[--------------------------------------------------------------------------
--
-- File:            UAOldFashionDuel.State.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 23, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.State.RoundLoop"
require "UAOldFashionDuel.Ui.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UAOldFashionDuel.State.RoundLoop = UTClass(UTActivity.State.RoundLoop)

-- defaults ------------------------------------------------------------------

UTActivity.State.RoundLoop.uiClass = UAOldFashionDuel.Ui.RoundLoop

-- __ctor --------------------------------------------------------------------

function UAOldFashionDuel.State.RoundLoop:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UAOldFashionDuel.State.RoundLoop:Begin()

	-- register	to proxy message received

	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		proxy._DispatchMessage:Add(self, self.OnDispatchMessage)
	end

	self.time = quartz.system.time.gettimemicroseconds()
    activity.timer = 0

	self.ui = self.uiClass:New()
	UIMenuManager.stack:Push(self.ui)
	
	game.gameMaster:Begin()	
	engine.libraries.audio:Play("base:audio/musicingame.ogg",game.settings.audio["volume:music"])
	
	-- deconnection

	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		proxy.processes.devicePinger:Reset(2000000, 8000000, 500000)
	end
	self.canBeStopped = true

    UIManager:StartBackgroundBanner()

    -- timer

    self.timer = quartz.system.time.gettimemicroseconds()
	self.msgTimer = quartz.system.time.gettimemicroseconds()

	-- current round	

	self.round = 0
	
	-- get current player

	self.player = {}
	self.player[1] = activity.match.challengers[1]
	self.player[2] = activity.match.challengers[2]

	-- init round

	self.phase = 2
	self.roundTimer = 3000000

	-- deconnection

    self.protectedMode = true
	self.canBeStopped = true
	
	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		proxy.processes.devicePinger:Reset(2000000, 10000000, 500000, self.protectedMode)
		proxy._DeviceRemoved:Add(self, self.OnDeviceRemoved)
	end

end

-- InitRound  ----------------------------------------------------------------

function UAOldFashionDuel.State.RoundLoop:InitRound()

	if (self.round >= activity.settings.numberOfRound) then

		activity:PostStateChange("endround")

	else

		-- GOooooooo timer

		self.phase = 0
		self.draw = false
		self.canShoot = false
		self.roundTimer = (1000000 * math.random(0.0, 3.0)) + 5000000

		self.round = self.round + 1

		-- start voice

		local random = 3 + math.random(0,2)
		local snd = "base:audio/gamemaster/DLG_GM_OW_DUEL_0" .. random .. ".wav"
		game.gameMaster:Play(snd, function () 
			if (self.phase == 0) then
				self.phase = 1
				self.ui:UpdateState("READY")
			end
		end)				

	end
	
end

-- OnDeviceRemoved  ----------------------------------------------------------

function UAOldFashionDuel.State.RoundLoop:OnDeviceRemoved(device)

	for _, player in ipairs(activity.match.players) do 

		if (self.canBeStopped and (player.rfGunDevice == device)) then

			self.uiPopup = UIPopupWindow:New()

			self.uiPopup.title = l"oth041"
			self.uiPopup.text = l"con047"

			-- buttons

			self.uiPopup.uiButton2 = self.uiPopup:AddComponent(UIButton:New(), "uiButton2")
			self.uiPopup.uiButton2.rectangle = UIPopupWindow.buttonRectangles[2]
			self.uiPopup.uiButton2.text = l "but019"

			self.uiPopup.uiButton2.OnAction = function ()

				UIManager.stack:Pop()
				activity:PostStateChange("endmatch")

			end

			UIManager.stack:Push(self.uiPopup)	
			self.canBeStopped = false

			break

		end

	end

end

-- Message received from device  ----------------------------------------------

function UAOldFashionDuel.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)

	-- base

	UTActivity.State.RoundLoop.OnDispatchMessage(self)

	-- decode this msg !!

	if (0x95 == command) then

		-- get nb life

		local nbHits = (arg[4] * 256) + arg[5]
		if ((self.phase <= 1) and (nbHits > device.owner.data.heap.nbHits)) then

			-- update ui

			self.ui:UpdateState()

			-- this player has been hit : give points !
			local shooter = activity.players[arg[6] - 1]
			local shooterDevice = shooter.rfGunDevice
			if (shooterDevice) then

				local player = shooterDevice.owner
				if (self.canShoot) then

					player.data.heap.score = player.data.heap.score + 1
					self.canShoot = false
					
					-- audio

					local number = 54 + shooterDevice.classId
					game.gameMaster:Play( "base:audio/gamemaster/DLG_GM_GLOBAL_" .. number .. ".wav", function() game.gameMaster:Play( "base:audio/gamemaster/DLG_GM_GLOBAL_119.wav") end )

				else

					device.owner.data.heap.score = device.owner.data.heap.score + 1
					
					-- audio

					game.gameMaster:RegisterSound({ 
						paths = {
							"base:audio/gamemaster/DLG_GM_OW_DUEL_08.wav",
							"base:audio/gamemaster/DLG_GM_OW_DUEL_09.wav"}
						, priority = 1
					})

				end

				self.phase = 2
				self.roundTimer = 4000000

			else

				game.gameMaster:Play( "base:audio/gamemaster/DLG_GM_GLOBAL_118.wav" )
				self.phase = 2
				self.roundTimer = 4000000
				self.draw = true

			end
		
		end
		device.owner.data.heap.nbHits = nbHits

		-- get nb ammo

		device.owner.data.heap.ammunitions = (arg[2] * 256) + arg[3]

		if ((self.phase <= 1) and (0 == self.player[1].data.heap.ammunitions) and (0 == self.player[2].data.heap.ammunitions)) then

			-- draw

			game.gameMaster:Play( "base:audio/gamemaster/DLG_GM_GLOBAL_118.wav" )
			self.phase = 2
			self.ui:UpdateState()
			self.roundTimer = 4000000

			-- ui

			self.draw = true				

		end

	end	

end

-- Update ---------------------------------------------------------------------

function UAOldFashionDuel.State.RoundLoop:Update()

	local elapsedTime = quartz.system.time.gettimemicroseconds() - (self.timer or quartz.system.time.gettimemicroseconds())
	self.timer = quartz.system.time.gettimemicroseconds()
	
	-- start a round

	if (0 < self.roundTimer) then

		self.roundTimer = self.roundTimer - elapsedTime
		if (0 >= self.roundTimer) then

			if (self.phase == 1) then

				local random = 6 + math.random(0,1)
				local snd = "base:audio/gamemaster/DLG_GM_OW_DUEL_0" .. random .. ".wav"
				game.gameMaster:Play(snd, function () 
					if (self.phase == 1) then
						self.canShoot = true 
						self.ui:UpdateState("FIRE", true)
						self.phase = 0
					end
				end)

			elseif (self.phase == 2) then

				self:InitRound()

			end
	
		end

	end

	activity.gameplayData = { 0x00, self.phase }
	UTActivity.State.RoundLoop.Update(self)

end
