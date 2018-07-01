
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.State.Video.lua
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

require "UTGame.Ui.Video"

--[[ Class -----------------------------------------------------------------]]

UTGame.State.Video = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTGame.State.Video:__ctor (game, ...)

    assert(game)

end

-- Begin ---------------------------------------------------------------------

function UTGame.State.Video:Begin()

    print("UTGame.State.Video:Begin()")
    UIManager.stack:Pusha()
    
    if (quartz.system.drawing.loadvideo("base:video/ubisoft.avi")) then

        quartz.system.drawing.playvideo()
        -- game.gameMaster:Play("base:audio/ubisoft.wav")

        UIManager.stack:Push(UTGame.Ui.Video)

    else

        self:PostStateChange("connection")

    end

end

-- End -----------------------------------------------------------------------

function UTGame.State.Video:End()

    print("UTGame.State.Video:End()")

    UIManager.stack:Popa()

    -- launch the music
    -- (done in title as well)

    if (UTGame.State.Title.FirstTime) then

        engine.libraries.audio:Play("base:audio/musicmenu.ogg",game.settings.audio["volume:music"])
		UTGame.State.Title.FirstTime = false

	end

end

-- Update --------------------------------------------------------------------

function UTGame.State.Video:Update()
    
    quartz.system.drawing.loadvideo("base:video/Ubisoft.avi")    
    if (quartz.system.drawing.getvideostatus() == quartz.system.drawing.videostatus.stopped) then
        self:PostStateChange("connection")
    end

end
