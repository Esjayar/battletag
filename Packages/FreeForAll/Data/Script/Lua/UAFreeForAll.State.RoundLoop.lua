
--[[--------------------------------------------------------------------------
--
-- File:            _UTActivityTest.State.RoundLoop.lua
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

require "UTActivity.State.RoundLoop"

	require "UAFreeForAll.Ui.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UAFreeForAll.State.RoundLoop = UTClass(UTActivity.State.RoundLoop)

-- defaults ------------------------------------------------------------------

UAFreeForAll.State.RoundLoop.uiClass = UAFreeForAll.Ui.RoundLoop

-- __ctor --------------------------------------------------------------------

function UAFreeForAll.State.RoundLoop:__ctor(activity, ...)

    assert(activity)
    
end

-- Begin ---------------------------------------------------------------------

function UAFreeForAll.State.RoundLoop:Begin()

	UTActivity.State.RoundLoop.Begin(self)				 

	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_13.wav", 
											 "base:audio/gamemaster/DLG_GM_GLOBAL_14.wav", 
											 "base:audio/gamemaster/DLG_GM_GLOBAL_15.wav"}, probas = {0.8, 0.1, 0.1}})

	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_45.wav"},offset = activity.settings.playtime * 60 - 60,})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_48.wav",
											 "base:audio/gamemaster/DLG_GM_GLOBAL_49.wav"},
									offset = activity.settings.playtime * 60 - 57, priority = 3, proba = 0.333})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_46.wav"},
									offset = activity.settings.playtime * 60 - 30,})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_48.wav",
											 "base:audio/gamemaster/DLG_GM_GLOBAL_49.wav"},
									offset = activity.settings.playtime * 60  - 27,priority = 3, proba = 0.333})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_47.wav"},
									offset = activity.settings.playtime * 60  - 15,})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_48.wav",
											 "base:audio/gamemaster/DLG_GM_GLOBAL_49.wav"},
									offset = activity.settings.playtime * 60 - 12, priority = 3, proba = 0.333})
    -- timer

    self.time = quartz.system.time.gettimemicroseconds()
    activity.timer = activity.settings.playtime * 60 * 1000000

end

-- Message received from device  ----------------------------------------------

