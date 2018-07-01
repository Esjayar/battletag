
--[[--------------------------------------------------------------------------
--
-- File:            ULUsbDevice.FlashMemoryManager.lua
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

ULUsbDevice.FlashMemoryManager = UTClass(UTProcess)

-- defaults

ULUsbDevice.FlashMemoryManager.pageSize = 4 * 1024
ULUsbDevice.FlashMemoryManager.startSuspended = true
ULUsbDevice.FlashMemoryManager.updateFrameRate = 0

-- __ctor --------------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:__ctor(proxy)

    assert(proxy)
    assert(proxy.handle)

    self.proxy = proxy
    self.handle = self.proxy.handle

    -- lookup table of registered devices,
    -- when a device asks for an upload it is added to the list (cf. Upload)

    self.devices = {}

    -- list of tasks,
    -- all tasks are sorted by <path and address>, even though addresses should not change in practise

    self.tasks = {}
    self.task = nil -- no pending task yet

    -- task setup handlers

    self.handlers = {}

    self.handlers[1] = ULUsbDevice.FlashMemoryManager.Stage1_Unlock
    self.handlers[2] = ULUsbDevice.FlashMemoryManager.Stage2_Erase
    self.handlers[3] = ULUsbDevice.FlashMemoryManager.Stage3_WriteRequest
    self.handlers[4] = ULUsbDevice.FlashMemoryManager.Stage4_Write
    self.handlers[5] = ULUsbDevice.FlashMemoryManager.Stage5_Lock

    self.handlers[6] = ULUsbDevice.FlashMemoryManager.Stage6_Unlock
    self.handlers[7] = ULUsbDevice.FlashMemoryManager.Stage7_WriteRequest
    self.handlers[8] = ULUsbDevice.FlashMemoryManager.Stage8_Write
    self.handlers[9] = ULUsbDevice.FlashMemoryManager.Stage9_Boot

end

-- Clear -----------------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Clear()

    self.tasks, self.task = {}
    self:Suspend()

end

-- NextStage -------------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:NextStage(stage)

    assert(self.task)

    self.task.stage = stage or (self.task.stage and self.task.stage + 1)

    -- task stage shall increase when all clients are ready to move on,
    -- task is considered complete when there is no handler left for the latests stage

    local handler = self.handlers[self.task.stage]
    if (not handler) then
        return self:Pop("complete")
    end

    handler(self)

    --

	if (#self.task.clients == 1) then 
		self.usbUpdateFrameRate = 14
	else

		-- !! device number may be used ... not task client
		-- self.usbUpdateFrameRate = 14 - #self.task.clients

		local devices = engine.libraries.usb.proxy.devices.byClass[0x02000020]
		if (not devices) then
		    return self:Pop("fail") -- disconnected devices
		end
		self.usbUpdateFrameRate = 14 - #devices

	end
	self.pingInterval = self.usbUpdateFrameRate * 5

    assert(engine.libraries.usb)
    engine.libraries.usb:SetUpdateFrameRate(self.usbUpdateFrameRate)

end

-- OnDeviceRemoved -----------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:OnDeviceRemoved(device)

    local removed = false

    for _, task in pairs(self.tasks) do

        -- lookup device

        for index, client in pairs(task.clients) do
            if (client.device == device) then

                -- remove the client whose device was disconnected ...

                removed = table.remove(task.clients, index)
                break

            end
        end
    end

    -- the task fails,
    -- if there are no clients left to update

    local clients = 0

    if (self.task) then
        for _, client in pairs(self.task.clients) do

            if (client.device == device) then return self:Pop("fail")
            end

            clients = clients + 1

        end
    end

    if (0 == clients) then return self:Pop("fail")
    end

end

-- OnDispatchMessage ---------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:OnDispatchMessage(device, addressee, command, arg)

    if (self.task and self.task.acknowledge) then self.task.acknowledge(addressee, command, arg)
    end

end

-- OnResumed -----------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:OnResumed()

    if (not self.dispatchMessage) then

        self.dispatchMessage = true

        assert(engine.libraries.usb.proxy and (engine.libraries.usb.proxy == self.proxy))

        engine.libraries.usb.proxy._DispatchMessage:Add(self, ULUsbDevice.FlashMemoryManager.OnDispatchMessage)
        engine.libraries.usb.proxy._DeviceRemoved:Add(self, ULUsbDevice.FlashMemoryManager.OnDeviceRemoved)

    end

    self.lastResult = nil

end

-- OnSuspended ---------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:OnSuspended()

    assert(engine.libraries.usb)
    engine.libraries.usb:SetUpdateFrameRate(ULUsb.updateFrameRate)

    if (self.dispatchMessage) then
        
        self.dispatchMessage = false

        assert(engine.libraries.usb.proxy and (engine.libraries.usb.proxy == self.proxy))

        engine.libraries.usb.proxy._DispatchMessage:Remove(self, ULUsbDevice.FlashMemoryManager.OnDispatchMessage)
        engine.libraries.usb.proxy._DeviceRemoved:Remove(self, ULUsbDevice.FlashMemoryManager.OnDeviceRemoved)

    end

end

-- OnUpdate ------------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:OnUpdate()

    assert(engine.libraries.usb.proxy)
    assert(engine.libraries.usb.proxy.handle)

    --self.time = self.time or quartz.system.time.gettimemicroseconds()
    --local time = quartz.system.time.gettimemicroseconds()
    --print(time - self.time)
    --self.time = time

    if (self.task) then
        local completion = not self.task.delegate or (self:Ping() and self.task.delegate())
        if (completion) then self:NextStage()
        end
    end

end

-- Ping ----------------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Ping()

    -- the pinger cannot be trusted when the flash memory manager is uploading,
    -- once in a while we must ping the devices

    self.ping = self.ping + 1
    if (self.ping >= self.pingInterval) then

        self.ping = 0
        quartz.system.usb.sendmessage(self.handle, self.pingMessage)

        print("ping *")

        return false

    end

    return true

end

-- Pop -----------------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Pop(result)

    self.lastResult = result

    print(string.format("ULUsbDevice.FlashMemoryManager:Pop(\"%s\")", result))

    -- remove task from list

    assert(self.task)

    for index, task in pairs(self.tasks) do
        if (task == self.task) then

            self.task = table.remove(self.tasks, index)
            -- ?? CLIENTS NOTIFICATION

        end
    end

    assert(self.task)
    self:Restart(true)

end

-- Restart -------------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Restart(front)

    UTProcess.Restart(self)

    --

    if (front or not self.task) then
        self.task = table.remove(self.tasks)
    end

    if (self.task) then self:Resume()
    else return self:Suspend()
    end

    print("upload: " .. self.task.path)

    -- prepare host

    assert(self.task.address)
    assert(self.task.path)

    self.task.stage = nil
    self.task.binarySize = quartz.system.usb.loadbinary(self.task.path)

    if (not self.task.binarySize) then 
        return self:Pop("fail")
    end

    -- prepare clients

    if (0 == self.task.clients) then 
        return self:Pop("fail")
    end

    for _, client in pairs(self.task.clients) do
        if (not client.stage) then
            client.stage = self.task.stage
        end
    end

    self:NextStage(1)

    -- ping

    self.ping = 0
    self.pingInterval = self.usbUpdateFrameRate * 2
    self.pingMessage = { 0x00, 0xff, 0x05 }

end

-- Stage1_Unlock -------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Stage1_Unlock()

    print("Stage1_Unlock")

    assert(self.task)
    assert(self.task.stage == 1)

    -- unlock the flash memory access,
    -- it is locked by default to prevent accidental protected op. calls

    self.task.text = l "oth045" -- "Unlocking ..."
    self.task.progress = 0

    -- setup

    for _, client in pairs(self.task.clients) do
        client.flashMemoryLocked = true
    end

    local message = { 0x01, 0xff, 0x86, 0x00 }

    -- update delegate

    self.task.delegate = function ()

        self.task.progress = 0

        for _, client in pairs(self.task.clients) do
            if (client.flashMemoryLocked) then

                message[2] = client.device.radioProtocolId
                quartz.system.usb.sendmessage(self.handle, message)

                return false

            end

            print("device was unlocked: " .. tostring(client.device.reference))

            self.task.progress = self.task.progress + 1
            self.task.progress = (self.task.progress / #self.task.clients) * 100

        end

        self.task.progress = 100
        return true

    end

    -- acknowledge delegate

    self.task.acknowledge = function (addressee, command, arg)
        --print(addressee, command, unpack(arg))
        if (command == 0x86) then
            local client = self.task.clients[addressee]
            if (client) then client.flashMemoryLocked = not (arg[1] == 0x00)
            end
        end
    end

end

-- Stage2_Erase --------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Stage2_Erase(client)

    print("Stage2_Erase")

    assert(self.task)
    assert(self.task.stage == 2)

    -- erase number of pages,
    -- pages starting at input address and offset by 'pageSize' each

    self.task.text = l "oth046" -- "Erasing ..."
    self.task.progress = 0

    -- setup

    local page, pages = 1, math.ceil(self.task.binarySize / ULUsbDevice.FlashMemoryManager.pageSize)

    for _, client in pairs(self.task.clients) do
        client.address = self.task.address
    end

    local address = self.task.address
    local message = { 0x04, 0xff, 0x81, quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 24), 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 16), 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 8), 0xff), quartz.system.bitwise.bitwiseand(address, 0xff), }

    -- update delegate

    self.task.delegate = function ()

        for _, client in pairs(self.task.clients) do
            if (client.address == address) then

                quartz.system.usb.sendmessage(self.handle, message)
                return false

            end
        end

        -- next page

        page = page + 1
        self.task.progress = ((page - 1) / pages) * 100

        if (page > pages) then return true
        end

        address = address + ULUsbDevice.FlashMemoryManager.pageSize
        message = { 0x04, 0xff, 0x81, quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 24), 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 16), 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 8), 0xff), quartz.system.bitwise.bitwiseand(address, 0xff), }

    end

    -- acknowledge delegate

    self.task.acknowledge = function (addressee, command, arg)
        if (command == 0x81) then

            local client = self.task.clients[addressee]
            local address__ = quartz.system.bitwise.bitwiseor(quartz.system.bitwise.lshift(arg[1], 24), quartz.system.bitwise.lshift(arg[2], 16), quartz.system.bitwise.lshift(arg[3], 8), arg[4])

            if (client and (client.address == address__)) then client.address = client.address + ULUsbDevice.FlashMemoryManager.pageSize
            end
        end
    end

