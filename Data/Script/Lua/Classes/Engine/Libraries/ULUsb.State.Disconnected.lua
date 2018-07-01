
--[[--------------------------------------------------------------------------
--
-- File:            ULUsb.State.Disconnected.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 2, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

ULUsb.State.Disconnected = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsb.State.Disconnected:__ctor(usb, ...)

    assert(engine)

end

-- __dtor --------------------------------------------------------------------

function ULUsb.State.Disconnected:__dtor()
end

-- Begin ---------------------------------------------------------------------

function ULUsb.State.Disconnected:Begin()

    assert(engine.libraries.usb)
    print("ULUsb.State.Disconnected:Begin")

    -- make it a complete reset

    engine.libraries.usb:Reset()
    self.proxies = {}

    -- foreach handle,
    -- create new empty proxy

    for _, handle in ipairs(engine.libraries.usb.handles) do

        self:RegisterHandle(handle)

    end

    -- register for new proxies

    engine.libraries.usb._DeviceArrival:Add(self, ULUsb.State.Disconnected.OnDeviceArrival)

end

-- End -----------------------------------------------------------------------

function ULUsb.State.Disconnected:End()

    print("ULUsb.State.Disconnected:End")

    -- release all pending proxies

    table.foreachi(self.proxies, function (index, proxy) proxy:Delete() end)
    self.proxies = {}

    -- cancel registration,
    -- further devices proxies are just ignored

    engine.libraries.usb._DeviceArrival:Remove(self, ULUsb.State.Disconnected.OnDeviceArrival)

end

-- OnDeviceArrival -----------------------------------------------------------

function ULUsb.State.Disconnected:OnDeviceArrival(handle)

    self:RegisterHandle(handle)

end

-- RegisterHandle ------------------------------------------------------------

function ULUsb.State.Disconnected:RegisterHandle(handle)

    -- create new empty proxy

    local proxy = ULUsbProxy:New(handle)
    table.insert(self.proxies, proxy)

end

-- Update --------------------------------------------------------------------

function ULUsb.State.Disconnected:Update()

    assert(not engine.libraries.usb.connected)

    -- update proxies,
    -- until one gets fully initialized

    for index, proxy in ipairs(self.proxies) do

        proxy:Update()

        if (proxy.connected) then

            -- promote proxy

            table.remove(self.proxies, index)
            engine.libraries.usb:Connect(proxy)

            break

        end
    end

end
