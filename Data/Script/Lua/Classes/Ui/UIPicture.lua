
--[[--------------------------------------------------------------------------
--
-- File:            UIPicture.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 16, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UIPicture(UIComponent)

-- default

UIPicture.texture = nil

-- __ctor ------------------------------------------------------------------

function UIPicture:__ctor()
end

-- __dtor ------------------------------------------------------------------

function UIPicture:__dtor()
end

-- Draw --------------------------------------------------------------------

function UIPicture:Draw()

    if (self.rectangle) then
        
        local color = self.color or UIComponent.colors.white
                
        if (#color == 4) then
			quartz.system.drawing.loadcolor4f(unpack(color))
	    else
			quartz.system.drawing.loadcolor3f(unpack(color))
	    end
        quartz.system.drawing.loadtexture(self.texture)
        quartz.system.drawing.drawtexture(unpack(self.rectangle))
        
    end

end