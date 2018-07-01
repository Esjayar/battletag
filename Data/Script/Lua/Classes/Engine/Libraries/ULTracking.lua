
--[[--------------------------------------------------------------------------
--
-- File:            ULTracking.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            October 20, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "quartz.tracking"

--[[ Class -----------------------------------------------------------------]]

UTClass.ULTracking(UELibrary)

-- defaults

ULTracking.updateFrameRate = 30

-- __ctor --------------------------------------------------------------------

function ULTracking:__ctor(engine, ...)

    self.language = quartz.system.locale.getlocale() or "undefined"
    self.version = tostring(REG_MAJORREVISION) .. "." .. tostring(REG_MINORREVISION)
    self.playMode = quartz.system.locale.getiso3166countryname() or "undefined"

    self.delegates = {}

    self.delegates["FPSCLIENT_START"] = function ()

        assert(game)
        assert(activity)

        local attributes = {}

        local MAC = ""

        if (activity.players) then
            attributes.NUMPLAYERS = #activity.players
            attributes.NUMGUNS = 0
            for _, player in pairs(activity.players) do
                if (player.rfGunDevice) then

                    attributes.NUMGUNS = attributes.NUMGUNS + 1
                    
                    MAC = MAC .. string.format("%08x%08x;", player.rfGunDevice.reference[1], player.rfGunDevice.reference[2])

                end
            end
        end

        if (activity.nfo and activity.nfo.__directory) then attributes.MPMODE = string.upper(activity.nfo.__directory) end

        local ADVSET = ""

        for key, value in pairs(activity.settings) do
            if (type(key) == "string") then
                if not (ADVSET == "") then ADVSET = ADVSET .. "," end
                ADVSET = ADVSET .. key .. "=" .. tostring(value)
            end
        end

        if not (ADVSET == "") then ADVSET = ADVSET .. "," end
        ADVSET = ADVSET .. "NUMGUNS=" .. tostring(attributes.NUMGUNS)
        ADVSET = ADVSET .. ",MAC=" .. tostring(MAC)
        attributes.NUMGUNS = nil

        ADVSET = ADVSET .. ",ADVERTISED=" .. (activity.advertised and "1" or "0")
        ADVSET = ADVSET .. ",FORWARD=" .. (activity.forward and "1" or "0")

        attributes.ADVSET = string.upper(ADVSET)
        
        self:SendTag("FPSCLIENT_START", attributes)

    end

    self.delegates["FPSCLIENT_STOP"] = function ()

        assert(game)
        assert(activity)

        local attributes = {}

        if (activity.players) then attributes.NUMPLAYERS = #activity.players end
        if (activity.nfo and activity.nfo.__directory) then attributes.MPMODE = string.upper(activity.nfo.__directory) end

        local ADVSTAT = ""

        if (activity.players) then

            local ACCURACY = ""

            for _, player in pairs(activity.players) do
                if (player.data.baked.accuracy) then
                    ACCURACY = ACCURACY .. math.ceil(math.min(100, math.max(0, player.data.baked.accuracy))) .. ";"
                end
            end

            if not (ACCURACY == "") then
                if not (ADVSTAT == "") then ADVSTAT = ADVSTAT .. "," end
                ADVSTAT = ADVSTAT .. "ACCURACY=" .. ACCURACY
            end

        end

        if not (ADVSTAT == "") then
            attributes.ADVSTAT = string.upper(ADVSTAT)
        end

        self:SendTag("FPSCLIENT_STOP", attributes)

    end

end

-- __dtor --------------------------------------------------------------------

function ULTracking:__dtor()
end

-- Close ---------------------------------------------------------------------

function ULTracking:Close()

	self:SendTag("GAME_STOP", { LANGUAGE = self.language, VERSION = self.version, PLAYMODE = self.playMode, })

	if (self.opened) then

        if (REG_TRACKING) then

            assert(self.module)
            assert(type(self.module) == "userdata")

            quartz.tracking.close(); self.module = nil

        end

        UELibrary.Close(self)

    end

    return self.opened

end

-- Open ----------------------------------------------------------------------

function ULTracking:Open()

    if (not self.opened) then
    
        if (REG_TRACKING) then

            self.module = quartz.tracking.open()

            if (self.module) then

                assert(self.module)
                assert(type(self.module) == "userdata")

                -- assume the library was opened

                UELibrary.Open(self)

            end

        else

            -- assume the library was opened

            UELibrary.Open(self)

        end
    end

	self:SendTag("GAME_START", { LANGUAGE = self.language, VERSION = self.version, PLAYMODE = self.playMode, })

    return self.opened

end

-- SendTag -------------------------------------------------------------------

function ULTracking:SendTag(tag, attributes)

    if (REG_TRACKING) then
        if (self.opened) then

	        local str = ""
	        for key, value in pairs(attributes) do
		        if str == "" then str = key .. "=" .. tostring(value)
		        else str = str .. "&" .. key .. "=" .. tostring(value)
		        end
	        end

	        quartz.tracking.sendtag(tag, str)
	        
if not (GEAR_CFG_COMPILE == GEAR_COMPILE_RETAIL) then        
	        print("tracking: [" .. tag .. "] " .. str)
end

        end
    end

end
