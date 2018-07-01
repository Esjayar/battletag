
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.State.Playground.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 26, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.Ui.Playground"

--[[ Class -----------------------------------------------------------------]]

UTActivity.State.Playground = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTActivity.State.Playground:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UTActivity.State.Playground:Begin()

    -- ui

    UIMenuManager.stack:Push(UTActivity.Ui.Playground)

end

-- End -----------------------------------------------------------------------

function UTActivity.State.Playground:End()

	UIMenuManager.stack:Pop() 

end

-- Update --------------------------------------------------------------------

function UTActivity.State.Playground:Update()
end
