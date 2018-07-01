
--[[--------------------------------------------------------------------------
--
-- File:            ULUsbProxy.State.Bootloader.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 10, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

ULUsbProxy.State.Bootloader = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsbProxy.State.Bootloader:__ctor(device, ...)

    assert(device and device:IsKindOf(ULUsbProxy))
    self.proxy = device

end

-- Begin ---------------------------------------------------------------------

function ULUsbProxy.State.Bootloader:Begin()

    print("ULUsbProxy.State.Bootloader:Begin")

    self.message = { 0x00, 0x00, 0x21 }

    print("REBOOT!")
    quartz.system.usb.sendmessage(self.proxy.handle, self.message)
    
end

-- End -----------------------------------------------------------------------

function ULUsbProxy.State.Bootloader:End()

    print("ULUsbProxy.State.Bootloader:End")

end
