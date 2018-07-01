
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.State.EndRound.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 28, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.Ui.EndRound"

--[[ Class -----------------------------------------------------------------]]

UTActivity.State.EndRound = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTActivity.State.EndRound:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UTActivity.State.EndRound:Begin()
end

-- End -----------------------------------------------------------------------

function UTActivity.State.EndRound:End()
end

-- Update --------------------------------------------------------------------

function UTActivity.State.EndRound:Update()

	activity:PostStateChange("endmatch")

end