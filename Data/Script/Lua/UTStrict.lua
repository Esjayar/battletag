
--[[--------------------------------------------------------------------------
--
-- File:            UTStrict.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            April 27, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

local mt = getmetatable(_G)

if (mt == nil) then

	mt = {}
	setmetatable(_G, mt)

end

__strict = true

mt.__declared = {}
mt.__newindex = function (t, n, v)

	if (__strict and not mt.__declared[n]) then

		local w = debug.getinfo(2, "S").what
		if (w ~= "main" and w ~= "C") then
			error("assign to undeclared variable '" .. n .. "'", 2)
		end

		mt.__declared[n] = true

	end

	rawset(t, n, v)

end

mt.__index = function (t, n)

	if (not mt.__declared[n] and debug.getinfo(2, "S").what ~= "C") then
		error("variable '" .. n .. "' is not declared", 2)
	end

	return rawget(t, n)

end

function global(...)
   for _, v in ipairs { ... } do mt.__declared[v] = true end
end

