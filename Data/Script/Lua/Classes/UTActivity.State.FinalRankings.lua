
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.State.FinalRankings.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 28, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.Ui.FinalRankings"

--[[ Class -----------------------------------------------------------------]]

UTActivity.State.FinalRankings = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTActivity.State.FinalRankings:__ctor(activity, ...)

    assert(activity)
    
end

UTActivity.State.FinalRankings.TeamColor = 
{
	["red"] = "DLG_GM_FRAG_TEAM_05.wav",
	["blue"] = "DLG_GM_FRAG_TEAM_06.wav",
	["yellow"] = "DLG_GM_FRAG_TEAM_07.wav",
	["green"] = "DLG_GM_FRAG_TEAM_08.wav",	
}

-- Begin ---------------------------------------------------------------------

function UTActivity.State.FinalRankings:Begin()

	-- empty all activity matches
	local score = -1000
	local offsetTime = 2

	game.gameMaster:Begin()
	
	local oneWinner = game.gameMaster:RegisterSound({paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_53.wav"},})
	
	if (0 < #activity.teams) then
		
		for i, team in ipairs(activity.teams) do
			
			if (team.data.baked.score >= score) then
			
				if (score ~= -1000 and oneWinner ~= nil) then
				
					game.gameMaster:UnRegisterSound(oneWinner)				
					game.gameMaster:RegisterSound({paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_54.wav"}})
					oneWinner = nil
					
				end 
				
				game.gameMaster:RegisterSound({paths = {"base:audio/gamemaster/" .. UTActivity.State.FinalRankings.TeamColor[team.profile.teamColor]}, offset = offsetTime})
				offsetTime = offsetTime + 1.5
				score = team.data.baked.score;
			else
				break
			end
			
		end

	else
		for i, player in ipairs(activity.players) do

			if (player.data.baked.score >= score) then
			
				if (score ~= -1000 and oneWinner ~= nil) then
				
					game.gameMaster:UnRegisterSound(oneWinner)				
					game.gameMaster:RegisterSound({paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_54.wav"}})
					oneWinner = nil
					
				end 
				
				if (player.rfGunDevice) then
					game.gameMaster:RegisterSound({paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_" ..(96 + player.rfGunDevice.classId) .. ".wav"}, offset = offsetTime})
				end
				offsetTime = offsetTime + 1.5
				score = player.data.baked.score;
			else
				break
			end
		end
	end
			
	-- pop end match / gameover ui

	UIManager.stack:Pop()	

	-- no matches anymore 
	
	activity.matches = nil

	-- can leave ...

    self.timer = quartz.system.time.gettimemicroseconds()
	for _, player in ipairs(activity.players) do
		if (player.rfGunDevice) then player.rfGunDevice.acknowledge = false
		end
	end
	self.isReady = false
	
	-- respond to proxy message

	engine.libraries.usb.proxy._DispatchMessage:Add(self, UTActivity.State.FinalRankings.OnDispatchMessage)	
	
end

-- End -----------------------------------------------------------------------

function UTActivity.State.FinalRankings:End()

	game.gameMaster:End()	

	UIMenuManager.stack:Pop() 


    if (engine.libraries.usb.proxy) then

	-- no longer respond to proxy message

		engine.libraries.usb.proxy._DispatchMessage:Remove(self, UTActivity.State.FinalRankings.OnDispatchMessage)
			
	end

end

-- OnDispatchMessage ---------------------------------------------------------

function UTActivity.State.FinalRankings:OnDispatchMessage(device, addressee, command, arg)

	-- acknowledge answers 

	if (0x94 == command) then
		if (device and not device.acknowledge) then device.acknowledge = true
		end
	end

end

-- Update --------------------------------------------------------------------

function UTActivity.State.FinalRankings:Update()

	local elapsedTime = quartz.system.time.gettimemicroseconds() - (self.time or quartz.system.time.gettimemicroseconds())
	self.time = quartz.system.time.gettimemicroseconds()
	
	self.msgTimer = (self.msgTimer or 0) + elapsedTime
	if (not self.isReady and (self.msgTimer > 250000)) then

		-- gameover msg

		self.msgTimer = 0
		self.isReady = true
		for _, player in ipairs(activity.players) do

			if (player.rfGunDevice and not (player.rfGunDevice.acknowledge)) then

				local msg = { 0x06, player.rfGunDevice.radioProtocolId, 0x94, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 }
				quartz.system.usb.sendmessage(engine.libraries.usb.proxy.handle, msg)
				self.isReady = false

			end

		end

	end

end
