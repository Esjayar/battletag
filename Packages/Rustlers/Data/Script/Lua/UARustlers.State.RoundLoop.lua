
--[[--------------------------------------------------------------------------
--
-- File:            UARustlers.State.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            November 25, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.State.RoundLoop"
require "UARustlers.Ui.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UARustlers.State.RoundLoop = UTClass(UTActivity.State.RoundLoop)

-- defaults ------------------------------------------------------------------

UARustlers.State.RoundLoop.uiClass = UARustlers.Ui.RoundLoop

-- __ctor --------------------------------------------------------------------

function UARustlers.State.RoundLoop:__ctor(activity, ...)

    -- timer

    self.time = quartz.system.time.gettimemicroseconds()
    activity.timer = 0
    
    assert(activity)
	
end

-- Begin ---------------------------------------------------------------------

function UARustlers.State.RoundLoop:Begin()

	UTActivity.State.RoundLoop.Begin(self)

	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_32.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_33.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_34.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_35.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_125.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_126.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_132.wav",
											"base:audio/gamemaster/DLG_GM_RUSTLERS_09.wav",
											"base:audio/gamemaster/DLG_GM_RUSTLERS_10.wav",}, priority = 4 })

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
    self.shootCount = 0
    self.shootCountTime = self.time
    activity.timer = activity.settings.playtime * 60 * 1000000

end

-- Message received from device  -----------------------------------------------------------------------

