
--[[--------------------------------------------------------------------------
--
-- File:            UAStalktheLantern.State.RoundLoop.lua
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
require "UAStalktheLantern.Ui.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UAStalktheLantern.State.RoundLoop = UTClass(UTActivity.State.RoundLoop)

-- defaults ------------------------------------------------------------------

UAStalktheLantern.State.RoundLoop.uiClass = UAStalktheLantern.Ui.RoundLoop

-- __ctor --------------------------------------------------------------------

function UAStalktheLantern.State.RoundLoop:__ctor(activity, ...)

    -- timer

    self.time = quartz.system.time.gettimemicroseconds()
    activity.timer = 0
    
    assert(activity)
	
end

-- Begin ---------------------------------------------------------------------

function UAStalktheLantern.State.RoundLoop:Begin()

	UTActivity.State.RoundLoop.Begin(self)
	
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_13.wav", 
											 "base:audio/gamemaster/DLG_GM_GLOBAL_14.wav", 
											 "base:audio/gamemaster/DLG_GM_GLOBAL_15.wav"}, probas = {0.8, 0.1, 0.1}})

	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_32.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_33.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_34.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_35.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_125.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_126.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_132.wav",}, priority = 4 })

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
	game.gameplayData = { 0x00, 0x00 }

end

-- Message received from device  -----------------------------------------------------------------------

