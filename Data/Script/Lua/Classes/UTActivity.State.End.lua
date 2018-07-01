
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.State.End.lua
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

--[[ Class -----------------------------------------------------------------]]

UTActivity.State.End = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTActivity.State.End:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UTActivity.State.End:Begin()

    -- !! CLEAR ALL TABLES: ENTITIES, MATCHES...
    -- !! RELEASE ALL RESOURCES: LOCALIZATION, SCRIPTS, BITMAPS

	game.gameMaster:End() -- for secure
	
    self:PostStateChange()

end

-- End -----------------------------------------------------------------------

function UTActivity.State.End:End()
end
