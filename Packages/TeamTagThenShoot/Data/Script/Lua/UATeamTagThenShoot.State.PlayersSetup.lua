
--[[--------------------------------------------------------------------------
--
-- File:            UATeamTagThenShoot.State.PlayersSetup.lua
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

require "UTActivity.State.PlayersSetup"
require "UATeamTagThenShoot.Ui.PlayersSetup"

--[[ Class -----------------------------------------------------------------]]

UATeamTagThenShoot.State.PlayersSetup = UTClass(UTActivity.State.PlayersSetup)

-- defaults

UATeamTagThenShoot.State.PlayersSetup.uiClass = UATeamTagThenShoot.Ui.PlayersSetup