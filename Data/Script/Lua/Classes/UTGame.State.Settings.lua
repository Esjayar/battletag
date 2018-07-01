
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.State.Settings.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 2, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTGame.Ui.Settings"

--[[ Class -----------------------------------------------------------------]]

UTGame.State.Settings = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTGame.State.Settings:__ctor (game, ...)

    assert(game)

end

-- Begin ---------------------------------------------------------------------

function UTGame.State.Settings:Begin()

    print("UTGame.State.Settings:Begin()")

    UIMenuManager.stack:Push(UTGame.Ui.Settings)

    -- display the connection completion status,
    -- check whether the proxy's firmware revision is up to date

end

-- End -----------------------------------------------------------------------

function UTGame.State.Settings:End()

    print("UTGame.State.Settings:End()")

    UIMenuManager.stack:Pop()

end