function UARustlers.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)

	-- base

	UTActivity.State.RoundLoop.OnDispatchMessage(self)

	if (0x95 == command) then

		-- decode this msg !!

		if (device.owner) then

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
				
				elseif (device.owner.data.heap.ammunitions > ammunitions) then
				
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

			-- data
		
			local lifePoints = (arg[2] * 256) + arg[3]
			local energy = (arg[10] * 256) + arg[11]
			local lastBaseScanned = (arg[12] * 256) + arg[13]

			if (lifePoints == 1) then
				-- throw "Mediiiic!" sound	
				game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_18.wav","base:audio/gamemaster/DLG_GM_GLOBAL_19.wav"},priority = 3,})	 
			end

			-- check if I have been shot ...

			if (device.owner.data.heap.lifePoints > lifePoints) then

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

			end
			
			local diff = math.max(0, device.owner.data.heap.lifePoints - lifePoints)
			if (lastBaseScanned ~= (device.owner.team.index - 1)) then
				diff = diff + math.max(0, device.owner.data.heap.energy - energy)
			end
				
			local curIndex = 13 + diff--device.owner.data.heap.lifePoints - lifePoints
			while (diff > 0) do--device.owner.data.heap.lifePoints > lifePoints) do

				-- loose one life
				--device.owner.data.heap.lifePoints = device.owner.data.heap.lifePoints - 1

				-- get device that shot me
				local shooterDevice = engine.libraries.usb.proxy.devices.byRadioProtocolId[arg[math.min(18, curIndex)]]
				curIndex = curIndex - 1
				diff = diff - 1
				if (shooterDevice and shooterDevice.owner) then

					-- get shooter
					local shooter = shooterDevice.owner

					if ((0 == lifePoints) and (diff == 0)) then

						-- KILL ------------------------------------------------------

						if (shooter.team ~= device.owner.team) then
							shooter.data.heap.score = shooter.data.heap.score + 3
							shooter.team.data.heap.score = shooter.team.data.heap.score + 3
							activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame011" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death.tga")
						else
							activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame011" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death" .. shooter.team.profiles[shooter.team.index].teamColor .. ".tga" )
						end
						shooter.data.heap.death = shooter.data.heap.death + 1
						shooter.data.heap.killByName[device.owner.nameId] = (shooter.data.heap.killByName[device.owner.nameId] or 0) + 1
						device.owner.data.heap.isDead = 1							
						-- throw "Dans le mille!" sound	
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_27.wav","base:audio/gamemaster/DLG_GM_GLOBAL_28.wav","base:audio/gamemaster/DLG_GM_GLOBAL_37.wav","base:audio/gamemaster/DLG_GM_GLOBAL_38.wav",}, priority = 2,})	

					else

						-- HIT ------------------------------------------------------
						
						if (shooter.data.heap.lastPlayerShooted == device.owner) then
							shooter.data.heap.nbHitLastPlayerShooted = shooter.data.heap.nbHitLastPlayerShooted + 1
							if (shooter.data.heap.nbHitLastPlayerShooted == 3) then
								-- throw "Tireur d'élite" sound	
								game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_26.wav",}, priority = 3, proba = 0.33})	
								shooter.data.heap.nbHitLastPlayerShooted = 0
							end
						else
							shooter.data.heap.nbHitLastPlayerShooted = 1
							shooter.data.heap.lastPlayerShooted = device.owner
						end
						shooter.data.heap.hitLost = 0
						
						if (shooter.team ~= device.owner.team) then
							shooter.data.heap.score = shooter.data.heap.score + 1
							shooter.team.data.heap.score = shooter.team.data.heap.score + 1
							activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame009" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Hit.tga")
						else
							-- throw "teammateshoot" sound	
							game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_41.wav","base:audio/gamemaster/DLG_GM_GLOBAL_42.wav"}, priority = 2,})			
							activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame009" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Hit" .. shooter.team.profiles[shooter.team.index].teamColor .. ".tga" )
						end
						
						shooter.data.heap.hitByName[device.owner.nameId] = (shooter.data.heap.hitByName[device.owner.nameId] or 0) + 1
						shooter.data.heap.hit = shooter.data.heap.hit + 1

					end

				end

			end

			-- back to life or medkit !

			if (device.owner.data.heap.lifePoints < lifePoints) then

				if (1 == device.owner.data.heap.isDead) then

					device.owner.data.heap.nbRespawn = device.owner.data.heap.nbRespawn + 1
					activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame014", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Respawn" .. device.owner.team.profiles[device.owner.team.index].teamColor .. ".tga")
					
					device.owner.data.heap.isDead = 0
					-- throw "De retour" sound		
					game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_36.wav"}, priority = 2,})
				
				else

					device.owner.data.heap.nbMediKit = device.owner.data.heap.nbMediKit + 1
					activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame012", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Heart.tga")
					-- throw "ça va mieux?" sound		
					game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_16.wav","base:audio/gamemaster/DLG_GM_GLOBAL_17.wav"}, priority = 2,})	 
				
				end

			end
			
			-- store life points

			device.owner.data.heap.lifePoints = lifePoints

			-- energy and score 

			if (device.owner.data.heap.energy > energy) then

				if (lastBaseScanned == (device.owner.team.index - 1)) then

					-- scoring
					activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame028" .. " " .. device.owner.data.heap.energy .. " " .. l"ingame027", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/EnergyIcon.tga")
					device.owner.data.heap.score = device.owner.data.heap.score + (device.owner.data.heap.energy * 5)
					device.owner.team.data.heap.score = device.owner.team.data.heap.score + (device.owner.data.heap.energy * 5)

					if (device.owner.data.heap.energy == 5) then
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_138.wav", "base:audio/gamemaster/DLG_GM_GLOBAL_139.wav", "base:audio/gamemaster/DLG_GM_GLOBAL_140.wav"}, priority = 2,})	
					elseif (device.owner.data.heap.energy == 1) then						
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_RUSTLERS_03.wav",}, priority = 2,})	
					elseif (device.owner.data.heap.energy == 2) then						
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_RUSTLERS_04.wav",}, priority = 2,})	
					elseif (device.owner.data.heap.energy == 3) then						
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_RUSTLERS_05.wav",}, priority = 2,})	
					elseif (device.owner.data.heap.energy == 4) then						
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_RUSTLERS_06.wav",}, priority = 2,})	
					end

				else

					if (energy == 0) then

						-- beeing shot 
						activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame025", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/EnergyIcon.tga")

					else

						-- loose energy
						activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame024", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/EnergyIcon.tga")
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_RUSTLERS_07.wav","base:audio/gamemaster/DLG_GM_RUSTLERS_08.wav",}, priority = 2, proba = 0.2})	

					end

				end

			elseif (device.owner.data.heap.energy < energy) then
			
				-- stole some energy from base

				activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame026" .. " " .. energy .. " " .. l"ingame027", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/EnergyIcon.tga")
				game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_RUSTLERS_01.wav","base:audio/gamemaster/DLG_GM_RUSTLERS_02.wav",}, priority = 2,})	

			end

			-- store energy

			device.owner.data.heap.energy = energy

		end

	end

end

function UARustlers.State.RoundLoop:Update()

	UTActivity.State.RoundLoop.Update(self)

	-- end match

	if (activity.timer <= 0) then
		activity:PostStateChange("endround")
	end

end