end

-- Stage3_WriteRequest -------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Stage3_WriteRequest(client)

    print("Stage3_WriteRequest")
    
    assert(self.task)
    assert(self.task.stage == 3)

    self.task.text = l "oth047" -- "Copying ..."
    self.task.progress = 0

    -- setup

    for _, client in pairs(self.task.clients) do
        client.flashMemoryWriteRequested = false
    end

    local address, size = self.task.address, self.task.binarySize
    local message = { 0x06, 0xff, 0x82, quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 24), 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 16), 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 8), 0xff), quartz.system.bitwise.bitwiseand(address, 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(size, 8), 0xff), quartz.system.bitwise.bitwiseand(size, 0xff)}

    -- update delegate

    self.task.delegate = function ()

        for _, client in pairs(self.task.clients) do
            if (not client.flashMemoryWriteRequested) then

                message[2] = client.device.radioProtocolId
                quartz.system.usb.sendmessage(self.handle, message)

                return false

            end
        end

        return true

    end

    -- acknowledge delegate

    self.task.acknowledge = function (addressee, command, arg)
        if (command == 0x82) then

            local client = self.task.clients[addressee]
            local address__ = quartz.system.bitwise.bitwiseor(quartz.system.bitwise.lshift(arg[1], 24), quartz.system.bitwise.lshift(arg[2], 16), quartz.system.bitwise.lshift(arg[3], 8), arg[4])

            if (client and (address == address__)) then client.flashMemoryWriteRequested = true
            end
        end
    end

