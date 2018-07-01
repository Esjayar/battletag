
--[[--------------------------------------------------------------------------
--
-- File:            UEEngine.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            June 4, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

engine = nil

--[[ Dependencies ----------------------------------------------------------]]

require "Engine/UELibrary"

-- libraries

require "Engine/Libraries/ULAudio"
require "Engine/Libraries/ULDrawing"
require "Engine/Libraries/ULUsb"
require "Engine/Libraries/ULTracking"

--[[ Class -----------------------------------------------------------------]]

UTClass.UEEngine(UTStateMachine)

-- state dependencies

UEEngine.State = {}

    require "Engine/UEEngine.State.Ignition"
    require "Engine/UEEngine.State.Running"

-- __ctor --------------------------------------------------------------------

function UEEngine:__ctor(...)

    -- states

    self.states = {}

    self.states["ignition"] = UEEngine.State.Ignition:New(self)
    self.states["running"] = UEEngine.State.Running:New(self)

    self.default = "ignition"

    self:Restart()

    -- libraries
    
    self.libraries = {}
    
	-- events

	self._IgnitionComplete = UTEvent:New()
	self._Shutdown = UTEvent:New()

    assert(not engine); engine = self

end

-- __dtor --------------------------------------------------------------------

function UEEngine:__dtor()

    self:OnShutdown()

    for _, library in pairs(self.libraries) do

        library:Close()
        library:Delete()

    end

    self.libraries = nil

    assert(engine == self); engine = nil

end

-- OnStartupComplete ---------------------------------------------------------

function UEEngine:OnIgnitionComplete()

    print("UEEngine:OnIgnitionComplete()")
    self._IgnitionComplete:Invoke(self)

end

-- OnShutdown ----------------------------------------------------------------

function UEEngine:OnShutdown()

    self._Shutdown:Invoke()

end