
--[[--------------------------------------------------------------------------
--
-- File:            UTProcessManager.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 7, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UTProcessManager()

-- __ctor --------------------------------------------------------------------

function UTProcessManager:__ctor(...)

    -- list of registered processes

    self.processes = {}

    -- list of active processes,
    -- that are 'ready'

    self.activeProcesses = {}

end

-- __dtor --------------------------------------------------------------------

function UTProcessManager:__dtor()
end

-- Add -----------------------------------------------------------------------

function UTProcessManager:Add(process)

    local registered = false
    table.foreach(self.processes, function (_, _process) if (process == _process) then registered = true end end)

    if (not registered) then

        table.insert(self.processes, process)

	    process._Resumed:Add(self, UTProcessManager.ProcessResumed)
	    process._Suspended:Add(self, UTProcessManager.ProcessSuspended)

    end

    return true

end

-- ProcessResumed ------------------------------------------------------------

function UTProcessManager:ProcessResumed(process)

    -- check whether the process was already registered in active list,
    -- that must not happen

    local registered = false
    table.foreach(self.activeProcesses, function (_, _process) if (process == _process) then registered = true end end)
    assert(not registered)

    -- maybe some processes should be updated before some other,
    -- attempt to sort the processes by priority

    local function sort(left, right)

        local leftPriority = (type(left.priority) == "number") and left.priority or 1
        local rightPriority = (type(left.priority) == "number") and left.priority or 1

        return leftPriority <= rightPriority

    end

    table.insert(self.activeProcesses, process)
    table.sort(self.activeProcesses, sort)

end

-- ProcessSuspended ----------------------------------------------------------

function UTProcessManager:ProcessSuspended(process)

    local index = nil
    table.foreach(self.activeProcesses, function (_index, _process) if (process == _process) then index = _index end end)

    if (index) then

        table.remove(self.activeProcesses, index)

    end

end

-- Remove --------------------------------------------------------------------

function UTProcessManager:Remove(process)

    local index = nil
    table.foreach(self.processes, function (_index, _process) if (process == _process) then index = _index end end)

    if (index) then

	    process._Resumed:Remove(self, UTProcessManager.ProcessResumed)
	    process._Suspended:Remove(self, UTProcessManager.ProcessSuspended)

    end

end

-- Update --------------------------------------------------------------------

function UTProcessManager:Update()

    table.foreach(self.activeProcesses, function (_, _process) _process:Update() end)

end