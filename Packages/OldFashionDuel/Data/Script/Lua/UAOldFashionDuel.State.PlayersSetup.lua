
--[[--------------------------------------------------------------------------
--
-- File:            UAOldFashionDuel.State.PlayersSetup.lua
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
require "UAOldFashionDuel.Ui.PlayersSetup"

--[[ Class -----------------------------------------------------------------]]

UAOldFashionDuel.State.PlayersSetup = UTClass(UTActivity.State.PlayersSetup)

-- defaults ------------------------------------------------------------------

UAOldFashionDuel.State.PlayersSetup.uiClass = UAOldFashionDuel.Ui.PlayersSetup
