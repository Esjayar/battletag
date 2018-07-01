
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

    if (not self.opened) then

        if (not self.loaded) then

            self:Load()
            self.loaded = true

        end

        self:OnOpen()
        self.opened = true

    end

    self.visible = true
    self:Focus(true)

end

-- Update --------------------------------------------------------------------

function UIPage:Update()
end
