
--[[--------------------------------------------------------------------------
--
-- File:            UAInfection.State.RoundLoop.lua
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
require "UAInfection.Ui.RoundLoop"

--[[ Class -----------------------------------------------------------------]]

UAInfection.State.RoundLoop = UTClass(UTActivity.State.RoundLoop)

-- defaults ------------------------------------------------------------------

UAInfection.State.RoundLoop.uiClass = UAInfection.Ui.RoundLoop

-- __ctor --------------------------------------------------------------------

function UAInfection.State.RoundLoop:__ctor(activity, ...)

    -- timer

    self.time = quartz.system.time.gettimemicroseconds()
    activity.timer = 0
    
    assert(activity)
	
end

-- Begin ---------------------------------------------------------------------

function UAInfection.State.RoundLoop:Begin()

	UTActivity.State.RoundLoop.Begin(self)

	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_WOLF_01_alt.wav",
											"base:audio/gamemaster/DLG_GM_INFECT_01.wav",}, priority = 4 })

	if (activity.settings.playtime >= 2) then
		game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_45.wav"},offset = activity.settings.playtime * 60 - 60,})
	end
						 
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

	-- random wolf 

	self.list  = {}
	for i, player in ipairs(activity.match.players) do
		player.zombie = nil
		table.insert(self.list, math.random(i), player)
	end
	for i = 1, activity.settings.nbzombies do
		self.list[i].zombie = true
		self.list[i].gameplayData[2] = 1
		activity.uiAFP:PushLine(self.list[i].profile.name .. " " .. l"ingame067", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Infection.tga")
	end
	activity.gameplayData = { 0x00, 0x00 }
	self.wolfTime = quartz.system.time.gettimemicroseconds()
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_INFECT_02.wav"}, priority = 1 })
	game.gameplayData = { 0x00, 0x00, 0x00, 0x00 }
	
	-- player alive

	self.nbPlayerAlive = #activity.players	
end

-- Message received from device  -----------------------------------------------------------------------

function UAInfection.State.RoundLoop:OnDispatchMessage(device, addressee, command, arg)

	-- base

	UTActivity.State.RoundLoop.OnDispatchMessage(self)

	if (0x95 == command) then

		-- decode this msg !!

		if (device.owner) then

			-- nb hit
		
			local nbHit = (arg[2] * 256) + arg[3]
			if (nbHit == 0) then
				device.owner.data.heap.nbHitbackup = device.owner.data.heap.nbHit
			end

			if (nbHit + device.owner.data.heap.nbHitbackup > device.owner.data.heap.nbHit) then

				-- set new zombie
				local curIndex = math.max(0, nbHit + device.owner.data.heap.nbHitbackup - device.owner.data.heap.nbHit)
				while (curIndex > 0 ) do
					local shooter = activity.players[arg[math.min(12, curIndex + 7)] - 1]
					local shooterDevice = shooter.rfGunDevice
					curIndex = curIndex - 1
					if (shooterDevice and shooterDevice.owner) then
						-- get shooter
						local shooter = shooterDevice.owner
						if (shooter.gameplayData[2] == 1 and device.owner.gameplayData[2] == 0) then
							device.owner.gameplayData[2] = 1
							device.owner.zombie = true
							device.owner.wolfTimer = 0
							local bonus = (arg[6] * 256) + arg[7]
							activity.gameplayData[2] = bonus
							activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame067", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/Infection.tga")
							game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_INFECT_02.wav"}, priority = 1 })
						end
					end
				end
				device.owner.data.heap.nbHit = nbHit + device.owner.data.heap.nbHitbackup
				
				-- check end of game
				self.nbPlayerAlive = self.nbPlayerAlive - 1
				if (self.nbPlayerAlive <= 1) then
					device.owner.data.heap.score = 75
					activity:PostStateChange("endround")
				end
			else

				-- scoring
			
				local last_rfid = (arg[4] * 256) + arg[5]

				if (last_rfid ~= device.owner.data.heap.last_rfid) then

					-- inc score

					local score = (arg[6] * 256) + arg[7]
					
					if (score ~= 0) then

						device.owner.data.heap.score = device.owner.data.heap.score + score
						activity.uiAFP:PushLine(device.owner.profile.name .. " " .. l"ingame034" .. " " .. score .. " " .. l"oth069", UIComponent.colors.gray, "base:texture/Ui/Icons/16x/hit.tga")
					end
						device.owner.data.heap.last_rfid = last_rfid

				end

			end

		end

	end

end

-- Update ---------------------------------------------------------------------

function UAInfection.State.RoundLoop:Update()

	UTActivity.State.RoundLoop.Update(self)

	-- end match

	if (activity.timer <= 0) then
		activity:PostStateChange("endround")
	end

	-- timer

    local wolfElapsedTime = quartz.system.time.gettimemicroseconds() - self.wolfTime
    self.wolfTime = quartz.system.time.gettimemicroseconds()
    
	for i, player in ipairs(activity.match.players) do
		if (player.zombie) then
			local newTimer = (player.wolfTimer or 0) + wolfElapsedTime
			if (player.rfGunDevice) then
				local checkTimer = {10, 5, 20}
				local index = 2
				if (newTimer > 7 * 1000000) then index = 1
				end
				if (newTimer > 15 * 1000000) then index = 3
				end
				local playerId = 2 + player.rfGunDevice.classId 
				if (newTimer > checkTimer[index] * 1000000 and player.wolfTimer < checkTimer[index] * 1000000) then
					--game.gameMaster:RegisterSound({paths = {"base:audio/gamemaster/DLG_GM_INFECT_0" .. playerId .. ".wav"}, priority = 0 })
					--game.gameMaster:RegisterSound({paths = {"base:audio/gamemaster/DLG_GM_INFECT_1" .. index .. ".wav"}, priority = 1})
				end
			end
			player.wolfTimer = newTimer
		end
	end

end