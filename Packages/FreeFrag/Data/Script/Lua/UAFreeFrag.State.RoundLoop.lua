
--[[--------------------------------------------------------------------------
--
-- File:            UAFreeFrag.State.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 27, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.State.RoundLoop"

	require "UAFreeFrag.Ui.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UAFreeFrag.State.RoundLoop = UTClass(UTActivity.State.RoundLoop)

-- defaults ------------------------------------------------------------------

UAFreeFrag.State.RoundLoop.uiClass = UAFreeFrag.Ui.RoundLoop

-- __ctor --------------------------------------------------------------------

function UAFreeFrag.State.RoundLoop:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UAFreeFrag.State.RoundLoop:Begin()

	UTActivity.State.RoundLoop.Begin(self)
	
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_13.wav", 
											 "base:audio/gamemaster/DLG_GM_GLOBAL_14.wav", 
											 "base:audio/gamemaster/DLG_GM_GLOBAL_15.wav"}, probas = {0.8, 0.1, 0.1}})

	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_45.wav"},offset = activity.settings.playtime * 60 - 60,})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_48.wav",
											 "base:audio/gamemaster/DLG_GM_GLOBAL_49.wav"},
									offset = activity.settings.playtime * 60 - 57, priority = 2, proba = 0.333})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_46.wav"},
									offset = activity.settings.playtime * 60 - 30,})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_48.wav",
											 "base:audio/gamemaster/DLG_GM_GLOBAL_49.wav"},
									offset = activity.settings.playtime * 60  - 27,priority = 2, proba = 0.333})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_47.wav"},
									offset = activity.settings.playtime * 60  - 15,})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_48.wav",
											 "base:audio/gamemaster/DLG_GM_GLOBAL_49.wav"},
									offset = activity.settings.playtime * 60 - 12, priority = 2, proba = 0.333})
									
    -- timer

    self.time = quartz.system.time.gettimemicroseconds()
    self.shootCount = 0
    self.shootCountTime = self.time
    activity.timer = activity.settings.playtime * 60 * 1000000

end

-- Message received from device  ----------------------------------------------

function UAFreeFrag.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)

	if (0x95 == command) then

		-- decode this msg !!

		if (device.owner) then

			--------------------------------------------------------------------------------------
			-- nb shots

			device.owner.data.heap.nbShot = (arg[4] * 256) + arg[5]

			--------------------------------------------------------------------------------------
			-- nb hits
		
			local nbHit = (arg[2] * 256) + arg[3]

			-- check if I have been shot ...
			if (device.owner.data.heap.nbHit < nbHit) then

				if (self.shootCount) then
					self.shootCount = self.shootCount + 1
					
					if (self.shootCount == 10) then
					
						local time = quartz.system.time.gettimemicroseconds()
					
						if (time - self.shootCountTime < 10 * 1000000) then
							-- ouais jsuis a donf
							game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_24.wav","base:audio/gamemaster/DLG_GM_GLOBAL_25.wav",}, priority = 2, proba = 0.25})
						end			
						
						self.shootCountTime = time			
						self.shootCount = 0
					end
					
				end
				local index = 0
				while (device.owner.data.heap.nbHit < nbHit) do

					-- loose one life
					device.owner.data.heap.nbHit = device.owner.data.heap.nbHit + 1

					-- get device that shot me
					local shooterDevice = engine.libraries.usb.proxy.devices.byRadioProtocolId[arg[6 + index]]
					if (shooterDevice) then

						-- get shooter
						local shooter = shooterDevice.owner

						--!! give him point 
						if (shooter) then

							-- HIT ------------------------------------------------------
							
							if (shooter.data.heap.lastPlayerShooted == device.owner) then
								shooter.data.heap.nbHitLastPlayerShooted = shooter.data.heap.nbHitLastPlayerShooted + 1
								if (shooter.data.heap.nbHitLastPlayerShooted == 3) then
									-- throw "Tireur d'élite" sound	
									game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_26.wav",}, priority = 3, proba = 0.333})	
									shooter.data.heap.nbHitLastPlayerShooted = 0
								end
							else
								shooter.data.heap.nbHitLastPlayerShooted = 1
								shooter.data.heap.lastPlayerShooted = device.owner
							end
								
							shooter.data.heap.score = shooter.data.heap.score + 1
							shooter.data.heap.hit = shooter.data.heap.hit + 1
							activity.uiAFP:PushLine(shooter.profile.name .. " "  .. " has shot " .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Hit.tga")
							shooter.data.heap.hitByName[device.owner.nameId] = (shooter.data.heap.hitByName[device.owner.nameId] or 0) + 1
							-- throw "Touché ! ça doit faire mal" sound									
							game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_29.wav","base:audio/gamemaster/DLG_GM_GLOBAL_30.wav"}, priority = 3, proba = 0.333})							
							
						end

					end
					index = index + 1

				end

			end

			device.owner.data.heap.nbHit = nbHit

		end

	end

end

-- Update ---------------------------------------------------------------------

function UAFreeFrag.State.RoundLoop:Update()

	UTActivity.State.RoundLoop.Update(self)

	-- end match

	if (activity.timer <= 0) then
		activity:PostStateChange("endround")
	end

end
