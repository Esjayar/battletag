
--[[--------------------------------------------------------------------------
--
-- File:            UALastTeamStanding.State.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            November 22, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.State.RoundLoop"
require "UALastTeamStanding.Ui.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UALastTeamStanding.State.RoundLoop = UTClass(UTActivity.State.RoundLoop)

-- defaults ------------------------------------------------------------------

UALastTeamStanding.State.RoundLoop.uiClass = UALastTeamStanding.Ui.RoundLoop

-- __ctor --------------------------------------------------------------------

function UALastTeamStanding.State.RoundLoop:__ctor(activity, ...)

    -- timer

    self.time = quartz.system.time.gettimemicroseconds()
    activity.timer = 0
    
    assert(activity)
	
end

-- Begin ---------------------------------------------------------------------

function UALastTeamStanding.State.RoundLoop:Begin()

	UTActivity.State.RoundLoop.Begin(self)

	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_32.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_33.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_34.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_35.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_125.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_126.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_132.wav",
											"base:audio/gamemaster/DLG_GM_LAST_TEAM_06.wav",}, priority = 4 })

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

	-- nb team

	self.nbTeamAlive = #activity.match.challengers

end

-- Message received from device  -----------------------------------------------------------------------

function UALastTeamStanding.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)

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

			-- life points
		
			local lifePoints = (arg[2] * 256) + arg[3]
							
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

						--!! give him point only if not same team
						if (shooter) then

							if (0 == device.owner.data.heap.lifePoints) then

								-- KILL ------------------------------------------------------

								if (shooter.team ~= device.owner.team) then
									activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame011" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death.tga")
								else
									activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame011" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death" .. shooter.team.profiles[shooter.team.index].teamColor .. ".tga" )
								end
								shooter.data.heap.death = shooter.data.heap.death + 1
								shooter.data.heap.killByName[device.owner.nameId] = (shooter.data.heap.killByName[device.owner.nameId] or 0) + 1

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

				end

				if (0 == lifePoints) then

					-- This player is out

					device.owner.data.heap.icon = string.sub(device.owner.data.heap.icon, 0, #device.owner.data.heap.icon - 4)
					device.owner.data.heap.icon = device.owner.data.heap.icon .. "_Out.tga"		
					device.owner.data.heap.score = #device.owner.team.players - device.owner.team.data.heap.nbPlayerAlive
					device.owner.team.data.heap.nbPlayerAlive = device.owner.team.data.heap.nbPlayerAlive - 1

					-- only one player left in this team

					if (device.owner.team.data.heap.nbPlayerAlive == 1) then

						local curTeam = {"DLG_GM_LAST_TEAM_02.wav", "DLG_GM_LAST_TEAM_05.wav", "DLG_GM_LAST_TEAM_04.wav", "DLG_GM_LAST_TEAM_03.wav" }
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/" .. curTeam[device.owner.team.index],}, priority = 1,})	 

					elseif (device.owner.team.data.heap.nbPlayerAlive == 2) then

						local curTeam = {"DLG_GM_LAST_TEAM_07.wav", "DLG_GM_LAST_TEAM_10.wav", "DLG_GM_LAST_TEAM_09.wav", "DLG_GM_LAST_TEAM_08.wav" }
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/" .. curTeam[device.owner.team.index],}, priority = 1,})	 

					elseif (device.owner.team.data.heap.nbPlayerAlive > 0) then
						game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_LAST_TEAM_01.wav",}, priority = 1,})	 									
					end

				end

				-- check end of game
				
				if (device.owner.team.data.heap.nbPlayerAlive == 0) then
					device.owner.team.data.heap.score = #activity.match.challengers - self.nbTeamAlive
					self.nbTeamAlive = self.nbTeamAlive - 1
					if (self.nbTeamAlive <= 1) then
						activity:PostStateChange("endround")
					else

						if (self.nbTeamAlive == 2) then
							game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_LAST_TEAM_11.wav",}, priority = 0,})	 
						elseif (self.nbTeamAlive == 3) then
							game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_LAST_TEAM_12.wav",}, priority = 0,})	 
						end

						if (device.owner.team.index == 1) then
							activity.uiAFP:PushLine(l"ingame037", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death" .. device.owner.team.profile.teamColor .. ".tga" )							
						elseif (device.owner.team.index == 2) then
							activity.uiAFP:PushLine(l"ingame040", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death" .. device.owner.team.profile.teamColor .. ".tga" )							
						elseif (device.owner.team.index == 3) then
							activity.uiAFP:PushLine(l"ingame038", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death" .. device.owner.team.profile.teamColor .. ".tga" )							
						elseif (device.owner.team.index == 3) then
							activity.uiAFP:PushLine(l"ingame039", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Death" .. device.owner.team.profile.teamColor .. ".tga" )							
						end							

						-- throw "X players still in game" sound	
						-- game.gameMaster:RegisterSound({ paths = {"DLG_GM_FRAG_SURVIVAL_0".. (8 - self.nbTeamAlive) .. ".wav"}, priority = 1,})	
						-- throw "ambiance" sounds	
						-- game.gameMaster:RegisterSound({ paths = {"DLG_GM_FRAG_SURVIVAL_07.wav", "DLG_GM_FRAG_SURVIVAL_08.wav", "DLG_GM_FRAG_SURVIVAL_09.wav", "DLG_GM_FRAG_SURVIVAL_10.wav", "DLG_GM_FRAG_SURVIVAL_11.wav", "DLG_GM_FRAG_SURVIVAL_12.wav"}, offset = 4, proba = 0.333, priority = 3,})						
					end
				end

			elseif (device.owner.data.heap.lifePoints < lifePoints) then

				device.owner.data.heap.nbMediKit = device.owner.data.heap.nbMediKit + 1
				activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame012", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Heart.tga")
				-- throw "ça va mieux?" sound		
				game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_16.wav","base:audio/gamemaster/DLG_GM_GLOBAL_17.wav"}, priority = 2,})	 
				
			end
			
			-- store life points

			device.owner.data.heap.lifePoints = lifePoints
			device.owner.data.heap.score = lifePoints + #device.owner.team.players

		end

	end

end

function UALastTeamStanding.State.RoundLoop:Update()

	UTActivity.State.RoundLoop.Update(self)

end
