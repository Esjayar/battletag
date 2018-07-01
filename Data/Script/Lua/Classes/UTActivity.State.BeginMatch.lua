
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.State.BeginMatch.lua
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

require "UTActivity.Ui.BeginMatch"

--[[ Class -----------------------------------------------------------------]]

UTActivity.State.BeginMatch = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTActivity.State.BeginMatch:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UTActivity.State.BeginMatch:Begin()

	if ((activity.category ~= UTActivity.categories.single) and activity.settings and (1 == activity.settings.gameLaunch)) then
		activity.countdownDuration = activity.countdownDuration * 0.5
	end


	UIManager.stack:Push(UTActivity.Ui.BeginMatch)
	
	game.gameMaster:Begin()
	
	game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_01.wav", "base:audio/gamemaster/DLG_GM_GLOBAL_02.wav"},
									probas = {0.9, 0.1}})
	
    for i = 1, activity.countdownDuration do
    
		if (13 - i >= 10) then
			game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_" ..  13 - i .. ".wav"}, offset = 0.8 + (activity.countdownDuration - i), })
		else
			game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_GLOBAL_0" ..  13 - i .. ".wav"}, offset = 0.8 + (activity.countdownDuration - i), })
		end
   
    end
 
end

-- End -----------------------------------------------------------------------

function UTActivity.State.BeginMatch:End()

	game.gameMaster:End()
	
end

-- Update --------------------------------------------------------------------

function UTActivity.State.BeginMatch:Update()
end
