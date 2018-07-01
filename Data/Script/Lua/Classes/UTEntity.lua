
--[[--------------------------------------------------------------------------
--
-- File:            UTEntity.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 2, 2010
--
------------------------------------------------------------------------------
--
-- Description:     An entity represents either a player (UTPlayer) or a team
--                  of players (UTTeam).
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UTEntity()

-- __ctor --------------------------------------------------------------------

function UTEntity:__ctor(...)

    -- profile

    -- the profile contains personal information about the entity

    self.profile = { color = { 1.0, 1.0, 1.0 }, icon = nil, name = "UTEntity", }

	-- data

	self.data = {

	    -- heap data are intermediate ones,
	    -- they live throughout the duration of a single match (cf. "matchmaking"),
	    -- they are initialized each time when a new match is begun (cf. "beginmatch")

	    heap = {},

	    -- baked data are backed up/ cumulated from multiple matches,
	    -- they are persistent throughout the duration of the whole session (cf. "matchmaking"),
	    -- heap data are backed up each time when a match is ended (cf. "endmatch")

	    baked = {},
	}

    -- add a metatable to the heap data,
    -- so as to know it when a single data changes

	local metatable = {}

	metatable.__index = metatable -- still index keys from metatable itself
	metatable.__newindex = function(_table, _key, _value) -- ... but get notified when one changes

        assert(_table == self.data.heap)
		if (rawget(metatable, _key) ~= _value) then
		
			metatable[_key] = _value -- store new value
			self._DataChanged:Invoke(self, _key, _value) -- raise an event
			
		end
	end

    -- add a metatable to the baked data,
    -- so as to know it when a single data changes

	setmetatable(self.data.heap, metatable)

	local metatable = {}

	metatable.__index = metatable -- still index keys from metatable itself
	metatable.__newindex = function(_table, _key, _value) -- ... but get notified when one changes

        assert(_table == self.data.baked)
		if (rawget(metatable, _key) ~= _value) then
		
			metatable[_key] = _value -- store new value
			self._DataChanged:Invoke(self, _key, _value) -- raise an event
			
		end
	end

	setmetatable(self.data.baked, metatable)

	-- events

	self._DataChanged = UTEvent:New()

end

-- __dtor --------------------------------------------------------------------

function UTEntity:__dtor()
end