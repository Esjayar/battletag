
--[[--------------------------------------------------------------------------
--
-- File:            UAIntroduction.State.Title.lua
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

require "UAIntroduction.Ui.Title"

--[[ Class -----------------------------------------------------------------]]

UAIntroduction.State.Title = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UAIntroduction.State.Title:__ctor(activity, ...)

    assert(activity)

end

-- Begin ---------------------------------------------------------------------

function UAIntroduction.State.Title:Begin()

    -- ui

    UIMenuManager.stack:Push(UAIntroduction.Ui.Title)

    -- music
	engine.libraries.audio:Play("base:audio/musicintroduction.ogg",game.settings.audio["volume:music"])
	
    UTGame.State.Title.FirstTime = true

end

-- End -----------------------------------------------------------------------

function UAIntroduction.State.Title:End()

	UIMenuManager.stack:Pop() 

end
