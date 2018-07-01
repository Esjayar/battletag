
--[[--------------------------------------------------------------------------
--
-- File:            UILabel.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 12, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UILabel(UIComponent)

-- defaults

UILabel.fontColor = UIComponent.colors.white
UILabel.font = UIComponent.fonts.default
UILabel.fontJustification = quartz.system.drawing.justification.topleft

UILabel.text = ""
UILabel.rectangle = { 0, 0, 100, 20 }

-- __ctor -------------------------------------------------------------------

function UILabel:__ctor(rectangle, text)

    self.rectangle = rectangle
    self.text = text 

end

-- __dtor -------------------------------------------------------------------

function UILabel:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UILabel:Draw()

    if (self.rectangle) then

	    quartz.system.drawing.loadcolor3f(unpack(self.fontColor))
	    quartz.system.drawing.loadfont(self.font or self.fonts.default)

        if (2 == #self.rectangle) then

            quartz.system.drawing.drawtext(self.text, unpack(self.rectangle))

        elseif (4 == #self.rectangle) then

            quartz.system.drawing.drawtextjustified(self.text, self.fontJustification, unpack(self.rectangle)) 

        end
    end
    	
end