function UAStalktheLantern.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)

	-- base

	UTActivity.State.RoundLoop.OnDispatchMessage(self)

	if (0x95 == command) then

		-- decode this msg !!

		local gunseconds = (arg[8] * 256) + arg[9]
		if (gunseconds ~= device.owner.data.heap.gunseconds or gunseconds == 0 or device.owner.data.heap.lifePoints == 0) then
			device.owner.data.heap.guntime = quartz.system.time.gettimemicroseconds()
			device.owner.vestconnect = false
			if (gunseconds == 0) then
				device.owner.gameplayData[2] = 0
			end
		elseif (device.owner.data.heap.guntime + 5000000 < quartz.system.time.gettimemicroseconds() and game.settings.GameSettings.vestdisconnect == 0 and not device.timedout) then
			device.owner.gameplayData[2] = 7
		end
		if (device.owner.data.heap.guntime + 1000000 < quartz.system.time.gettimemicroseconds()) then
			device.owner.vestconnect = true
		end
		if (device.owner.secondary) then
			if (device.owner.data.heap.guntime + 900000 < quartz.system.time.gettimemicroseconds() or device.owner.data.heap.lifePoints == 0) then
				device.owner.secondary.gameplayData[2] = 7
			elseif (device.owner.gameplayData[2] ~= 7) then
				device.owner.secondary.gameplayData[2] = 6
			end
		end
		device.owner.data.heap.gunseconds = gunseconds
		if (device.rejoin) then
			if ((arg[2] * 256) + arg[3] > 0) then
				device.rejoin = false
			end
		end
		if (device.owner and not device.rejoin) then
	
			-- ammunitions and clip
			
			local ammunitions = (arg[4] * 256) + arg[5]	
				
			if (ammunitions == 3) then
				if (game.settings.audio.gmtalkative == 1) then
					-- throw "We need Ammo! Now" sound		
					game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_22.wav","base:audio/gamemaster/DLG_GM_GLOBAL_23.wav"},priority = 3,})
				end
			end
				
			local clips = (arg[6] * 256) + arg[7]
			if (0 == device.owner.data.heap.isDead) then
				
				if ((device.owner.defender or not device.owner.defender and activity.settings.ammunitionsStalker < 255) and (device.owner.data.heap.ammunitions < ammunitions and device.owner.data.heap.clips <= clips or device.owner.data.heap.clips < clips)) then
						
					device.owner.data.heap.nbAmmoPack = device.owner.data.heap.nbAmmoPack + 1
					activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame006", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Ammunition.tga")
					
				elseif (device.owner.data.heap.ammunitions > ammunitions) then
					device.owner.data.heap.nbShot = device.owner.data.heap.nbShot + (device.owner.data.heap.ammunitions - ammunitions)
					device.owner.data.heap.hitLost = device.owner.data.heap.hitLost + 1
					if (device.owner.data.heap.hitLost == 5) then
						if (game.settings.audio.gmtalkative == 1) then
							-- throw "T'es aveugle" sound	
							game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_43.wav","base:audio/gamemaster/DLG_GM_GLOBAL_44.wav"},priority = 2,})
						end
						device.owner.data.heap.hitLost = 0
					end
					if (device.owner.data.heap.hitLost >= 2) then
						device.owner.data.nbHitLastPlayerShooted = 0
					end
				end
			end
			device.owner.data.heap.clips = clips
			device.owner.data.heap.ammunitions = ammunitions
			if (not device.owner.defender and activity.settings.ammunitionsStalker == 255) then
				device.owner.data.heap.ammunitionsAndClips = "-/-"
			else
				device.owner.data.heap.ammunitionsAndClips = device.owner.data.heap.ammunitions .. "/" .. device.owner.data.heap.clips
			end

			-- data
		
			local lifePoints = (arg[2] * 256) + arg[3]
			if (device.owner.primary) then
				lifePoints = device.owner.primary.data.heap.lifePoints
			end

			if (lifePoints == 1) then
				if (game.settings.audio.gmtalkative == 1) then
					-- throw "Mediiiic!" sound	
					game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_18.wav","base:audio/gamemaster/DLG_GM_GLOBAL_19.wav"},priority = 3,})	 
				end
			end

			-- check if I have been shot ...

			if (device.owner.data.heap.lifePoints > lifePoints) then
				if (self.shootCount) then
					self.shootCount = self.shootCount + 1
					
					if (self.shootCount == 10) then
					
						local time = quartz.system.time.gettimemicroseconds()
					
						if (time - self.shootCountTime < 10 * 1000000) then
							if (game.settings.audio.gmtalkative == 1) then
								-- ouais jsuis a donf
								game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_24.wav","base:audio/gamemaster/DLG_GM_GLOBAL_25.wav",}, priority = 2, proba = 0.25})
							end
						end			
						
						self.shootCountTime = time			
						self.shootCount = 0
					end
					
				end

			end
				
			local curIndex = math.max(0, device.owner.data.heap.lifePoints - lifePoints)
			while (curIndex > 0) do
			
				device.owner.data.heap.timeshit = device.owner.data.heap.timeshit + 1

				-- get device that shot me
				local shooter = activity.players[arg[math.min(16, curIndex + 11)] - 1]
				local shooterDevice = shooter.rfGunDevice
				curIndex = curIndex - 1
				if (shooterDevice and shooterDevice.owner and shooterDevice.owner.primary ~= device.owner and device.owner.primary ~= shooterDevice.owner) then

					-- get shooter
					local shooter = shooterDevice.owner
					if (shooterDevice.owner.primary) then
						shooter = shooterDevice.owner.primary
					end

					if (0 == lifePoints and curIndex == 0) then

						-- KILL ------------------------------------------------------

						if (shooter.team ~= device.owner.team) then
							activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame011" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death.tga")
							shooter.data.heap.death = shooter.data.heap.death + 1
							shooter.data.heap.killByName[device.owner.nameId] = (shooter.data.heap.killByName[device.owner.nameId] or 0) + 1
							if (game.settings.audio.gmtalkative == 1) then
								-- throw "Dans le mille!" sound	
								game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_27.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_28.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_37.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_38.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_128.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_129.wav",
								"base:audio/gamemaster/DLG_GM_GLOBAL_130.wav",
								}, priority = 2,})
							end
						elseif (activity.settings.teamFrag == 1) then
							activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame011" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death" .. shooter.team.profiles[shooter.team.index].teamColor .. ".tga" )
							shooter.data.heap.death = shooter.data.heap.death + 1
							shooter.data.heap.killByName[device.owner.nameId] = (shooter.data.heap.killByName[device.owner.nameId] or 0) + 1
							game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_41.wav","base:audio/gamemaster/DLG_GM_GLOBAL_42.wav"}, priority = 2,})
						end
						device.owner.data.heap.isDead = 1
						
					else

						-- HIT ------------------------------------------------------
						
						if (shooter.data.heap.lastPlayerShooted == device.owner) then
							shooter.data.heap.nbHitLastPlayerShooted = shooter.data.heap.nbHitLastPlayerShooted + 1
							if (shooter.data.heap.nbHitLastPlayerShooted == 3) then
								if (game.settings.audio.gmtalkative == 1) then
									-- throw "Tireur d'�lite" sound	
									game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_26.wav",}, priority = 3, proba = 0.33})	
								end
								shooter.data.heap.nbHitLastPlayerShooted = 0
							end
						else
							shooter.data.heap.nbHitLastPlayerShooted = 1
							shooter.data.heap.lastPlayerShooted = device.owner
						end
						shooter.data.heap.hitLost = 0
						
						if (shooter.team ~= device.owner.team) then
							activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame009" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Hit.tga")
							shooter.data.heap.hitByName[device.owner.nameId] = (shooter.data.heap.hitByName[device.owner.nameId] or 0) + 1
							shooter.data.heap.hit = shooter.data.heap.hit + 1
						elseif (activity.settings.teamFrag == 1) then
							-- throw "teammateshoot" sound	
							game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_41.wav","base:audio/gamemaster/DLG_GM_GLOBAL_42.wav"}, priority = 2,})			
							activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame009" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Hit" .. shooter.team.profiles[shooter.team.index].teamColor .. ".tga" )
							shooter.data.heap.hitByName[device.owner.nameId] = (shooter.data.heap.hitByName[device.owner.nameId] or 0) + 1
							shooter.data.heap.hit = shooter.data.heap.hit + 1
						end
					end
				end
				if (0 == lifePoints and (device.owner.defender and activity.settings.livesDefender >= 1 and device.owner.data.heap.nbRespawn == activity.settings.livesDefender - 1 or not device.owner.defender and activity.settings.livesStalker >= 1 and device.owner.data.heap.nbRespawn == activity.settings.livesStalker - 1)) then
									
					-- This player is out
										
					device.owner.data.heap.icon = string.sub(device.owner.data.heap.icon, 0, #device.owner.data.heap.icon - 4)
					device.owner.data.heap.icon = device.owner.data.heap.icon .. "_Out.tga"
					device.owner.team.data.heap.nbPlayerAlive = device.owner.team.data.heap.nbPlayerAlive - 1
					-- check end of game
										
					if (device.owner.team.data.heap.nbPlayerAlive == 0) then
						if (device.owner.defender) then
							defenders.data.heap.score = 0
							stalkers.data.heap.score = 1
						end
						activity:PostStateChange("endround")				
					end
										
					-- only one player left in this team
										
					if (device.owner.team.data.heap.nbPlayerAlive == 1) then

						local curTeam = {"DLG_GM_LAST_TEAM_02.wav", "DLG_GM_LAST_TEAM_05.wav" }
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/" .. curTeam[device.owner.team.index],}, priority = 1,})	 

					elseif (device.owner.team.data.heap.nbPlayerAlive == 2) then

						local curTeam = {"DLG_GM_LAST_TEAM_07.wav", "DLG_GM_LAST_TEAM_10.wav" }
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/" .. curTeam[device.owner.team.index],}, priority = 1,})	 

					elseif (device.owner.team.data.heap.nbPlayerAlive > 0) then
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_LAST_TEAM_01.wav",}, priority = 1,})	 									
					end
				end
			end

			-- back to life or medkit !

			if (device.owner.data.heap.lifePoints < lifePoints) then

				if (1 == device.owner.data.heap.isDead or game.settings.addons.medkitPack == 0) then
					device.owner.data.heap.nbRespawn = device.owner.data.heap.nbRespawn + 1
					activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame014", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Respawn" .. device.owner.team.profiles[device.owner.team.index].teamColor .. ".tga")
					device.owner.data.heap.isDead = 0
					if (game.settings.audio.gmtalkative == 1) then
						-- throw "De retour" sound		
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_36.wav"}, priority = 2,})
					end
				
				else

					device.owner.data.heap.nbMediKit = device.owner.data.heap.nbMediKit + 1
					activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame012", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Heart.tga")
					if (game.settings.audio.gmtalkative == 1) then
						-- throw "�a va mieux?" sound		
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_16.wav","base:audio/gamemaster/DLG_GM_GLOBAL_17.wav"}, priority = 2,})	 
					end
				
				end

			end
			
			-- store life points
			device.owner.data.heap.lifePoints = lifePoints
			local lastBaseScanned = (arg[10] * 256) + arg[11]
			if (lastBaseScanned == 0 and device.owner.team.index == 2 and not device.owner.primary) then
				--activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame064", teamcolor, "base:texture/Ui/Icons/16x/FlagIcon" .. device.owner.team.index .. ".tga")
				device.owner.team.data.heap.score = 2
				activity:PostStateChange("endround")
			end
		end
	end
end

function UAStalktheLantern.State.RoundLoop:Update()

	UTActivity.State.RoundLoop.Update(self)

	-- end match
		
		if (activity.timer <= 0) then
			activity:PostStateChange("endround")
		end

end