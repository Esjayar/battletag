
--[[--------------------------------------------------------------------------
--
-- File:            UALiquidator.State.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            Novmber 18, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.State.RoundLoop"
require "UALiquidator.Ui.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UALiquidator.State.RoundLoop = UTClass(UTActivity.State.RoundLoop)

-- defaults ------------------------------------------------------------------

UALiquidator.State.RoundLoop.uiClass = UALiquidator.Ui.RoundLoop

-- __ctor --------------------------------------------------------------------

function UALiquidator.State.RoundLoop:__ctor(activity, ...)

    -- timer

    self.time = quartz.system.time.gettimemicroseconds()
    activity.timer = 0
    
    assert(activity)
	
end

-- Begin ---------------------------------------------------------------------

function UALiquidator.State.RoundLoop:Begin()

	UTActivity.State.RoundLoop.Begin(self)

	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_32.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_33.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_34.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_35.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_125.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_126.wav",
											"base:audio/gamemaster/DLG_GM_GLOBAL_132.wav",}, priority = 4 })

	--game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_45.wav"},offset = activity.settings.playtime * 60 - 60,})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_48.wav",
											 "base:audio/gamemaster/DLG_GM_GLOBAL_49.wav"},
									offset = activity.settings.playtime * 60 - 57, priority = 3, proba = 0.333})
						 
	--game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_46.wav"},
	--								offset = activity.settings.playtime * 60 - 30,})
						 
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_48.wav",
											 "base:audio/gamemaster/DLG_GM_GLOBAL_49.wav"},
									offset = activity.settings.playtime * 60  - 27,priority = 3, proba = 0.333})
						 
	--game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_47.wav"},
	--								offset = activity.settings.playtime * 60  - 15,})
						 
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

function UALiquidator.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)

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
			if ((0 == device.owner.data.heap.isDead) and (device.owner.data.heap.ammunitions ~= 20)) then
			
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
									--shooter.data.heap.score = shooter.data.heap.score + 3
									--shooter.team.data.heap.score = shooter.team.data.heap.score + 3
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
									--shooter.data.heap.score = shooter.data.heap.score + 1
									--shooter.team.data.heap.score = shooter.team.data.heap.score + 1
									activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame009" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Hit.tga")
								else
									-- throw "teammateshoot" sound	
									game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_41.wav","base:audio/gamemaster/DLG_GM_GLOBAL_42.wav"}, priority = 2,})			
									activity.uiAFP:PushLine(shooter.profile.name .. " " .. l"ingame009" .. " " .. device.owner.profile.name, UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Hit" .. shooter.team.profiles[shooter.team.index].teamColor .. ".tga" )
								end
								
								shooter.data.heap.hitByName[device.owner.nameId] = (shooter.data.heap.hitByName[device.owner.nameId] or 0) + 1
								shooter.data.heap.hit = shooter.data.heap.hit + 1

								-- liquidator ?

								if (device.owner.liquidator) then
									if (device.owner.data.heap.lifePoints == 3) then
										game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_LIQUID_06.wav",}, priority = 2 })
									elseif (device.owner.data.heap.lifePoints == 1) then
										activity.gameplayData = { 0x00, 0x01 }
										game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_LIQUID_07.wav",}, priority = 2 })
									else
										game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_LIQUID_01.wav",
												"base:audio/gamemaster/DLG_GM_LIQUID_02.wav",
												"base:audio/gamemaster/DLG_GM_LIQUID_03.wav",
												"base:audio/gamemaster/DLG_GM_LIQUID_04.wav",
												"base:audio/gamemaster/DLG_GM_LIQUID_05.wav",}, priority = 2 })
									end
								end

							end

						end

					end

				end

				-- test if survivor is killed 

				if ((not device.owner.liquidator) and (0 == device.owner.data.heap.lifePoints)) then

					activity.timer = math.max(activity.timer - (activity.settings.timePenality * 1000000), 0)

				end

			elseif (device.owner.data.heap.lifePoints < lifePoints) then

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

		end

	end

end

function UALiquidator.State.RoundLoop:Update()

	UTActivity.State.RoundLoop.Update(self)

	-- end match if the liquidators are dead

	local finished = true
	for _, player in ipairs(activity.match.challengers[1].players) do
		if (player.data.heap.lifePoints > 0) then finished = false
		end
	end

	-- end match

	if (finished or (activity.timer <= 0)) then

		if (finished) then
		    activity.match.challengers[1].data.heap.score = 0
		    activity.match.challengers[2].data.heap.score = 1
			activity.gameoverSound = {"base:audio/gamemaster/DLG_GM_LIQUID_10.wav"}
		else
		    activity.match.challengers[1].data.heap.score = 1
		    activity.match.challengers[2].data.heap.score = 0
			activity.gameoverSound = {"base:audio/gamemaster/DLG_GM_LIQUID_08.wav"}
		end
		activity:PostStateChange("endround")

	end

end
