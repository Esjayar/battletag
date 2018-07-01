
--[[--------------------------------------------------------------------------
--
-- File:            UIMenuManager.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 15, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIComponent"
require "Ui/UIMultiComponent"
require "Ui/UIMenuPage"
require "Ui/UIMenuWindow"
require "Ui/UIStack"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIMenuManager(UIPage)

UIMenuManager.stack = UIStack:New()

-- __ctor ------------------------------------------------------------------


function UIMenuManager:__ctor()
end

-- __dtor -------------------------------------------------------------------

function UIMenuManager:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UIMenuManager:Draw()

    --

    self.stack:Draw()

end

-- RegisterPickRegions -------------------------------------------------------

function UIMenuManager:RegisterPickRegions(regions, left, top)

    if (self.stack.top) then
        self.stack.top:RegisterPickRegions(regions, left, top)
    end

end

-- Update --------------------------------------------------------------------

function UIMenuManager:Update()

    self.stack:Update()

end
