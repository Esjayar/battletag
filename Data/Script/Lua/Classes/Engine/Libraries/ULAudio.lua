
--[[--------------------------------------------------------------------------
--
-- File:            ULAudio.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            June 7, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "quartz.framework.audio"

--[[ Class -----------------------------------------------------------------]]

UTClass.ULAudio(UELibrary)

-- defaults

ULAudio.updateFrameRate = 30

-- __ctor --------------------------------------------------------------------

function ULAudio:__ctor(engine, ...)
end

-- __dtor --------------------------------------------------------------------

function ULAudio:__dtor()
end

-- Close ---------------------------------------------------------------------

function ULAudio:Close()

    if (self.opened) then

        assert(self.module)
        assert(type(self.module) == "userdata")

        quartz.framework.audio.close(); self.module = nil

        UELibrary.Close(self)

    end

    return self.opened

end

-- Open ----------------------------------------------------------------------

function ULAudio:Open()

    if (not self.opened) then
    
        self.module = quartz.framework.audio.open()

        if (self.module) then

            assert(self.module)
            assert(type(self.module) == "userdata")

            -- assume the library was opened

            UELibrary.Open(self)

        end
    end

    return self.opened

end

-- Open ----------------------------------------------------------------------

function ULAudio:Play(id, volume)

    if (id and (id ~= self.backgroundMusic)) then

        self:Stop()

        self.backgroundMusic = id

        quartz.framework.audio.loadmusic(self.backgroundMusic)
		quartz.framework.audio.loadvolume(volume or 1.0)
		quartz.framework.audio.playmusic()

    end

end

-- Open ----------------------------------------------------------------------

function ULAudio:Stop()

    if (self.backgroundMusic) then

        quartz.framework.audio.loadmusic(self.backgroundMusic)
        quartz.framework.audio.stopmusic()
        self.backgroundMusic = nil

    end

end