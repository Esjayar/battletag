
--[[--------------------------------------------------------------------------
--
-- File:            ULUsbDevice.State.Profile.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            October 1, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

ULUsbDevice.State.Profile = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsbDevice.State.Profile:__ctor(device, ...)

    assert(device and device:IsKindOf(ULUsbDevice))
    self.device = device

end

-- Begin ---------------------------------------------------------------------

function ULUsbDevice.State.Profile:Begin()

    print("ULUsbDevice.State.Profile:Begin")

    assert(engine.libraries.usb)
	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		assert(proxy)

		self.proxy = proxy
	end

    self.device.playerProfile = nil

    local address, size = 0x00000011, 0x30
    self.message = { 0x05, self.device.radioProtocolId, 0x84, quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 24), 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 16), 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 8), 0xff), quartz.system.bitwise.bitwiseand(address, 0xff), quartz.system.bitwise.bitwiseand(size, 0xff)}

    self.device._PlayerProfileUpdated:Add(self, ULUsbDevice.State.Profile.OnPlayerProfileUpdated)

end

-- End -----------------------------------------------------------------------

function ULUsbDevice.State.Profile:End()

    print("ULUsbDevice.State.Profile:End")

    self.device._PlayerProfileUpdated:Remove(self, ULUsbDevice.State.Profile.OnPlayerProfileUpdated)

end

-- OnPlayerProfileUpdated -----------------------------------------------------

function ULUsbDevice.State.Profile:OnPlayerProfileUpdated(device, profile)

    self:PostStateChange("boot")

end

-- Update --------------------------------------------------------------------

function ULUsbDevice.State.Profile:Update()

    -- keep querying the device profile ...

    for index, proxy in ipairs(engine.libraries.usb.proxies) do
		quartz.system.usb.sendmessage(proxy.handle, self.message)
	end

end