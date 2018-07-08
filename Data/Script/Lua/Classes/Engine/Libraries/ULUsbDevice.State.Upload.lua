
--[[--------------------------------------------------------------------------
--
-- File:            ULUsbDevice.State.Upload.lua
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

ULUsbDevice.State.Upload = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsbDevice.State.Upload:__ctor(device, ...)

    assert(device and device:IsKindOf(ULUsbDevice))
    self.device = device

end

-- Begin ---------------------------------------------------------------------

function ULUsbDevice.State.Upload:Begin(arg)

    print("ULUsbDevice.State.Upload:Begin")

    assert(engine.libraries.usb)
	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		assert(proxy)

		self.proxy = proxy
		self.handle = proxy.handle
	end

    -- retrieve arguments 

    local path = arg[1]
    local address = arg[2]

    print("path = " .. path .. ", address = " .. string.format("0x%08x", address))

    -- use the device flash memory manager to upload the data,
    -- multiple devices may benefit from simultaneous uploads if data is the same

    self.proxy.processes.deviceFlashMemoryManager:Upload(self.device, path, address)

end

-- End -----------------------------------------------------------------------

function ULUsbDevice.State.Upload:End()

    --self.device._ProcessMessage:Remove(self, ULUsbDevice.State.Revision.OnProcessMessage)

    print("ULUsbDevice.State.Upload:End")

    -- engine.libraries.usb:SetUpdateFrameRate(self.updateFrameRate)

end

-- Update --------------------------------------------------------------------

function ULUsbDevice.State.Upload:Update()
end