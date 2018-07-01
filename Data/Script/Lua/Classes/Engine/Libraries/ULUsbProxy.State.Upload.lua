
--[[--------------------------------------------------------------------------
--
-- File:            ULUsbProxy.State.Upload.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 14, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

ULUsbProxy.State.Upload = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function ULUsbProxy.State.Upload:__ctor(device, ...)

    assert(device and device:IsKindOf(ULUsbProxy))

    self.proxy = device
    self.handle = self.proxy.handle

end

-- Begin ---------------------------------------------------------------------

function ULUsbProxy.State.Upload:Begin()

    print("ULUsbProxy.State.Upload:Begin")

    assert(not self.proxy.revision)
    assert(not self.proxy.initialized)
    
    self.updateFrameRate = engine.libraries.usb.updateFrameRate
    
    -- check for revision

    self.proxy.revisionCandidate = nil

    assert(self.proxy.reference)

    local class = quartz.system.bitwise.bitwiseand(self.proxy.reference[1], 0x0f00fff0)
    local directory = string.format("game:../system/revision/0x%08x", class)

    local revisions = quartz.system.filesystem.directory(directory , "*.bin")
    print(directory, "*.bin", revisions)
    if (revisions) then

        -- lookup most recent revision

        for i, path in ipairs(revisions) do

            local revision = string.lower(path)
            local offset = string.find(revision, '/', 1, true)
            while (offset) do
                revision = string.sub(revision, offset + 1)
                offset = string.find(revision, '/', 1, true)
            end

            offset = string.find(revision, '.bin', 1, true)
            revision = string.sub(revision, 1, offset - 1)

            -- revision candidates are checked against the game's major
            
            local lowerRevision = string.format("0x%04x0000", REG_MAJORREVISION)
            local upperRevision = string.format("0x%04x0000", REG_MAJORREVISION + 1)

            if (lowerRevision <= revision and revision < upperRevision) then

                -- we have a revision candidate here

                if (not self.proxy.revisionCandidate or (self.proxy.revisionCandidate.revision < revision)) then
                    self.proxy.revisionCandidate = { revision = revision, path = path }
                    print("we have a revision candidate here " .. self.proxy.revisionCandidate.revision)
                    print(self.proxy.revisionCandidate.path)
                end
            end
        end
    end

    if (self.proxy.revisionCandidate) then

        print("revision candidate: ", self.proxy.revisionCandidate.revision)
        self.proxy.revisionCandidate.checked = quartz.system.usb.loadbinary(self.proxy.revisionCandidate.path)

    else
        print("we have a problem... all revision candidates were discarded!")
    end

    -- boost usb process,
    -- shall decrease upload duration by a magnitude

    engine.libraries.usb:SetUpdateFrameRate(30)

end

-- End -----------------------------------------------------------------------

function ULUsbProxy.State.Upload:End()

    print("ULUsbProxy.State.Upload:End")

    engine.libraries.usb:SetUpdateFrameRate(self.updateFrameRate)

end

-- OnProcessMessage ----------------------------------------------------------

function ULUsbProxy.State.Upload:OnProcessMessage(device, addressee, command, arg)

    assert(device == self.proxy)

    if (command == 0x04) then

        self:OnRevision()

    end    

end

-- Update --------------------------------------------------------------------

function ULUsbProxy.State.Upload:Update()

    if (self.proxy.revisionCandidate.checked) then

        if (self.proxy.revisionCandidate.checked == self.proxy.revisionUpdate) then
            print("upload complete! " .. self.proxy.revisionUpdate .. " / " .. self.proxy.revisionCandidate.checked)
            quartz.system.usb.sendmessage(self.handle, { 0x00, 0x00, 0x02 })
            self.proxy:PostStateChange()
        else
            print("upload ... " .. self.proxy.revisionUpdate .. " / " .. self.proxy.revisionCandidate.checked)
            quartz.system.usb.upload(self.handle, self.proxy.revisionUpdate)
        end

    end
end