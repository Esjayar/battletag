
--[[--------------------------------------------------------------------------
--
-- File:            UIPanel.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 13, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UIPanel(UIMultiComponent)

-- defaults

UIPanel.background = "base:texture/ui/components/uipanel04.tga"

-- __ctor ------------------------------------------------------------------

function UIPanel:__ctor()
end

-- __dtor -------------------------------------------------------------------

function UIPanel:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UIPanel:Draw()

   if (self.rectangle) then

        if (self.background) then

			local color = self.color or UIComponent.colors.white

            if (4 == #color) then quartz.system.drawing.loadcolor4f(unpack(color))
            else quartz.system.drawing.loadcolor3f(unpack(color))
            end

            quartz.system.drawing.loadtexture(self.background)
            quartz.system.drawing.drawwindow(unpack(self.rectangle))

        end

        UIComponent.Draw(self)

	 end

end
