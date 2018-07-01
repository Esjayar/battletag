
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.State.Revision.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 13, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTGame.Ui.Revision"

--[[ Class -----------------------------------------------------------------]]

UTGame.State.Revision = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTGame.State.Revision:__ctor (game, ...)

    assert(game)

end

-- Begin ---------------------------------------------------------------------

function UTGame.State.Revision:Begin()

    assert(engine.libraries.usb)
    assert(engine.libraries.usb.proxy)
    assert(engine.libraries.usb.proxy.revisionUpdate)
    assert(not engine.libraries.usb.proxy.initialized)

    print("UTGame.State.Revision:Begin()")

    UIManager.stack:Pusha()
    UIMenuManager.stack:Pusha()

    UIMenuManager.stack:Push(UTGame.Ui.Revision)

    -- wait for process completion ...

    engine.libraries.usb.proxy:PostStateChange("upload")

end

-- End -----------------------------------------------------------------------

function UTGame.State.Revision:End()

    print("UTGame.State.Revision:End()")

    self.uiPopup = nil

    UIMenuManager.stack:Popa()
    UIManager.stack:Popa()

end

-- Update --------------------------------------------------------------------

function UTGame.State.Revision:Update()

    if (engine.libraries.usb.proxy and engine.libraries.usb.proxy.revisionCandidate) then

        -- notification when the upload is complete

        if (engine.libraries.usb.proxy.revisionCandidate.checked == engine.libraries.usb.proxy.revisionUpdate) then

            if (not self.uiPopup) then

                self.uiPopup = UIPopupWindow:New()

                self.uiPopup.title = l "con041"
                self.uiPopup.text = l "con042"

                UIManager.stack:Push(self.uiPopup)
                game.gameMaster:Play("base:audio/gamemaster/dlg_gm_init_03.wav")

            end
        end
    end

end