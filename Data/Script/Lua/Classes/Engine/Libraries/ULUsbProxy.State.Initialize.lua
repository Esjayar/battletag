
--[[--------------------------------------------------------------------------
--
-- File:            ULUsbProxy.State.Initialize.lua
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

ULUsbProxy.State.Initialize = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsbProxy.State.Initialize:__ctor(device, ...)

    assert(device and device:IsKindOf(ULUsbProxy))
    self.proxy = device

    self.message = { 0x01, 0x00, 0x01, 0xff }

end

-- Begin ---------------------------------------------------------------------

function ULUsbProxy.State.Initialize:Begin()

    print("ULUsbProxy.State.Initialize:Begin")

    self.proxy:Reset()
    
    self.proxy._Connected:Add(self, ULUsbProxy.State.Initialize.OnDeviceConnected)
    self.proxy._Initialized:Add(self, ULUsbProxy.State.Initialize.OnDeviceInitialized)

end

-- End -----------------------------------------------------------------------

function ULUsbProxy.State.Initialize:End()

    print("ULUsbProxy.State.Initialize:End")

    self.proxy._Connected:Remove(self, ULUsbProxy.State.Initialize.OnDeviceConnected)
    self.proxy._Initialized:Remove(self, ULUsbProxy.State.Initialize.OnDeviceInitialized)

end

-- OnDeviceInitialized -------------------------------------------------------

function ULUsbProxy.State.Initialize:OnDeviceConnected()

    print("OnDeviceConnected")
    --self:PostStateChange("reference")

end

-- OnDeviceInitialized -------------------------------------------------------

function ULUsbProxy.State.Initialize:OnDeviceInitialized()

    print("OnDeviceInitialized")
    self:PostStateChange("reference")

end

-- Update --------------------------------------------------------------------

function ULUsbProxy.State.Initialize:Update()

    -- keep asking for device initialization ...

    quartz.system.usb.sendmessage(self.proxy.handle, self.message)

end