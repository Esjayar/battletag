
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.State.Settings.lua
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

require "UTActivity.Ui.Settings"

--[[ Class -----------------------------------------------------------------]]

UTActivity.State.Settings = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTActivity.State.Settings:__ctor (activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UTActivity.State.Settings:Begin()

    -- ui

    UIMenuManager.stack:Push(UTActivity.Ui.Settings)

end

-- End -----------------------------------------------------------------------

function UTActivity.State.Settings:End()

	UIMenuManager.stack:Pop() 

end
