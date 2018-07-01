
--[[--------------------------------------------------------------------------
--
-- File:            UAIntroduction.State.PlayersSetup.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 20, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UAIntroduction.State.PlayersSetup = UTClass(UTActivity.State.PlayersSetup)

-- defaults

-- __ctor --------------------------------------------------------------------

function UAIntroduction.State.PlayersSetup:__ctor(activity, ...)

    assert(activity)

    -- skip the player setup ui,
    -- we have no configuration data & nothing else to check or synch.

    self.silent = true

end

-- Begin ---------------------------------------------------------------------

function UAIntroduction.State.PlayersSetup:Begin()

    -- call base class for base setup,
    -- then begin the match

    UTActivity.State.PlayersSetup.Begin(self)
    self:PostStateChange("roundloop")

end