end

-- Stage4_Write --------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Stage4_Write(client)

    print("Stage4_Write")
    
    assert(self.task)
    assert(self.task.stage == 4)

    -- erase number of pages,
    -- pages starting at input address and offset by 'pageSize' each

    self.task.text = l "oth048" -- "Copying ..."
    self.task.progress = 0

    -- setup

    for _, client in pairs(self.task.clients) do
        client.offset = 0
    end

    local address, offsetAddress = 0, -1

    -- update delegate

    self.task.delegate = function ()

        for _, client in pairs(self.task.clients) do
            if (client.offset == address) then

                local bytesSent = quartz.system.usb.upload(self.handle, 0xff, address)
                if (0 < bytesSent) then
                    offsetAddress = address + bytesSent
                end

                --print(string.format("0x%08x w", address))
                return false

            end
        end

        -- next chunk

        address = offsetAddress
        self.task.progress = (address / self.task.binarySize) * 100

        if (address >= self.task.binarySize) then return true
        end

        local bytesSent = quartz.system.usb.upload(self.handle, 0xff, address)
        if (0 < bytesSent) then
            offsetAddress = address + bytesSent
        end

        --print(string.format("0x%08x w+", address))
        return false

    end

    -- acknowledge delegate

    self.task.acknowledge = function (addressee, command, arg)
        if (command == 0x83) then

            local client = self.task.clients[addressee]
            local offset = quartz.system.bitwise.bitwiseor(quartz.system.bitwise.lshift(arg[1], 8), arg[2])

            --print(string.format("0x%08x r", offset))

            if (client and (client.offset < offset)) then client.offset = offset
            end
        end
    end

