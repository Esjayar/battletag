
--[[--------------------------------------------------------------------------
--
-- File:            UAIntroduction.State.Ui.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 16, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UAIntroduction.State.Ui = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UAIntroduction.State.Ui:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UAIntroduction.State.Ui:Begin(arg)

    self.arg = arg and arg[1]

    UIManager.stack:Pusha()
    UIMenuManager.stack:Pusha()

    print("UAIntroduction.State.Ui:Begin", arg, arg[1])

    if (self.arg) then
        UIMenuManager.stack:Push(self.arg)
    end

end

-- End -----------------------------------------------------------------------

function UAIntroduction.State.Ui:End()

    print("UAIntroduction.State.Ui:End")

    UIManager.stack:Popa()
    UIMenuManager.stack:Popa()

end
