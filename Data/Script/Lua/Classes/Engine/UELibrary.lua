
--[[--------------------------------------------------------------------------
--
-- File:            UELibrary.lua
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

--[[ Class -----------------------------------------------------------------]]

UTClass.UELibrary(UTProcess)

UELibrary.__libraries = {}

-- defaults

-- __ctor --------------------------------------------------------------------

function UELibrary:__ctor(engine, ...)

    for _, library in pairs(UELibrary.__libraries) do
        assert(library ~= self)
    end

    table.insert(UELibrary.__libraries, self)

    assert(engine)

    self.engine = engine
    self.opened = false

    -- events

    self._Closed = UTEvent:New()
    self._Opened = UTEvent:New()

end

-- __dtor --------------------------------------------------------------------

function UELibrary:__dtor()

    local removed = nil

    for index, library in pairs(UELibrary.__libraries) do
        if (library == self) then
            removed = table.remove(UELibrary.__libraries, index)
        end
    end

    assert(removed)

    -- close the library

    if (self.opened) then
        self:Close()
    end

end

-- Close ---------------------------------------------------------------------

function UELibrary:Close()

    if (self.opened) then
    
        self._Closed:Invoke(self)
        self.opened = false
    
    end

end

-- Open ----------------------------------------------------------------------

function UELibrary:Open()

    if (not self.opened) then

        self.opened = true
        self._Opened:Invoke(self)

    end

    return self.opened

end