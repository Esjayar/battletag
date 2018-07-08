
--[[--------------------------------------------------------------------------
--
-- File:            ULUsb.State.Connected.lua
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

ULUsb.State.Connected = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsb.State.Connected:__ctor(usb, ...)

    assert(engine)

end

-- __dtor --------------------------------------------------------------------

function ULUsb.State.Connected:__dtor()
end

-- Begin ---------------------------------------------------------------------

function ULUsb.State.Connected:Begin()

    assert(engine.libraries.usb)
	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		assert(proxy)
	end

    print("ULUsb.State.Connected:Begin")

    -- register notifications on active connection

    engine.libraries.usb._DeviceRemoveComplete:Add(self, ULUsb.State.Connected.OnDeviceRemoveComplete)

end

-- End -----------------------------------------------------------------------

function ULUsb.State.Connected:End()

    print("ULUsb.State.Connected:End")
    engine.libraries.usb._DeviceRemoveComplete:Remove(self, ULUsb.State.Connected.OnDeviceRemoveComplete)

end

-- OnDeviceRemoveComplete ----------------------------------------------------

function ULUsb.State.Connected:OnDeviceRemoveComplete(handle)

	for index, proxy in ipairs(engine.libraries.usb.proxies) do
		print("ONDEVICEREMOVECOMPLETE", handle)
		print(proxy.handle)

		assert(proxy)

		-- check if the left handle matches the active proxy's

		if (handle == proxy.handle) then

			engine.libraries.usb:Disconnect(proxy)

		end
	end

end

-- Update --------------------------------------------------------------------

function ULUsb.State.Connected:Update()

    -- update the active proxy,
    -- all usb messages will be processed shortly

    for index, proxy in ipairs(engine.libraries.usb.proxies) do
		proxy:Update()
	end

end
