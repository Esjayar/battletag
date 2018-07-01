
--[[--------------------------------------------------------------------------
--
-- File:            UTMain.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            April 21, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

REG_FIRSTTIME = false -- override (cf. UTGame.settings.registers.firstTime)

REG_MAJORREVISION = 1
REG_MINORREVISION = 0
REG_BUILD = 312 -- 101108

print("appdata: " .. REG_USERAPPFOLDER)
print("revision: " .. REG_MAJORREVISION)

-- debug intel

GEAR_COMPILE_PLATFORMS =
{
    [GEAR_PLATFORM_WIN32] = "GEAR_PLATFORM_WIN32",
    [GEAR_PLATFORM_XENON] = "GEAR_PLATFORM_XENON",
    
    Str =
    {
        [GEAR_PLATFORM_WIN32] = "win32",
    }
}

GEAR_COMPILE_TARGETS =
{
    [GEAR_COMPILE_RELEASE] = "GEAR_COMPILE_RELEASE",
    [GEAR_COMPILE_DEBUG] = "GEAR_COMPILE_DEBUG",
    [GEAR_COMPILE_RETAIL] = "GEAR_COMPILE_RETAIL",
    
    Str =
    {
        [GEAR_COMPILE_RELEASE] = "release",
        [GEAR_COMPILE_DEBUG] = "debug",
        [GEAR_COMPILE_RETAIL] = "retail",
    }
}

print("platform: " .. GEAR_COMPILE_PLATFORMS[GEAR_CFG_PLATFORM] .. ", target: " .. GEAR_COMPILE_TARGETS[GEAR_CFG_COMPILE])

--[[ Dependencies ----------------------------------------------------------]]

-- scripts

path = (path or "") .. ";base:script/lua/?.lua" .. ";base:script/lua/classes/?.lua"

-- libraries

TARGET = GEAR_COMPILE_PLATFORMS.Str[GEAR_CFG_PLATFORM] .. GEAR_COMPILE_TARGETS.Str[GEAR_CFG_COMPILE] .. "dll"
path = path .. ";game:../../engine/quartz/bin/?." .. TARGET .. ".dll"
path = path .. ";game:../../engine/quartz/bin/ubitoys.?." .. TARGET .. ".dll"

require "UTClass"
require "UTApplication"

if (not GEAR_CFG_COMPILE == GEAR_COMPILE_RETAIL) then

    -- debug
    require "UTStrict"
    
end
