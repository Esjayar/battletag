
--[[--------------------------------------------------------------------------
--
-- File:            UIPage.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 7, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UIPage(UIMultiComponent)

-- defaults

UIPage.rectangle = { 0, 0, 960, 720 }
UIPage.transparent = false
UIPage.slideBegin = false
UIPage.slideEnd   = false

-- __ctor --------------------------------------------------------------------

function UIPage:__ctor(...)

    self.loaded = false
    self.opened = false

    -- events

    self._Closed = UTEvent:New()
    self._Closing = UTEvent:New()

end

-- __dtor --------------------------------------------------------------------

function UIPage:__dtor()
end

-- Close ---------------------------------------------------------------------

function UIPage:Close()
	
	self:Focus(false)

	if (self.opened) then

		self._Closing:Invoke(self)

		self.opened = false
		self.visible = false

		self:OnClose()
		self._Closed:Invoke(self)
	
	end

	--if (self.slideEnd == true) then
		--self.slideEndFx = UIManager:AddFx("position", { duration = 0.8, __self = self, from = {0, self.rectangle[2]}, to = { -1100, self.rectangle[2]}, type = "accelerate" })
	--end

--[[
if (REG_TRACKING) then
        local currentTime = quartz.system.time.gettimemicroseconds()
        local elapsedTime = currentTime - self.timer
        if (2000000 <= elapsedTime) then
        end
end
--]]


end

-- Load ----------------------------------------------------------------------

-- occurs before the page is displayed for the first time

function UIPage:Load()
end

-- OnClose -------------------------------------------------------------------

function UIPage:OnClose()

end

-- OnOpen --------------------------------------------------------------------

function UIPage:OnOpen()

end

-- Open ----------------------------------------------------------------------

function UIPage:Open()

	if (self.slideBegin) then

		self.mvtFx = UIManager:AddFx("position", { duration = 0.75, __self = self, from = { 1100, self.rectangle[2]}, to = { 0, self.rectangle[2] }, type = "descelerate" })
		self:MoveTo(1100, self.rectangle[2])

	end
	self.closingMvt = false

    if (not self.opened) then

        if (not self.loaded) then

            self:Load()
            self.loaded = true

        end

        self:OnOpen()
        self.opened = true

--[[
if (REG_TRACKING) then
        self.timer = quartz.system.time.gettimemicroseconds()
end
--]]

    end

    self.visible = true
    self:Focus(true)

end

-- Update --------------------------------------------------------------------

function UIPage:Update()
end
