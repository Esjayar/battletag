
--[[--------------------------------------------------------------------------
--
-- File:            UTClass.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            May 26, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

-- to be refactored for the sake of performance and efficiency:
-- flatten inherited attributes in 'compiled' class, used as metatable for instances to share,
-- keep access to overriden base attributes

UTClass = {}
UTClass.__metatable = {}

setmetatable(UTClass, UTClass.__metatable)
UTClass.__metatable.__index = UTClass.__metatable

function UTClass.__metatable:__call(...)

    local arg = { ... }

    local class = {}
    
    class.__type = "class"

    -- A first string argument sets the name of the class.
	if (type(arg[1]) == "string") then

		class.__name = arg[1]
		table.remove(arg, 1)

	else

    	-- ... otherwise we end up with an unnamed class.
		class.__name = declaration

	end

    local base = arg[1] or UTClass.metatable
    if (base) then

        assert(type(base) == "table", "invalid base; must be a table")

    end

    setmetatable(class, class)

    class.__index = base
    class.__base = base

    -- Metatable for class instances to access metamethods from.
    class.metatable = { __index = class }

    return class

end

function UTClass.__metatable:__index(name)

	return function(...)

		local class = UTClass(name, ...)

		getfenv()[name] = class
		return class

	end
end

UTClass.metatable = {}
setmetatable(UTClass.metatable, UTClass.metatable)

function UTClass.metatable:__ctor()
end

function UTClass.metatable:__dtor()
end

function UTClass.metatable:Class()
    return self.__base
end

function UTClass.metatable:Delete()

    local destructor = rawget(self, "__dtor")

    if (destructor) then
        destructor(self)
    end

    local declaration = getmetatable(self)

    while (declaration) do

        local destructor = rawget(declaration, "__dtor")

        if (destructor) then
            destructor(self)
        end

        declaration = declaration.__index

    end
end

function UTClass.metatable:IsKindOf(base)

    assert(rawget(self, "__type") == "instance")

    local index = self.__base
    while (index) do
        if (index == base) then return true end
        index = index.__index
    end

    return false

end

function UTClass.metatable:New(...)

    local instance = {
        __type = "instance",
        __base = self,
    }

    setmetatable(instance, self.metatable)

    local constructors = {}

    local declaration = self
    while (declaration) do

        local constructor = rawget(declaration, "__ctor")

        if (constructor) then
            table.insert(constructors, 1, constructor)
        end

        declaration = declaration.__index

    end

    for _, constructor in ipairs(constructors) do
        constructor(instance, ...)
    end

    return instance
    
end