
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.State.Basics.lua
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

require "UTGame.Ui.Basics"

--[[ Class -----------------------------------------------------------------]]

UTGame.State.Basics = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTGame.State.Basics:__ctor (game, ...)

    assert(game)

end

-- Begin ---------------------------------------------------------------------

function UTGame.State.Basics:Begin()

    print("UTGame.State.Basics:Begin()")

    UIMenuManager.stack:Push(UTGame.Ui.Basics)

    -- display the connection completion status,
    -- check whether the proxy's firmware revision is up to date

end

-- End -----------------------------------------------------------------------

function UTGame.State.Basics:End()

    print("UTGame.State.Basics:End()")

    UIMenuManager.stack:Pop()

end