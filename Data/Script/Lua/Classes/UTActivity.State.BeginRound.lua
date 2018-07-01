
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.State.BeginRound.lua
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

require "UTActivity.Ui.BeginRound"

--[[ Class -----------------------------------------------------------------]]

UTActivity.State.BeginRound = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTActivity.State.BeginRound:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UTActivity.State.BeginRound:Begin()

	-- here we must pop the countdown page from UIManager : no push is necessary because it's done in begin_match !!!

	UIManager.stack:Pop()
	
end

-- End -----------------------------------------------------------------------

function UTActivity.State.BeginRound:End()

    UIMenuManager.stack:Pop()

end
