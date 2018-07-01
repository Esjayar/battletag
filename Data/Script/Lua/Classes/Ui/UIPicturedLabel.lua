
--[[--------------------------------------------------------------------------
--
-- File:            UIPicturedLabel.lua
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

--[[ Class -----------------------------------------------------------------]]

UTClass.UIPicturedLabel(UILabel)

--default

UIPicturedLabel.texture = "base:texture/ui/components/uiradiobutton_on.tga"
UIPicturedLabel.text = "UIPicturedLabel"

-- __ctor ------------------------------------------------------------------

function UIPicturedLabel:__ctor()
    
    
end

-- __dotr ------------------------------------------------------------------

function UIPicturedLabel:__dtor()
end

-- Draw --------------------------------------------------------------------

function UIPicturedLabel:Draw()

    if (self.rectangle) then
        
        quartz.system.drawing.loadcolor4f(unpack(self.color))
	    quartz.system.drawing.loadtexture(self.texture)
		quartz.system.drawing.drawtexture(unpack(self.rectangle))
    
    end
    
    UILabel.Draw(self)
    
end