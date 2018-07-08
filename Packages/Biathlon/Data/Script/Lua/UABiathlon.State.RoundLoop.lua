
--[[--------------------------------------------------------------------------
--
-- File:            UABiathlon.State.RoundLoop.lua
--                  Copyright (c) Laserwarriors Laser Tag. All rights reserved.
--
-- Project:         Team Biathlon
-- Date:            Sep 2016
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.State.RoundLoop"

	require "UABiathlon.Ui.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UABiathlon.State.RoundLoop = UTClass(UTActivity.State.RoundLoop)

-- defaults ------------------------------------------------------------------

UABiathlon.State.RoundLoop.uiClass = UABiathlon.Ui.RoundLoop

-- __ctor --------------------------------------------------------------------

function UABiathlon.State.RoundLoop:__ctor(activity, ...)

    assert(activity)
    
end

-- Begin ---------------------------------------------------------------------

function UABiathlon.State.RoundLoop:Begin()

	UTActivity.State.RoundLoop.Begin(self)				 
    -- timer

    self.time = quartz.system.time.gettimemicroseconds()
    activity.timer = activity.settings.playtime * 60 * 1000000
	game.gameplayData = { 0x00, 0x00 }
    
    -- player alive

	self.nbPlayerAlive = #activity.players

end

-- Message received from device  ----------------------------------------------

function UABiathlon.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)

	if (0x95 == command) then

		-- decode this msg !!

		if (device.rejoin) then
			if ((arg[2] * 256) + arg[3] > 0) then
				device.rejoin = false
			end
		end
		if (device.owner and not device.rejoin) then

			-- life points		
			local lifePoints = (arg[2] * 256) + arg[3]
			if (device.owner.primary) then
				lifePoints = device.owner.primary.data.heap.lifePoints
			end
			-- check if I have been shot ...
			if (device.owner.data.heap.lifePoints > lifePoints) then
				--local curIndex = math.max(0, device.owner.data.heap.lifePoints - lifePoints)
				-- try to allow only 1 hit to pass thru at a time.
				local curIndex = 1
				while (curIndex > 0) do																			
					device.owner.data.heap.timeshit = device.owner.data.heap.timeshit + 1
					-- get device that shot me
					local shooter = activity.players[arg[math.min(14, curIndex + 9)] - 1]
					local shooterDevice = shooter.rfGunDevice
					if (shooterDevice and shooterDevice.owner and shooterDevice.owner.primary ~= device.owner and device.owner.primary ~= shooterDevice.owner) then				
							-- get shooter
						local shooter = shooterDevice.owner
						if (shooterDevice.owner.primary) then
							shooter = shooterDevice.owner.primary
						end
						-- msg to VAR nb_hit	RECEIVEd by shooter blaster
						shooter.gameplayData[2] = shooter.gameplayData[2] + 1					
						shooter.data.heap.score = shooter.data.heap.score + 1
						activity.uiAFP:PushLine(shooter.profile.name .. " "  .. l"ingame009" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Hit.tga")				
					end
					curIndex = 0
				end
			end
			device.owner.data.heap.lifePoints = lifePoints
		end
	end
end

-- Update ---------------------------------------------------------------------

function UABiathlon.State.RoundLoop:Update()

	UTActivity.State.RoundLoop.Update(self)

	-- end match

	if (activity.timer <= 0) then
		activity:PostStateChange("endround")
	end

end
