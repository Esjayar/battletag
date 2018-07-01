
--[[--------------------------------------------------------------------------
--
-- File:            ULUsbDevice.State.Boot.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 27, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

ULUsbDevice.State.Boot = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsbDevice.State.Boot:__ctor(device, ...)

    assert(device and device:IsKindOf(ULUsbDevice))
    
    self.device = device

end

-- Begin ---------------------------------------------------------------------

function ULUsbDevice.State.Boot:Begin()

    print("ULUsbDevice.State.Boot:Begin")

    if (not self.device.revision) then

        self:PostStateChange("revision")

    -- elseif (self.device.revisionCandidate) then

        -- self:PostStateChange("upload", self.device.revisionCandidate.path, 0x78000)

    elseif (not self.device.playerProfileChecked) then

        self.device.playerProfileChecked = true
        self:PostStateChange("profile")

    else

        self:PostStateChange()

    end

end

-- End -----------------------------------------------------------------------

function ULUsbDevice.State.Boot:End()

    print("ULUsbDevice.State.Boot:End")

end