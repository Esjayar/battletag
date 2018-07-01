
--[[--------------------------------------------------------------------------
--
-- File:            UTReference.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 11, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UTReference()

-- __ctor --------------------------------------------------------------------

function UTReference:__ctor(array, offset)

    self[1] = 0 -- designation
    self[2] = 0 -- serial

    -- raw bytes

    self.bytes = { 0, 0, 0, 0, 0, 0, 0, 0 }

    -- designation

    self.category = 0
    self.type = { 0, major = 0, minor = 0, }
    self.revision = 0
    self.territory = 0

    self.name = "ulusbdevice"

    -- extend the metatable,

    -- set new handler for '==', '~='
    -- set new handler to convert to string

    local metatable = getmetatable(self)

    metatable.__eq = function(left, right)

        --print("left reference = " .. tostring(left) .. " (big endian)")
        --print("right reference = " .. tostring(right) .. " (big endian)")

        return (left[1] == right[1]) and (left[2] == right[2])
    end

    metatable.__tostring = function(reference)
        return string.format("0x%08x-0x%08x", reference[1], reference[2])
    end

    -- copy constructors

    if (array and (type(array) == "table")) then

        local offset = offset or 0

        if (offset and (type(offset) == "number")) then

            assert(8 <= (table.getn(array) - offset), string.format("#array = %d, offset = %d", table.getn(array), offset))

            -- all big endian

            self[1] = quartz.system.bitwise.bitwiseor(quartz.system.bitwise.lshift(array[offset + 5], 24), quartz.system.bitwise.lshift(array[offset + 6], 16), quartz.system.bitwise.lshift(array[offset + 7], 8), array[offset + 8])
            self[2] = quartz.system.bitwise.bitwiseor(quartz.system.bitwise.lshift(array[offset + 1], 24), quartz.system.bitwise.lshift(array[offset + 2], 16), quartz.system.bitwise.lshift(array[offset + 3], 8), array[offset + 4])

            self.category = quartz.system.bitwise.bitwiseand(array[offset + 5], 0x0f)

            self.type[1] = quartz.system.bitwise.bitwiseand(self[1], 0xffff)

            self.type.major = quartz.system.bitwise.rshift(self.type[1], 4)
            self.type.minor = quartz.system.bitwise.bitwiseand(self.type[1], 0x0f)

            self.territory = quartz.system.bitwise.rshift(array[offset + 5], 4)
            self.revision = array[offset + 6]

            for i = 1, 8 do self.bytes[i] = array[offset + i] end

        end
    end

end