function UAFreeForAll.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)

	if (0x95 == command) then

		-- decode this msg !!

		if (device.owner) then

			--------------------------------------------------------------------------------------
			-- ammunitions and clip

			local ammunitions = (arg[4] * 256) + arg[5]
						
			if (ammunitions == 3) then
				-- throw "We need Ammo! Now" sound		
				game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_22.wav","base:audio/gamemaster/DLG_GM_GLOBAL_23.wav"},priority = 3,})
			end
			
			local clips = (arg[6] * 256) + arg[7]
			device.owner.data.heap.nbShot = (arg[8] * 256) + arg[9]
			if (0 == device.owner.data.heap.isDead) then

				if ((device.owner.data.heap.ammunitions < ammunitions and device.owner.data.heap.clips <= clips) or device.owner.data.heap.clips < clips) then

					device.owner.data.heap.nbAmmoPack = device.owner.data.heap.nbAmmoPack + 1
					activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame006", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Ammunition.tga")
				end

				if (device.owner.data.heap.ammunitions > ammunitions) then
					device.owner.data.heap.hitLost = device.owner.data.heap.hitLost + 1
					if (device.owner.data.heap.hitLost == 5) then
						-- throw "T'es aveugle" sound	
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_43.wav","base:audio/gamemaster/DLG_GM_GLOBAL_44.wav"},priority = 2,})
						device.owner.data.heap.hitLost = 0
					end
					if (device.owner.data.heap.hitLost >= 2) then
						device.owner.data.nbHitLastPlayerShooted = 0
					end
				end

			end
			device.owner.data.heap.clips = clips
			device.owner.data.heap.ammunitions = ammunitions
			if (device.owner.data.heap.ammunitions == 20) then
				device.owner.data.heap.ammunitionsAndClips = "-/-"
			else
				device.owner.data.heap.ammunitionsAndClips = device.owner.data.heap.ammunitions .. "/" .. device.owner.data.heap.clips
			end
			
			--------------------------------------------------------------------------------------
			-- life points
		
			local lifePoints = (arg[2] * 256) + arg[3]
							
			if (lifePoints == 1) then
				-- throw "Mediiiic!" sound	
				game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_18.wav","base:audio/gamemaster/DLG_GM_GLOBAL_19.wav"},priority = 3,})	 
			end

			-- check if I have been shot ...
			if (device.owner.data.heap.lifePoints > lifePoints) then

				local curIndex = 9 + device.owner.data.heap.lifePoints - lifePoints
				while (device.owner.data.heap.lifePoints > lifePoints) do
					
					-- loose one life
					device.owner.data.heap.lifePoints = device.owner.data.heap.lifePoints - 1

					-- get device that shot me
					local shooterDevice = engine.libraries.usb.proxy.devices.byRadioProtocolId[arg[math.min(14, curIndex)]]
					curIndex = curIndex - 1					
					if (shooterDevice) then

						-- get shooter
						local shooter = shooterDevice.owner

						--!! give him point  : DO this better
						if (shooter) then

							if (0 == device.owner.data.heap.lifePoints) then

								-- KILL ------------------------------------------------------

								shooter.data.heap.score = shooter.data.heap.score + 3
								shooter.data.heap.death = shooter.data.heap.death + 1
								activity.uiAFP:PushLine(shooter.profile.name .. " "  .. l"ingame011" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death.tga")
								device.owner.data.heap.isDead = 1
								shooter.data.heap.killByName[device.owner.nameId] = (shooter.data.heap.killByName[device.owner.nameId] or 0) + 1
								-- throw "Dans le mille!" sound	
								game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_27.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_28.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_37.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_38.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_128.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_129.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_130.wav",
								}, priority = 2,})	
							else

								-- HIT ------------------------------------------------------
								
								if (shooter.data.heap.lastPlayerShooted == device.owner) then
									shooter.data.heap.nbHitLastPlayerShooted = shooter.data.heap.nbHitLastPlayerShooted + 1
									if (shooter.data.heap.nbHitLastPlayerShooted == 3) then
										-- throw "Tireur d'élite" sound	
										game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_26.wav","base:audio/gamemaster/DLG_GM_GLOBAL_122.wav","base:audio/gamemaster/DLG_GM_GLOBAL_123.wav","base:audio/gamemaster/DLG_GM_GLOBAL_124.wav",}, priority = 3, proba = 0.33})	
										shooter.data.heap.nbHitLastPlayerShooted = 0
									end
								else
									shooter.data.heap.nbHitLastPlayerShooted = 1
									shooter.data.heap.lastPlayerShooted = device.owner
								end
								shooter.data.heap.hitLost = 0
								
								
								shooter.data.heap.score = shooter.data.heap.score + 1
								shooter.data.heap.hit = shooter.data.heap.hit + 1																 
								activity.uiAFP:PushLine(shooter.profile.name .. " "  .. l"ingame009" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Hit.tga")
								shooter.data.heap.hitByName[device.owner.nameId] = (shooter.data.heap.hitByName[device.owner.nameId] or 0) + 1
								-- throw "Touché ! ça doit faire mal" sound									
								game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_29.wav","base:audio/gamemaster/DLG_GM_GLOBAL_30.wav"}, priority = 3, proba = 0.333})							
							end

						end

					end
				end

			elseif (device.owner.data.heap.lifePoints < lifePoints) then

				if (1 == device.owner.data.heap.isDead) then

					device.owner.data.heap.nbRespawn = device.owner.data.heap.nbRespawn + 1
					activity.uiAFP:PushLine(device.owner.profile.name .. " "  .. l"ingame014", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Respawn.tga")
					device.owner.data.heap.isDead = 0
					-- throw "De retour" sound		
					game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_36.wav"}, priority = 2,})
				
				else

					device.owner.data.heap.nbMediKit = device.owner.data.heap.nbMediKit + 1
					activity.uiAFP:PushLine(device.owner.profile.name .. " "  .. l"ingame012", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Heart.tga")
					-- throw "ça va mieux?" sound		
					game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_16.wav","base:audio/gamemaster/DLG_GM_GLOBAL_17.wav"}, priority = 2,})	 
				
				end

			end

			device.owner.data.heap.lifePoints = lifePoints

		end

	end

end

-- Update ---------------------------------------------------------------------

function UAFreeForAll.State.RoundLoop:Update()

	UTActivity.State.RoundLoop.Update(self)

	-- end match

	if (activity.timer <= 0) then
		activity:PostStateChange("endround")
	end

end