end

-- Stage5_Lock ---------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Stage5_Lock()

    print("Stage5_Lock")

    assert(self.task)
    assert(self.task.stage == 5)

    -- lock the flash memory access,
    -- it is locked by default to prevent accidental protected op. calls

    self.task.text = l "oth045" -- "Unlocking ..."
    self.task.progress = 0

    -- setup

    for _, client in pairs(self.task.clients) do
        client.flashMemoryLocked = false
    end

    local message = { 0x01, 0xff, 0x86, 0x01 }

    -- update delegate

    self.task.delegate = function ()

        self.task.progress = 0

        for _, client in pairs(self.task.clients) do
            if (not client.flashMemoryLocked) then

                message[2] = client.device.radioProtocolId
                quartz.system.usb.sendmessage(self.handle, message)

                return false

            end

            print("device was locked: " .. tostring(client.device.reference))

            self.task.progress = self.task.progress + 1
            self.task.progress = (self.task.progress / #self.task.clients) * 100

        end

        self.task.progress = 100
        return true

    end

    -- acknowledge delegate

    self.task.acknowledge = function (addressee, command, arg)
        --print(addressee, command, unpack(arg))
        if (command == 0x86) then
            local client = self.task.clients[addressee]
            if (client) then client.flashMemoryLocked = (arg[1] == 0x01)
            end
        end
    end

end

-- Stage6_Unlock -------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Stage6_Unlock()

    print("Stage6_Unlock")

    assert(self.task)
    assert(self.task.stage == 6)

    -- only firmware updates need a software reboot,
    -- initiated by yet another write request ...
    -- initiated by yet another flash memory unlock request ...

    if not (self.task.address == 0x78000) then
        return self:NextStage(-1)
    end

    -- unlock the flash memory access,
    -- it is locked by default to prevent accidental protected op. calls

    self.task.text = l "oth045" -- "Unlocking ..."
    self.task.progress = 0

    -- setup

    for _, client in pairs(self.task.clients) do
        client.flashMemoryLocked = true
    end

    local message = { 0x01, 0xff, 0x86, 0x00 }

    -- update delegate

    self.task.delegate = function ()

        self.task.progress = 0

        for _, client in pairs(self.task.clients) do
            if (client.flashMemoryLocked) then

                message[2] = client.device.radioProtocolId
                quartz.system.usb.sendmessage(self.handle, message)

                return false

            end

            print("device was unlocked: " .. tostring(client.device.reference))

            self.task.progress = self.task.progress + 1
            self.task.progress = (self.task.progress / #self.task.clients) * 100

        end

        self.task.progress = 100
        return true

    end

    -- acknowledge delegate

    self.task.acknowledge = function (addressee, command, arg)
        --print(addressee, command, unpack(arg))
        if (command == 0x86) then
            local client = self.task.clients[addressee]
            if (client) then client.flashMemoryLocked = not (arg[1] == 0x00)
            end
        end
    end

end

-- Stage7_WriteRequest --------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Stage7_WriteRequest(client)

    print("Stage7_WriteRequest")

    assert(self.task)
    assert(self.task.stage == 7)

    -- only firmware updates need a software reboot,
    -- initiated by yet another write request ...

    if not (self.task.address == 0x78000) then
        return self:NextStage(-1)
    end

    self.task.text = l "oth049" -- "Rebooting ..."
    self.task.progress = 0

    -- setup

    for _, client in pairs(self.task.clients) do
        client.flashMemoryWriteRequested = false
    end

    local address, size = 0x7fc00, 2
    local message = { 0x06, 0xff, 0x82, quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 24), 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 16), 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(address, 8), 0xff), quartz.system.bitwise.bitwiseand(address, 0xff), quartz.system.bitwise.bitwiseand(quartz.system.bitwise.rshift(size, 8), 0xff), quartz.system.bitwise.bitwiseand(size, 0xff)}

    -- update delegate

    self.task.delegate = function ()

        for _, client in pairs(self.task.clients) do
            if (not client.flashMemoryWriteRequested) then

                message[2] = client.device.radioProtocolId
                quartz.system.usb.sendmessage(self.handle, message)

                return false

            end
        end

        return true

    end

    -- acknowledge delegate

    self.task.acknowledge = function (addressee, command, arg)
        if (command == 0x82) then

            local client = self.task.clients[addressee]
            local address__ = quartz.system.bitwise.bitwiseor(quartz.system.bitwise.lshift(arg[1], 24), quartz.system.bitwise.lshift(arg[2], 16), quartz.system.bitwise.lshift(arg[3], 8), arg[4])

            if (client and (address == address__)) then client.flashMemoryWriteRequested = true
            end
        end
    end

