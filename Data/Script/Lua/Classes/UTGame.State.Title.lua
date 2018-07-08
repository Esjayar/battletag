
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.State.Title.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 20, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTGame.Ui.Title"

--[[ Class -----------------------------------------------------------------]]

UTGame.State.Title = UTClass(UTState)

UTGame.State.Title.FirstTime = true

-- __ctor --------------------------------------------------------------------

function UTGame.State.Title:__ctor (game, ...)

    assert(game)

end

-- Begin ---------------------------------------------------------------------

function UTGame.State.Title:Begin()
    
    print("UTGame.State.Title:Begin()")

    -- dependencies

	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		assert(proxy)
		assert(proxy.initialized)
		assert(not proxy.revisionUpdate)
	end

    UIManager.stack:Push(UTGame.Ui.Title)

    -- launch the music
    -- (done in ignition as well)

    if (REG_FIRSTTIME) then
        engine.libraries.audio:Play("base:audio/musicmenu.ogg",game.settings.audio["volume:music"])
	end

end

-- End -----------------------------------------------------------------------

function UTGame.State.Title:End()

    print("UTGame.State.Title:End()")
	if (UTGame.Ui.Title.hasPopup == true) then
	
		UTGame.Ui.Title.hasPopup = false
		UIManager.stack:Pop() 
		
	end 
	
    UIManager.stack:Pop()

end

-- Update --------------------------------------------------------------------

function UTGame.State.Title:Update()
end
