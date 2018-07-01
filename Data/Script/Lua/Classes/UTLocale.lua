
--[[--------------------------------------------------------------------------
--
-- File:            UTLocale.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 27, 2010
--
------------------------------------------------------------------------------
--
-- Description:     Generic team, as a list of players (UTPlayer).
--
----------------------------------------------------------------------------]]

l = nil

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UTLocale()

-- __ctor --------------------------------------------------------------------

function UTLocale:__ctor(...)

    self.locale = quartz.system.locale.getlocale() or "en"
    quartz.system.filesystem.registerpath("game:../System/Locale/" .. self.locale)

    print("locale: " .. self.locale)

    -- table where localized expressions are stored,
    -- the table can have 'recursive' metatables where to look for localized expressions,
    -- cf. Lock(), Unlock()

    self.locales = { }

    -- set handler for function call (using the object as a function)

    local metatable = getmetatable(self)

    metatable.__call = function (locale, key, ...)

        local localized = self.locales[key] or key
        return localized

    end

    assert(not l); l = self

    -- !! MOVE THAT SOMEWHERE !!

    self:Load("base:localization/basics.loc")
    self:Load("base:localization/main.loc")
    self:Load("base:localization/tips.loc")

end

-- __dtor --------------------------------------------------------------------

function UTLocale:__dtor()

    assert(l == self); l = nil

end

-- Load ----------------------------------------------------------------------

function UTLocale:Load(path)

    -- path points to a localization file,
    -- merge content into current locales

    local chunk, message = loadfile(path)
    if (chunk) then

        local result, locales = pcall(chunk)
        if (result) then

            for key, value in pairs(locales) do

                self.locales[key] = value

            end
        else

            print("[UTLocale] Load : failed, " .. locales)

        end

    elseif (message) then

        print("[UTLocale] LUA_ERRRUN : runtime error.\r\n" .. message)

    else

        print("[UTLocale] Load : file not found,")
        print("path = " .. path)

    end

end

-- Lock ----------------------------------------------------------------------

function UTLocale:Lock()

    local locales = { __metatable = self.locales }

    setmetatable(locales, locales.__metatable)
    self.locales.__index = self.locales

    -- change current locales

    self.locales = locales

end

-- Unlock --------------------------------------------------------------------

function UTLocale:Unlock()

    if (self.locales.__metatable) then

        -- change current locales

        self.locales = self.locales.__metatable
        self.locales.__index = nil

    end

end
