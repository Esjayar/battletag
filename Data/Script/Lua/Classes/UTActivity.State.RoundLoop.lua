
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.State.RoundLoop.lua
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

require "UTActivity.Ui.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UTActivity.State.RoundLoop = UTClass(UTState)

-- defaults ------------------------------------------------------------------

UTActivity.State.RoundLoop.uiClass = UTActivity.Ui.RoundLoop

-- __ctor --------------------------------------------------------------------

function UTActivity.State.RoundLoop:__ctor(activity, ...)
    
    -- timer

    self.time = quartz.system.time.gettimemicroseconds()
    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UTActivity.State.RoundLoop:Begin()
	
	
	-- register	to proxy message received

	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		proxy._DispatchMessage:Add(self, self.OnDispatchMessage)
	end

	-- timer

	self.time = quartz.system.time.gettimemicroseconds()
    activity.timer = 0

    game.gameMaster:Begin()	
	game.gameMaster:RegisterActivitySound()

	UIMenuManager.stack:Push(self.uiClass)

	engine.libraries.audio:Play("base:audio/musicingame.ogg", game.settings.audio["volume:music"])

	-- deconnection

	self.canBeStopped = true
	
	local number = 0
	for index, proxy in ipairs(engine.libraries.usb.proxies) do
	local device = proxy.devices.byRadioProtocolId[2]
		if (device) then
			self.proxy = proxy
			number = number + 1
			if (number > 1) then
				self.multiubi = true
			end
		end
		proxy.processes.devicePinger:Reset(2000000, 10000000, 500000)
		proxy._DeviceRemoved:Add(self, self.OnDeviceRemoved)
	end

end

-- End -----------------------------------------------------------------------

function UTActivity.State.RoundLoop:End()


	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		if (proxy) then

			-- unregister to proxy message received
			
			proxy._DispatchMessage:Remove(self, self.OnDispatchMessage)	

			-- deconnection

			proxy._DeviceRemoved:Remove(self, self.OnDeviceRemoved)
			proxy.processes.devicePinger:Reset()
			
		end
	end
    
    
	-- ?? no pop here : we need to display end_match ui before

	-- UIMenuManager.stack:Pop()
	game.gameMaster:End()

	engine.libraries.audio:Play("base:audio/musicmenu.ogg",game.settings.audio["volume:music"])

end

-- OnDeviceRemoved  ----------------------------------------------------------

function UTActivity.State.RoundLoop:OnDeviceRemoved(device)
	
	-- is there still a device now ?

	local numberOfDevice = 0
	for _, player in ipairs(activity.match.players) do

		if (player.rfGunDevice and player.rfGunDevice ~= device) then

			numberOfDevice = numberOfDevice + 1

		end

	end

	print("number of device : " .. numberOfDevice)

	-- only one devices

	if (self.canBeStopped and numberOfDevice <= 1) then

        self.uiPopup = UIPopupWindow:New()

        self.uiPopup.title = l"oth041"
        if (numberOfDevice == 1) then
        	self.uiPopup.text = l"oth042"
        else
        	self.uiPopup.text = l"oth043"
        end

        -- buttons
        
        self.uiPopup.uiButton1 = self.uiPopup:AddComponent(UIButton:New(), "uiButton1")
        self.uiPopup.uiButton1.rectangle = UIPopupWindow.buttonRectangles[1]
        self.uiPopup.uiButton1.text = l "but025"

        self.uiPopup.uiButton1.OnAction = function ()

			UIManager.stack:Pop()

        end

        self.uiPopup.uiButton2 = self.uiPopup:AddComponent(UIButton:New(), "uiButton2")
        self.uiPopup.uiButton2.rectangle = UIPopupWindow.buttonRectangles[2]
        self.uiPopup.uiButton2.text = l "but019"

        self.uiPopup.uiButton2.OnAction = function ()

			UIManager.stack:Pop()
			activity:PostStateChange("endmatch")

        end

        UIManager.stack:Push(self.uiPopup)	

		self.canBeStopped = false

	end
	
	if (not self.canBeStopped and numberOfDevice > 1) then
		UIManager.stack:Pop()
		self.canBeStopped = true
	end

end

-- OnDispatchMessage  -----------------------------------------------------

function UTActivity.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)
end

-- Update ---------------------------------------------------------------------

