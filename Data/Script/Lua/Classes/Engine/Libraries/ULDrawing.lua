
--[[--------------------------------------------------------------------------
--
-- File:            ULDrawing.lua
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

require "quartz.system.drawing"

--[[ Class -----------------------------------------------------------------]]

UTClass.ULDrawing(UELibrary)

-- defaults

ULDrawing.updateFrameRate = 30

-- __ctor --------------------------------------------------------------------

function ULDrawing:__ctor(engine, ...)
end

-- __dtor --------------------------------------------------------------------

function ULDrawing:__dtor()
end

-- Close ---------------------------------------------------------------------

function ULDrawing:Close()

    if (self.opened) then

        assert(self.module)
        assert(type(self.module) == "userdata")

        quartz.system.drawing.close(); self.module = nil

        UELibrary.Close(self)

    end

    return self.opened

end

-- Open ----------------------------------------------------------------------

function ULDrawing:Open()

    if (not self.opened) then
    
        self.module = quartz.system.drawing.open()

        if (self.module) then

            assert(self.module)
            assert(type(self.module) == "userdata")

            -- assume the library was opened

            UELibrary.Open(self)

        end
    end

    return self.opened

end
