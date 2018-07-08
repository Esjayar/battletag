
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
	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		assert(proxy)
		assert(proxy.revisionUpdate)
		assert(not proxy.initialized)
	end

    print("UTGame.State.Revision:Begin()")

    UIManager.stack:Pusha()
    UIMenuManager.stack:Pusha()

    UIMenuManager.stack:Push(UTGame.Ui.Revision)

    -- wait for process completion ...

    for index, proxy in ipairs(engine.libraries.usb.proxies) do
		proxy:PostStateChange("upload")
	end

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

    for index, proxy in ipairs(engine.libraries.usb.proxies) do
		if (proxy and proxy.revisionCandidate) then

			-- notification when the upload is complete

			if (proxy.revisionCandidate.checked == proxy.revisionUpdate) then

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

end