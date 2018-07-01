
--[[--------------------------------------------------------------------------
--
-- File:            UTTeam.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 2, 2010
--
------------------------------------------------------------------------------
--
-- Description:     Generic team, as a list of players (UTPlayer).
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTEntity"

--[[ Class -----------------------------------------------------------------]]

UTClass.UTTeam(UTEntity)

-- default

UTTeam.profiles = nil

-- __ctor --------------------------------------------------------------------

function UTTeam:__ctor(...)

	UTTeam.profiles = UTTeam.profiles or {

    [1] = { icon = "base:texture/ui/leaderboard_redteam.tga", name = l"oth033", teamColor = "red", color = { 0.85, 0.15, 0.04 } },
    [2] = { icon = "base:texture/ui/leaderboard_blueteam.tga", name = l"oth034", teamColor = "blue", color = { 0.05, 0.53, 0.84 } },
    [3] = { icon = "base:texture/ui/leaderboard_yellowteam.tga", name = l"oth035", teamColor = "yellow", color = { 0.95, 0.72, 0.00 } },
    [4] = { icon = "base:texture/ui/leaderboard_greenteam.tga", name = l"oth036", teamColor = "green", color = { 0.05, 0.64, 0.08 } },
    
    default = { icon = "base:texture/ui/leaderboard_redteam.tga", name = "UTTeam", teamColor = "red", color = { 0.85, 0.15, 0.04 } },
	}
    -- profile

    self.profile = UTTeam.profiles.default

    -- listof players within the team

    self.players = {}

end

-- __dtor --------------------------------------------------------------------

function UTTeam:__dtor()
end