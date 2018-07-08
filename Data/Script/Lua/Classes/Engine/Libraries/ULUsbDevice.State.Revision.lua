
--[[--------------------------------------------------------------------------
--
-- File:            ULUsbDevice.State.Revision.lua
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

ULUsbDevice.State.Revision = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsbDevice.State.Revision:__ctor(device, ...)

    assert(device and device:IsKindOf(ULUsbDevice))
    self.device = device

    self.revision = nil

end

-- Begin ---------------------------------------------------------------------

function ULUsbDevice.State.Revision:Begin()

    print("ULUsbDevice.State.Revision:Begin")

    assert(engine.libraries.usb)
	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		assert(proxy)

		self.proxy = proxy
	end

    if (self.device.revision) then

        self:OnRevision()

    else

        self.message = { 0x00, self.device.radioProtocolId, 0x04 }

    end

    self.device._ProcessMessage:Add(self, ULUsbDevice.State.Revision.OnProcessMessage)

end

-- End -----------------------------------------------------------------------

function ULUsbDevice.State.Revision:End()

    print("ULUsbDevice.State.Revision:End")

    if (self.device.revisionCandidate) then
        self.device.updateRequired = true
    end

    self.device._ProcessMessage:Remove(self, ULUsbDevice.State.Revision.OnProcessMessage)

end

-- OnProcessMessage ----------------------------------------------------------

function ULUsbDevice.State.Revision:OnProcessMessage(device, addressee, command, arg)

    assert(device == self.device)

    if (command == 0x04) then

        self:OnRevision()

    end    

end

-- OnRevision ----------------------------------------------------------------

function ULUsbDevice.State.Revision:OnRevision()

    assert(self.device)
    assert(self.device.revision)

    if (not self.revision) then

        self.revision = self.device.revision

        self.device:PostStateChange("boot")
        print("ULUsbDevice.State.Revision:OnRevision()")

    end

end

-- Update --------------------------------------------------------------------

function ULUsbDevice.State.Revision:Update()

    -- keep querying the device revision ...

    for index, proxy in ipairs(engine.libraries.usb.proxies) do
		quartz.system.usb.sendmessage(proxy.handle, self.message)
	end

end