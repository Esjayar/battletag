
--[[--------------------------------------------------------------------------
--
-- File:            UITitledPanel.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 3, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UITitledPanel(UIMultiComponent)

-- defaults

UITitledPanel.header = "base:texture/ui/components/uipanel03.tga"
UITitledPanel.background = "base:texture/ui/components/uipanel01.tga"

UITitledPanel.title = "UITitledPanel"
UITitledPanel.fontPosition = 10
UITitledPanel.fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter
UITitledPanel.fontColor = UIComponent.colors.orange
UITitledPanel.headerSize = 25

-- __ctor ------------------------------------------------------------------

function UITitledPanel:__ctor(title)

    self.title = title

end

-- __dtor -------------------------------------------------------------------

function UITitledPanel:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UITitledPanel:Draw()

    if (self.rectangle) then

        if (self.background) then

            quartz.system.drawing.loadcolor3f(unpack(self.colors.white))
            quartz.system.drawing.loadtexture(self.background)
            quartz.system.drawing.drawwindow(unpack(self.rectangle))

        end

        if (self.header) then

            local rectangle = { self.rectangle[1], self.rectangle[2], self.rectangle[3], self.rectangle[2] + self.headerSize }

            quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
            quartz.system.drawing.loadtexture(self.header)
            quartz.system.drawing.drawwindow(unpack(rectangle))

            if (self.title) then

    	   	    rectangle[1] = rectangle[1] + self.fontPosition

    	        quartz.system.drawing.loadfont(UIComponent.fonts.header)
                quartz.system.drawing.loadcolor3f(unpack(self.fontColor))
                quartz.system.drawing.drawtextjustified(self.title, self.fontJustification, unpack(rectangle))

            end        
        end

        UIComponent.Draw(self)

	 end

end