
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.State.Title.lua
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

require "UTActivity.Ui.Title"

--[[ Class -----------------------------------------------------------------]]

UTActivity.State.Title = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTActivity.State.Title:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UTActivity.State.Title:Begin()

    -- ui

    UIMenuManager.stack:Push(UTActivity.Ui.Title)

end

-- End -----------------------------------------------------------------------

function UTActivity.State.Title:End()

	UIMenuManager.stack:Pop() 

end
