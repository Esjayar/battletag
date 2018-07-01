
--[[--------------------------------------------------------------------------
--
-- File:            UAIntroduction.State.PlayersManagement.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 17, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UAIntroduction.Ui.PlayersManagement"

--[[ Class -----------------------------------------------------------------]]

UAIntroduction.State.PlayersManagement = UTClass(UTActivity.State.PlayersManagement)

-- defaults

UAIntroduction.State.PlayersManagement.uiClass = UAIntroduction.Ui.PlayersManagement

-- __ctor --------------------------------------------------------------------

function UAIntroduction.State.PlayersManagement:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UAIntroduction.State.PlayersManagement:Begin()

    UTActivity.State.PlayersManagement.Begin(self)

end

-- End -----------------------------------------------------------------------

function UAIntroduction.State.PlayersManagement:End()

	UTActivity.State.PlayersManagement.End(self)

	-- stop pairing

    if (engine.libraries.usb.proxy) then

        assert(engine.libraries.usb.proxy.handle)
        quartz.system.usb.sendmessage(engine.libraries.usb.proxy.handle, { 0x01, 0x00, 0x13, 0x00 })
    
    end

end
