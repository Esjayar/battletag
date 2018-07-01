
--[[--------------------------------------------------------------------------
--
-- File:            UAIntroduction.State.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 20, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.State.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UAIntroduction.State.RoundLoop = UTClass(UTState)
UAIntroduction.State.RoundLoop.ShootUbiconnect = true
-- defaults

-- __ctor --------------------------------------------------------------------

function UAIntroduction.State.RoundLoop:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UAIntroduction.State.RoundLoop:Begin()

    print("UAIntroduction.State.RoundLoop:Begin()")

	-- register	to proxy message received

	engine.libraries.usb.proxy._DeviceRemoved:Add(self, UAIntroduction.State.RoundLoop.OnDeviceRemoved)	
	engine.libraries.usb.proxy._DispatchMessage:Add(self, UAIntroduction.State.RoundLoop.OnDispatchMessage)	

    -- current bytecode stage

    UIMenuManager.stack:Pusha()

    self.stage = 0
    self.messageCount = 1
    self:Next()

end

-- End -----------------------------------------------------------------------

function UAIntroduction.State.RoundLoop:End()

    print("UAIntroduction.State.RoundLoop:End()")

    UIMenuManager.stack:Popa()

	-- unregister from proxy message received

    if (engine.libraries.usb.proxy) then

        engine.libraries.usb.proxy._DeviceRemoved:Remove(self, UAIntroduction.State.RoundLoop.OnDeviceRemoved)	
	    engine.libraries.usb.proxy._DispatchMessage:Remove(self, UAIntroduction.State.RoundLoop.OnDispatchMessage)	

	end

end

-- Next ----------------------------------------------------------------------

function UAIntroduction.State.RoundLoop:Next(ending)

	if (not ending) then
		self.stage = self.stage + 1
	else
		self.stage = 8
	end

    if (self.stage == 1) then

        -- stage 1,
        -- all players shoot the ubiconnect

        self.messages = { { 0x03, 0xff, 0x95, 0x01, 0x00, self.stage }, }
        self.shots = 0

        UIMenuManager.stack:Push(UAIntroduction.Ui.Seq_Stage1:New(self))

    elseif (self.stage == 2) then

        -- stage 2,
        -- all players put their harness on

        self.messages = { { 0x03, 0xff, 0x95, 0x01, 0x00, self.stage }, }

        UIMenuManager.stack:Replace(UAIntroduction.Ui.Seq_Stage2:New(self))

    elseif (self.stage == 3) then

        -- stage 3,
        -- all players put their harness on

        self.messages = { { 0x03, 0xff, 0x95, 0x01, 0x00, self.stage }, { 0x00, 0xff, 0xc1 }, }

        UIMenuManager.stack:Replace(UAIntroduction.Ui.Seq_Stage3:New(self))

    elseif (self.stage == 4) then

        -- stage 4,
        -- all players happily shoot themselves out

        self.messages = { { 0x03, 0xff, 0x95, 0x01, 0x00, self.stage }, }

        UIMenuManager.stack:Replace(UAIntroduction.Ui.Seq_Stage4:New(self))

    elseif (self.stage == 5) then

        -- stage 5,
        -- how to use the t-boxes

        self.messages = { { 0x03, 0xff, 0x95, 0x01, 0x00, self.stage }, }

        UIMenuManager.stack:Replace(UAIntroduction.Ui.Seq_Stage5:New(self))

        -- skipping stage 5,
        -- got to next state
        
        self:Next()

    elseif (self.stage == 6) then

        -- stage 6,
        -- how to use the t-boxes

        self.messages = { { 0x03, 0xff, 0x95, 0x01, 0x00, self.stage }, }

        UIMenuManager.stack:Replace(UAIntroduction.Ui.Seq_Stage6:New(self))

    elseif (self.stage == 7) then

		-- game over sequence

		self.messages = { { 0x06, 0xff, 0x94, 0x00, 0x00, 0x53, 0x44, 0x30, 0x37 }, }

        UIMenuManager.stack:Replace(UAIntroduction.Ui.Seq_Ready:New(self))

    else

		-- game over sequence with no UI !

		self.messages = { { 0x06, 0xff, 0x94, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, }

		--UIManager.stack:Pop()
        UIManager.stack:Push(UAIntroduction.Ui.Seq_Quit:New(self))

    end

    print("UAIntroduction.State.RoundLoop:Next()", self.stage)

    self.time = quartz.system.time.gettimemicroseconds()

end

-- OnDispatchMessage ---------------------------------------------------------

function UAIntroduction.State.RoundLoop:OnDeviceRemoved(device)

    if (device) then
        for _, player in pairs(activity.players) do
            if (player.rfGunDevice == device) then

                if (not self.suspended) then-- and not (8 <= self.stage)) then

                    self.suspended = true
                    self.messages = { { 0x06, 0xff, 0x94, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }, }

                    local uiPopup = UIPopupWindow:New()

                    uiPopup.title = l "con037"
                    uiPopup.text = l "con038"

                    -- buttons

                    uiPopup.uiButton2 = uiPopup:AddComponent(UIButton:New(), "uiButton2")
                    uiPopup.uiButton2.rectangle = UIPopupWindow.buttonRectangles[2]
                    uiPopup.uiButton2.text = l "but003"

                    uiPopup.uiButton2.OnAction = function ()

                        UIManager.stack:Pop()
                        self:PostStateChange("playersmanagement")

                    end

                    UIManager.stack:Push(uiPopup)

                end
            end
        end
    end

end

-- OnDispatchMessage ---------------------------------------------------------

function UAIntroduction.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)

    if (0xc1 == command) then

        if (device.owner) then
            device.owner.data.heap.harnessOn = (1 == arg[1])
        end

    elseif (0x95 == command) then

        -- print(unpack(arg))

        if (self.stage == 4) then

            -- [1] char = number of registers
            -- [2-3] = stage
            -- [4-5] = nb hits
            -- [6-10] = last 5 instigators

            if (device.owner) then

                local hits = arg[4] * 256 + arg[5]
                if (hits ~= device.owner.data.heap.hits) then

                    local difference = math.min(5, hits - device.owner.data.heap.hits)
                    for i = 1, difference do

                        -- the instigator scores the hit

                        local device = engine.libraries.usb.proxy.devices.byRadioProtocolId[arg[6 + difference - i]]
                        if (device) then
                            local player = device.owner
                            if (player) then

                                player.data.heap.score = player.data.heap.score + 1

                            end
                        end
                    end
                    
                    device.owner.data.heap.hits = hits

                end
            end

        elseif (self.stage == 6) then

            -- [1] char = number of registers
            -- [2-3] = stage
            -- [4-5] = last scan

            local scan = arg[4] * 256 + arg[5]
            local player = device.owner

            if (player) then

                if (scan == 65432) then
                    player.data.heap.scan = 65432
                elseif (scan == 65431) then
                    player.data.heap.scan = 65431
                else
                    player.data.heap.scan = false
				    player.data.heap.errScan = -scan
                end
            end

        end

    elseif (0xc3 == command) then

        if (engine.libraries.usb.proxy.radioProtocolId == addressee) then

            -- score shoot & reward instigator

            local device = engine.libraries.usb.proxy.devices.byRadioProtocolId[arg[2]]
            if (device) then

                local player = device.owner
                if (player) then
        
					if (UAIntroduction.State.RoundLoop.ShootUbiconnect == true and 9 > self.shots) then			
						UAIntroduction.State.RoundLoop.ShootUbiconnect = false
						game.gameMaster:Play("base:audio/gamemaster/dlg_gm_init_22.wav", function () UAIntroduction.State.RoundLoop.ShootUbiconnect = true end)
					end

                    self.shots = self.shots + 1
                    player.data.heap.shots = player.data.heap.shots + 1

                end
            end

        end

    elseif (0x94 == command) then

        if (self.stage >= 7) then

            -- game over acknowledge

			local player = device.owner
            if (player) then

				if (not player.data.heap.gameover) then
					player.data.heap.gameover = true
				end

			end
        end

    end

end

-- Update --------------------------------------------------------------------

function UAIntroduction.State.RoundLoop:Update()

    local time = quartz.system.time.gettimemicroseconds()
    local elapsedTime = time - (self.time or quartz.system.time.gettimemicroseconds())

    if (250000 <= elapsedTime) then

        self.time = time
				
		-- send message by message

		if (self.messages) then
		
			local message = self.messages[self.messageCount]
			print(message)
            if (message and engine.libraries.usb.proxy) then

				--[[if (7 <= self.stage) then
				    for _, player in pairs(activity.players) do
						if ((not player.data.heap.gameover) and player.rfGunDevice) then
						--	message[2] = player.rfGunDevice.radioProtocolId
							quartz.system.usb.sendmessage(engine.libraries.usb.proxy.handle, message)
							break
				        end
					end
				else
	                quartz.system.usb.sendmessage(engine.libraries.usb.proxy.handle, message)
                end--]]

	            quartz.system.usb.sendmessage(engine.libraries.usb.proxy.handle, message)
            end

            self.messageCount = self.messageCount + 1
            if (self.messageCount > #self.messages) then self.messageCount = 1
            end

        end
    end

end
