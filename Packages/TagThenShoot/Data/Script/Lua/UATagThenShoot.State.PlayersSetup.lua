
--[[--------------------------------------------------------------------------
--
-- File:            UATagThenShoot.State.PlayersSetup.lua
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
require "UATagThenShoot.Ui.PlayersSetup"

--[[ Class -----------------------------------------------------------------]]

UATagThenShoot.State.PlayersSetup = UTClass(UTActivity.State.PlayersSetup)

-- defaults

UATagThenShoot.State.PlayersSetup.uiClass = UATagThenShoot.Ui.PlayersSetup