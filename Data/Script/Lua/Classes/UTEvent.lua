
--[[--------------------------------------------------------------------------
--
-- File:            UTEvent.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            Mai 25, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UTEvent()

-- __ctor --------------------------------------------------------------------

function UTEvent:__ctor(...)

	self.delegates = {}

end

-- Add -----------------------------------------------------------------------

function UTEvent:Add(_self, _function, _priority)

    if (type(_self) == "function") then

        _priority = _function
        _function = _self
        _self = nil

        assert(type(_function) == "function", "[UTEvent] Add(_function[, priority]): '_function' argument should be of type 'function'")

    else

        assert(type(_self) == "table", "[UTEvent] Add(_self, _function[, priority]): '_self' argument should be of type 'table'")
        assert(type(_function) == "function", "[UTEvent] Add(_self, _function[, priority]): '_function' argument should be of type 'function'")

    end

    if (not priority == nil) then
        assert(type(priority) == "number", "[UTEvent] Add([_self,] _function, priority]): '_priority' argument should be of type 'number'")
    end

	if (_function and type(_function) == "function") then

        -- check whether the delegate was already registered,
        -- most of the time it is a mistake because the code was pasted twice

        for _, delegate in pairs(self.delegates) do
            if (delegate.__function == _function and delegate.__self == _self) then
                print("## delegate was already registered, consider removing the delegate ##")
                return
            end
        end

		local delegate = {
		
			__function = _function,
			__priority = (type(_priority) == "number") and _priority or 1,
			__self = _self,
		}

		table.insert(self.delegates, delegate)

		-- sort by prioriry

		table.sort(self.delegates, function (left, right) return (left and right and (left.__priority < right.__priority)) or false end)

        return delegate

	end

end

-- Invoke --------------------------------------------------------------------

function UTEvent:Invoke(...)

	for i, delegate in pairs(self.delegates) do

		if (delegate.__self) then
			delegate.__function(delegate.__self, ...)
		else
			delegate.__function(...)
		end
	end

end

-- Remove --------------------------------------------------------------------

function UTEvent:Remove(_self, _function)

    if (_self and _function) then
    
	    for i, delegate in pairs(self.delegates) do
		    if (delegate.__self == _self and delegate.__function == _function) then
			    return table.remove(self.delegates, i)
		    end
	    end

        error("[UTEvent] Remove(_self, _function): unable to locate delegate for removal")

	elseif (_self) then

        if (type(_self) == "table") then

	        for i, delegate in pairs(self.delegates) do
	            if (delegate == _self) then
	                return table.remove(self.delegates, i)
	            end
	        end
	        
	        error("[UTEvent] Remove(_delegate): unable to locate delegate for removal")
	        
        elseif (type(self) == "function") then
        
            _self, _function = nil, _self

	        for i, delegate in pairs(self.delegates) do
		        if (delegate.__self == _self and delegate.__function == _function) then
			        return table.remove(self.delegates, i)
		        end
	        end

	        error("[UTEvent] Remove(_function): unable to locate delegate for removal")
	        
	    end
	end

    error("[UTEvent] Remove: wrong usage - call either Remove(_delegate) or Remove([_self,] _function)")

end
