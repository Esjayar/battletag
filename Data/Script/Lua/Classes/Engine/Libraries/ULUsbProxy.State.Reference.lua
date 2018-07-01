
--[[--------------------------------------------------------------------------
--
-- File:            ULUsbProxy.State.Reference.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 3, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

ULUsbProxy.State.Reference = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsbProxy.State.Reference:__ctor(device, ...)

    assert(device and device:IsKindOf(ULUsbProxy))
    self.proxy = device

end

-- Begin ---------------------------------------------------------------------

function ULUsbProxy.State.Reference:Begin()

    print("ULUsbProxy.State.Reference:Begin")

    if (self.proxy.referenced) then

        self:OnDeviceReferenced()

    else

        self.message = { 0x00, self.proxy.radioProtocolId, 0x03 }

    end

    self.proxy._Referenced:Add(self, ULUsbProxy.State.Reference.OnDeviceReferenced)

end

-- End -----------------------------------------------------------------------

function ULUsbProxy.State.Reference:End()

    print("ULUsbProxy.State.Reference:End")

    self.proxy._Referenced:Remove(self, ULUsbProxy.State.Reference.OnDeviceReferenced)

end

-- OnDeviceReferenced --------------------------------------------------------

function ULUsbProxy.State.Reference:OnDeviceReferenced()

    self.proxy:PostStateChange("revision")

end

-- Update --------------------------------------------------------------------

function ULUsbProxy.State.Reference:Update()

    -- keep querying the device reference ...

    quartz.system.usb.sendmessage(self.proxy.handle, self.message)

end