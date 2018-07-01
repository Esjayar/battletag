
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.BeginMatch.lua
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

require "Ui/UIMenuPage"
require "Ui/UIClosingWindow"

--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.BeginMatch = UTClass(UIPage)

-- defaults

UTActivity.Ui.BeginMatch.transparent = true

-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.BeginMatch:__ctor(...)

    -- countdown duration & timer

	if (GEAR_CFG_COMPILE == GEAR_COMPILE_DEBUG) then
		self.countdownDuration = 2
	else
		self.countdownDuration = activity.countdownDuration
	end

    self.timer = self.countdownDuration * 1000000

	-- closing windows

	self.countdownWindows = self:AddComponent(UIClosingWindow:New(), "uiClosingWindow")
	self.countdownWindows:Build("base:texture/ui/Countdown_Top.tga", "base:texture/ui/Countdown_Bottom.tga")
	self.countdownWindows:CloseWindow()

	-- countdown 

	self.countDownPosition = { 480 - 66, 360 - 64}
	self.displayCountdown = false
	self.countdownMsg = self.countdownDuration + 1

	for _, player in ipairs(activity.match.players) do

		if (player.rfGunDevice) then
			player.rfGunDevice.acknowledge = false
		end

	end

end

-- __dtor -------------------------------------------------------------------

function UTActivity.Ui.BeginMatch:__dtor()
end

-- Draw -------------------------------------------------------------------

function UTActivity.Ui.BeginMatch:Draw()

	UIPage.Draw(self)

	--

	if (self.displayCountdown) then

		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.orange))
		
		local offset = 0
		
		if (math.floor(self.countdown/10) ~= 0) then

			offset = 30
			quartz.system.drawing.loadtexture("base:texture/ui/Countdown_" .. math.floor(self.countdown/10) .. ".tga")
			quartz.system.drawing.drawtexture(self.countDownPosition[1] - 2 * offset, self.countDownPosition[2])
			
		end
 
        quartz.system.drawing.loadtexture("base:texture/ui/Countdown_" .. (self.countdown%10) .. ".tga")
        quartz.system.drawing.drawtexture(self.countDownPosition[1] + offset, self.countDownPosition[2])
            
	end

end

-- OnClose -------------------------------------------------------------------

function UTActivity.Ui.BeginMatch:OnClose()

	self.countdownWindows._WindowClosed:Remove(self, UTActivity.Ui.BeginMatch.OnWindowClosed)
	self.countdownWindows._WindowOpened:Remove(self, UTActivity.Ui.BeginMatch.OnWindowOpened)
	engine.libraries.usb.proxy._DispatchMessage:Remove(self, UTActivity.Ui.BeginMatch.OnDispatchMessage)

end

-- OnDispatchMessage ---------------------------------------------------------

function UTActivity.Ui.BeginMatch:OnDispatchMessage(device, addressee, command, arg)

	-- acknowledge answers 

	if (0x93 == command) then

		if (device and not device.acknowledge) then

			device.acknowledge = true

		end

	end

end

-- OnOpen --------------------------------------------------------------------

function UTActivity.Ui.BeginMatch:OnOpen()

	self.countdownWindows._WindowClosed:Add(self, UTActivity.Ui.BeginMatch.OnWindowClosed)
	self.countdownWindows._WindowOpened:Add(self, UTActivity.Ui.BeginMatch.OnWindowOpened)
	engine.libraries.usb.proxy._DispatchMessage:Add(self, UTActivity.Ui.BeginMatch.OnDispatchMessage)

end

-- animation finished ----------------------------------------------------------

function UTActivity.Ui.BeginMatch:OnWindowClosed()

	self.displayCountdown = true

end

-- animation finished -------------------------------------------------------------------

function UTActivity.Ui.BeginMatch:OnWindowOpened()

	-- closing this ui ?

	UIManager.stack:Pop()

end

-- Update -------------------------------------------------------------------

function UTActivity.Ui.BeginMatch:Update()

    local time = quartz.system.time.gettimemicroseconds()
    local dt = time - (self.time or quartz.system.time.gettimemicroseconds())
    self.time = time    

	-- update closing windows

	self.countdownWindows:Update(dt)

	-- countdown

	if (self.displayCountdown) then

		self.timer = math.max(self.timer - dt, 0)
		self.countdown = math.ceil(self.timer / 1000000)

		-- send message to all gun 

		if (self.countdownMsg > self.countdown) then

			self.countdownMsg = self.countdown
			for _, player in ipairs(activity.match.players) do

				if (player.rfGunDevice and	not player.rfGunDevice.acknowledge) then

					local msg = {0x01, player.rfGunDevice.radioProtocolId, 0x93, self.countdown}
					quartz.system.usb.sendmessage(engine.libraries.usb.proxy.handle, msg)

				end

			end

		end

		-- finished 

		if (self.countdown <= 0) then

			self.displayCountdown = false
			self.countdownWindows:OpenWindow()
			if (activity.settings and (1 == activity.settings.gameLaunch)) then
				UIManager.stack:Pop(-1)
			end			
			UIMenuManager.stack:Pop() 
			activity:PostStateChange("roundloop")

		end

	end

end
