
--[[--------------------------------------------------------------------------
--
-- File:            ULUsbProxy.State.Revision.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 27, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

ULUsbProxy.State.Revision = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsbProxy.State.Revision:__ctor(device, ...)

    assert(device and device:IsKindOf(ULUsbProxy))
    self.proxy = device

    self.revision = nil

end

-- Begin ---------------------------------------------------------------------

function ULUsbProxy.State.Revision:Begin()

    print("ULUsbProxy.State.Revision:Begin")

    if (self.proxy.revision) then

        self:OnRevision()

    else

        self.message = { 0x00, self.proxy.radioProtocolId, 0x04 }

    end

    self.proxy._ProcessMessage:Add(self, ULUsbProxy.State.Revision.OnProcessMessage)

end

-- End -----------------------------------------------------------------------

function ULUsbProxy.State.Revision:End()

    print("ULUsbProxy.State.Revision:End")

    self.proxy._ProcessMessage:Remove(self, ULUsbProxy.State.Revision.OnProcessMessage)

end

-- OnProcessMessage ----------------------------------------------------------

function ULUsbProxy.State.Revision:OnProcessMessage(device, addressee, command, arg)

    assert(device == self.proxy)

    if (command == 0x04) then

        self:OnRevision()

    end    

end

-- OnRevision ----------------------------------------------------------------

function ULUsbProxy.State.Revision:OnRevision()

    assert(self.proxy)
    assert(self.proxy.revision)

    if (not self.revision) then

        self.revision = self.proxy.revision

        self.proxy:PostStateChange()
        print("ULUsbProxy.State.Revision:OnRevision()")

    end

end

-- Update --------------------------------------------------------------------

function ULUsbProxy.State.Revision:Update()

    -- keep querying the device revision ...

    quartz.system.usb.sendmessage(self.proxy.handle, self.message)

end