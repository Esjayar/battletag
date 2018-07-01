
--[[--------------------------------------------------------------------------
--
-- File:            UEEngine.State.Running.lua
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

UEEngine.State.Running = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UEEngine.State.Running:__ctor (engine, ...)

    assert(engine)

end

-- Update --------------------------------------------------------------------

function UEEngine.State.Running:Update()

    -- update all registered libraries,
    -- each library is a process, with or without its own states

    for _, library in pairs(engine.libraries) do
        library:Update()
    end

end
