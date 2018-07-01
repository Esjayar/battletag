
--[[--------------------------------------------------------------------------
--
-- File:            UTProcess.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            Mai 26, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTStateMachine"

--[[ Class -----------------------------------------------------------------]]

UTClass.UTProcess(UTStateMachine)

-- declarations

UTProcess.Ready = "Ready"
UTProcess.Suspended = "Suspended"

UTProcess.__processes = {}

-- defaults

UTProcess.updateFrameRate = 10
UTProcess.startSuspended = false

-- __ctor --------------------------------------------------------------------

function UTProcess:__ctor(...)

	self:SetUpdateFrameRate(self.updateFrameRate)

	-- events

	self._Resumed = UTEvent:New()
	self._Suspended = UTEvent:New()
	self._Update = UTEvent:New()

    -- register to listof processes

    table.insert(UTProcess.__processes, self)

    --

    if (not self.startSuspended) then
        self:Resume()
    end

end

-- __dtor --------------------------------------------------------------------

function UTProcess:__dtor()

    -- unregister from listof processes
    
    for index, process in ipairs(UTProcess.__processes) do

        if (process == self) then
            table.remove(UTProcess.__processes, index)
            break
        end
    end

end

-- OnResumed -----------------------------------------------------------------

function UTProcess:OnResumed()

    self._Resumed:Invoke(self)

end

-- OnSuspended ---------------------------------------------------------------

function UTProcess:OnSuspended()

    self._Suspended:Invoke(self)

end

-- OnUpdate ------------------------------------------------------------------

function UTProcess:OnUpdate()

    UTStateMachine.Update(self)
    self._Update:Invoke(self)

end

-- Resume --------------------------------------------------------------------

function UTProcess:Resume()

    if (self.status ~= UTProcess.Ready) then

        self.accumulator = 0
        self.time = quartz.system.time and quartz.system.time.gettimemicroseconds() or nil

	    self.status = UTProcess.Ready

        self:OnResumed()

    end
end

-- SetUpdateFrameRate --------------------------------------------------------

function UTProcess:SetUpdateFrameRate(updateFrameRate)

    if ((type(updateFrameRate) == "number") and (0 < updateFrameRate)) then
    
        self.updateFramerate = updateFrameRate
        self.updateFramerateMicroSeconds = 1000000.0 / self.updateFramerate
        
    else
    
        self.updateFramerate, self.updateFramerateMicroSeconds = nil, nil
        
    end

end

-- Suspend -------------------------------------------------------------------

function UTProcess:Suspend()

    if (self.status ~= UTProcess.Suspended) then

	    self.status = UTProcess.Suspended
        self:OnSuspended()

    end
end

-- Update --------------------------------------------------------------------

function UTProcess:Update()

    if (self.updateFramerate and (0 < self.updateFramerate)) then

        local time = quartz.system.time.gettimemicroseconds()
        local elapsedTime = time - (self.time or quartz.system.time.gettimemicroseconds())

        self.accumulator = self.accumulator + elapsedTime
        self.time = time

        while (self.updateFramerateMicroSeconds <= self.accumulator) do

            self.accumulator = self.accumulator - self.updateFramerateMicroSeconds
            self:OnUpdate()

        end

    else

        self:OnUpdate()

    end

end