end

-- Stage8_Write ---------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Stage8_Write(client)

    print("Stage8_Write")
    
    assert(self.task)
    assert(self.task.stage == 8)

    -- only firmware updates need a software reboot,
    -- initiated by yet another write request ...

    if not (self.task.address == 0x78000) then
        return self:NextStage(-1)
    end

    self.task.text = l "oth050" -- "Rebooting ..."
    self.task.progress = 20

    -- setup

    for _, client in pairs(self.task.clients) do
        client.flashMemoryWriteRequested = false
    end

    local message = { 0x05, 0xff, 0x83, 0x00, 0x00, 0x02, 0xee, 0xbb }

    -- update delegate

    self.task.delegate = function ()

        for _, client in pairs(self.task.clients) do
            if (not client.flashMemoryWriteRequested) then

                message[2] = client.device.radioProtocolId
                quartz.system.usb.sendmessage(self.handle, message)

                return false

            end
        end

        return true

    end

    -- acknowledge delegate

    self.task.acknowledge = function (addressee, command, arg)
        if (command == 0x83) then

            local client = self.task.clients[addressee]
            local offset = quartz.system.bitwise.bitwiseor(quartz.system.bitwise.lshift(arg[1], 8), arg[2])

            if (client and (offset == 2)) then client.flashMemoryWriteRequested = true
            end
        end
    end

end

-- Stage9_Boot ---------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Stage9_Boot(client)

    print("Stage9_Boot")
    
    assert(self.task)
    assert(self.task.stage == 9)

    -- only firmware updates need a software reboot,
    -- initiated by yet another write request ...

    if not (self.task.address == 0x78000) then
        return self:NextStage(-1)
    end

    self.task.text = l "oth051" -- "Rebooting ..."
    self.task.progress = 50

    -- setup

    for _, client in pairs(self.task.clients) do

        client.stage7_bootacknowledged = false

        -- add device reference to the whitelist,
        -- when the device is reboot it shall reconnect asap.

        local reference = tostring(client.device.reference)
        self.proxy:WhiteList(reference, client.device)

    end

    local message = { 0x00, 0xff, 0x06, }

    -- update delegate

    self.task.delegate = function ()

        for _, client in pairs(self.task.clients) do
            if (not client.stage7_bootacknowledged) then

                message[2] = client.device.radioProtocolId
                quartz.system.usb.sendmessage(self.handle, message)

                return false

            end
        end

        return true

    end

    -- acknowledge delegate

    self.task.acknowledge = function (addressee, command, arg)

        local device = self.proxy.devices.byRadioProtocolId[addressee]

        local client = self.task.clients[addressee]

        -- the connection gets acknowledged when the device is white-listed
        if (client and (command == 0x12)) then client.stage7_bootacknowledged = true
        end
    end

end

-- Upload --------------------------------------------------------------------

function ULUsbDevice.FlashMemoryManager:Upload(device, path, address)

    assert(device)
    assert(path)
    assert(address)

    -- lookup for existing task

    local task = nil

    for _, registeredTask in pairs(self.tasks) do
        if (registeredTask.path == path and registeredTask.address == address) then task = registeredTask break
        end
    end

    if (task) then

        -- discard dupplicated upload requests

        for _, client in pairs(task.clients) do
            if (client.device == device) then return
            end
        end

    else

        -- create new task

        task = {}

        task.path = path
        task.address = address;

        task.clients = {}

        -- register new task

        table.insert(self.tasks, task)

    end

    -- clients are indexed by their device's radio protocol id

    assert(device.radioProtocolId)
    task.clients[device.radioProtocolId] = { device = device }

    ---- promote task,
    ---- resume process
--
    --if (not self.task) then self.task = task
        --self:Resume()
    --end
--
    --if (self.task == task) then
        --self:Restart()
    --end

end