function UTActivity.State.RoundLoop:Update()

    local elapsedTime = quartz.system.time.gettimemicroseconds() - (self.time or 0)
    self.time = quartz.system.time.gettimemicroseconds()

	-- global timer   

    activity.timer = math.max(activity.timer - elapsedTime, 0)

	-- send data message 
	-- !! sometimes send a ping message, because it's not done anymore during roundloop and some inactives guns can be deconnected

	self.msgTime = (self.msgTime or 0) + elapsedTime
	proxylocktimer = (proxylocktimer or 0) + elapsedTime
	if (self.msgTime > game.settings.TestSettings.roundloopcycle) then

		self.msgTime = 0
		--for index, prox in ipairs(engine.libraries.usb.proxies) do
		--	if (self.proxy ~= prox) then
		--		self.proxy = prox
		--		break
		--	end
		--end

		if (self.proxy) then

			self.currentPlayerIndex = (self.currentPlayerIndex or 1)
			if (self.currentPlayerIndex <= #activity.match.players) then
				local player = activity.match.players[self.currentPlayerIndex]
				if (player and player.rfGunDevice) then
					if (player.rfGunDevice.gamedatablock) then
						-- send the configuration message,
						-- when applicable
							
						-- full message data = sound volume + beam power + configuration data 
							
						if (activity.advancedsettings.classes) then
							self.message = { 3 + #activity.configData * 2, player.rfGunDevice.radioProtocolId, 0x92, player.data.heap.audio, player.data.heap.beamPower, #activity.configData}
						else
							self.message = { 3 + #activity.configData * 2, player.rfGunDevice.radioProtocolId, 0x92, game.settings.audio["volume:blaster"], game.settings.ActivitySettings.beamPower, #activity.configData}
						end
						activity:InitEntityHeapData(player)
						for i = 1, #activity.configData do
							self.message[2 * i + 5] = quartz.system.bitwise.bitwiseand(player.data.heap[activity.configData[i]], 0xff00) / 256
							self.message[2 * i + 6] = quartz.system.bitwise.bitwiseand(player.data.heap[activity.configData[i]], 0x00ff)
						end
						--[[if (self.multiubi) then
							for index, proxy in ipairs(engine.libraries.usb.proxies) do
								if (player.rfGunDevice.host == proxy) then
									quartz.system.usb.sendmessage(proxy.handle, self.message)
								end
							end
						else]]
							quartz.system.usb.sendmessage(self.proxy.handle, self.message)
						--end
						player.rfGunDevice.gamedatablock = false
					else
						if (player.bonus) then
							for i, j in pairs(activity.gameplayDatabonus) do
								game.gameplayData[i] = j
							end
						else
							for i, j in pairs(activity.gameplayData) do
								game.gameplayData[i] = j
							end
						end
						if (player.gameplayData) then
							for i, j in pairs(player.gameplayData) do
								game.gameplayData[i + #activity.gameplayData] = j
							end
						end
						local size = #game.gameplayData
						local nbData = size / 2
						--[[if (self.multiubi) then
							for index, proxy in ipairs(engine.libraries.usb.proxies) do
								if (player.rfGunDevice.host == proxy) then
									quartz.system.usb.sendmessage(proxy.handle, { size + 1, player.rfGunDevice.radioProtocolId, 0x95, nbData, unpack(game.gameplayData) })
								end
							end
						else]]
							quartz.system.usb.sendmessage(self.proxy.handle, { size + 1, player.rfGunDevice.radioProtocolId, 0x95, nbData, unpack(game.gameplayData) })
						--end
						
					end
	
				end
				self.currentPlayerIndex = self.currentPlayerIndex + 1

			else
	
				self.currentPlayerIndex = 1
				--[[if (self.multiubi) then
					for index, proxy in ipairs(engine.libraries.usb.proxies) do
						if (player.rfGunDevice.host == proxy) then
							quartz.system.usb.sendmessage(proxy.handle, { 0x00, 0xff, 0x05 })
						end
					end
				else]]
					quartz.system.usb.sendmessage(self.proxy.handle, { 0x00, 0xff, 0x05 })
				--end
	
			end

		end

	end
	if (game.settings.GameSettings.reconnect >= 2 ) then
        if (proxylocktimer >= 1800000) then
		    game.settings.GameSettings.reconnect = 2
            proxylocktimer = 0
			for index, proxy in ipairs(engine.libraries.usb.proxies) do
				proxy:Lock()
			end
        end
    else
        proxylocktimer = 0
	end

end

--[[ Amendments

2 Nov 2015 DYL
To fix Rejoin - not working only after Pairing Blasters in System Options
Not sure why fix works, but it does!
Line 247 changed ... ==3 to ...>=2 (seems as if sometimes reconnect = 3 is not always reset back to reconnect = 2, so rejoin button in UIAFP does not work
Line 251 added the proxy:Lock() which counters the proxy:Unlock() in the UIAFP when the rejoin button is pressed.
]]