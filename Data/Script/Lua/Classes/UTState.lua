
--[[--------------------------------------------------------------------------
--
-- File:            UTState.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:			Ubitoys.Tag
-- Date:            Mai 26, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UTState()

-- __ctor --------------------------------------------------------------------

function UTState:__ctor(...)

	self.state = UTState.Begin
	self.transition = nil

end

-- Begin ---------------------------------------------------------------------

function UTState:Begin()
end

-- End -----------------------------------------------------------------------

function UTState:End(abort)
end

UTState.Ended = UTState.Begin

-- PostStateChange -----------------------------------------------------------

function UTState:PostStateChange(transition, ...)

	self.transition = { transition or "nil", { ... }}

end

-- Reset ---------------------------------------------------------------------

function UTState:Reset()

	self.state = UTState.Begin
	self.transition = nil

end

-- Update --------------------------------------------------------------------

function UTState:Update()
end
