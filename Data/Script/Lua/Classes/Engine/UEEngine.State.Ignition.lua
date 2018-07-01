
--[[--------------------------------------------------------------------------
--
-- File:            UEEngine.State.Ignition.lua
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

UEEngine.State.Ignition = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UEEngine.State.Ignition:__ctor (engine, ...)

    assert(engine)

end

-- Begin ---------------------------------------------------------------------

function UEEngine.State.Ignition:Begin()

    engine.libraries = {}

    engine.libraries.audio = ULAudio:New(engine)
    engine.libraries.drawing = ULDrawing:New(engine)
    engine.libraries.usb = ULUsb:New(engine)

end

-- End -----------------------------------------------------------------------

function UEEngine.State.Ignition:End()

    -- invoke the ignition event to notify every listener the engine is up and running

    engine:OnIgnitionComplete()

end

-- Update --------------------------------------------------------------------

function UEEngine.State.Ignition:Update()

    local opened = true

    -- loop through all registered libraries,
    -- open the libraries

    for _, library in pairs(engine.libraries) do

        opened = opened and (library.opened or library:Open())

        -- break the loop if a library cannot be opened,
        -- we do not yet handle any blocking error since ther should not be any ...

        if (not library.opened) then
            break
        end
    end

    -- when all libraries are opened,
    -- exit ignition state and run the engine forever ...

    if (opened) then
        self:PostStateChange("running")
    end

end
