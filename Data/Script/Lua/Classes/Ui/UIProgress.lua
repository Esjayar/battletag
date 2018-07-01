
--[[--------------------------------------------------------------------------
--
-- File:            UIProgress.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 13, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UIProgress(UIComponent)

-- defaults

-- UIProgress.color = UIComponent.colors.orange

UIProgress.fontColor = UIComponent.colors.white
UIProgress.font = UIComponent.fonts.default
UIProgress.fontJustification = quartz.system.drawing.justification.center + quartz.system.drawing.justification.singlelineverticalcenter

UIProgress.rectangle = { 0, 0, 100, 24 }

-- __ctor -------------------------------------------------------------------

function UIProgress:__ctor()

    self.minimum = 0
    self.maximum = 100.0
    
    self.progress = 0
    self.value = 0

end

-- Draw ---------------------------------------------------------------------

function UIProgress:Draw()

    if (self.rectangle) then

	    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.lightgray))
	    quartz.system.drawing.loadtexture("base:texture/ui/components/uipanel01.tga")
	    quartz.system.drawing.drawwindow(unpack(self.rectangle))

        if (0 < self.progress) then

            local decal = 0.5 * (self.rectangle[4] - self.rectangle[2] - 12)
            local ratio = math.max(16, self.rectangle[3] - self.rectangle[1] - decal)

	        quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
	        quartz.system.drawing.loadtexture("base:texture/ui/loadinggrey.tga")
	        quartz.system.drawing.drawwindow(self.rectangle[1] + decal, self.rectangle[2] + decal, self.rectangle[3] - decal, self.rectangle[4] - decal)

	        if (self.color) then quartz.system.drawing.loadcolor3f(unpack(self.color))
	        else quartz.system.drawing.loadtexture("base:texture/ui/loadingorange.tga")
	        end

	        quartz.system.drawing.drawwindow(self.rectangle[1] + decal, self.rectangle[2] + decal, self.rectangle[1] + ratio * self.progress * 0.01, self.rectangle[4] - decal)

        end
    end
    	
end

-- SetProgress --------------------------------------------------------------

function UIProgress:SetProgress(progress)

    self.progress =  math.max(math.min(100.0, math.max(0, progress)),5)

end

-- SetValue ------------------------------------------------------------------

function UIProgress:SetValue(value)

    self.value = math.min(self.maximum, math.max(self.minimum, value))
    self.progress = 100.0 * self.value / (self.maximum - self.minimum)

end
