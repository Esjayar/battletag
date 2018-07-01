
--[[--------------------------------------------------------------------------
--
-- File:            UIBanner.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 20, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UIBanner(UIMultiComponent)

-- defaults

UIBanner.fontColor = UIComponent.colors.white
UIBanner.font = UIComponent.fonts.header
UIBanner.fontJustification = quartz.system.drawing.justification.topleft
UIBanner.text = nil
UIBanner.width = 128
UIBanner.margin = 20

-- __ctor ------------------------------------------------------------------

function UIBanner:__ctor()

	-- timer

	self.timer = quartz.system.time.gettimemicroseconds()

	-- full size

	self.viewportWidth, self.viewportHeight = quartz.system.drawing.getviewportdimensions()
	self.sizeOffset = (self.viewportWidth - 960) / 2

	-- init pos

	self.position = { 960 + self.sizeOffset, 15 }

end

-- __dtor -------------------------------------------------------------------

function UIBanner:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UIBanner:Draw()

    if (self.text) then

	    local color = self.color or UIComponent.colors.white

	    -- banner LEFT

	    quartz.system.drawing.loadcolor3f(unpack(color))
        quartz.system.drawing.loadtexture("base:texture/ui/TopBorderLeft.tga")
        local rectangleLeft = { self.position[1], self.position[2], self.position[1] + 64, self.position[2] + 32 }
        quartz.system.drawing.drawtexture(unpack(rectangleLeft))

	    -- banner LINE

        quartz.system.drawing.loadtexture("base:texture/ui/TopBorderLine.tga")
        local rectangleLine = { self.position[1] + 64 - 4, self.position[2], self.position[1] + 64 + self.width + 4, self.position[2] + 32 }
        quartz.system.drawing.drawtexture(unpack(rectangleLine))

	    -- banner RIGHT

        quartz.system.drawing.loadtexture("base:texture/ui/TopBorderRight.tga")
        local rectangleRight = { self.position[1] + 64 + self.width, self.position[2], self.position[1] + 128 + self.width, self.position[2] + 32 }
        quartz.system.drawing.drawtexture(unpack(rectangleRight))

	    -- text
    		
	    quartz.system.drawing.loadcolor3f(unpack(self.fontColor))
	    quartz.system.drawing.loadfont(self.font or self.fonts.default)
	    local rectangleText = { self.position[1] + 64 + UIBanner.margin, self.position[2] + 5 }
	    quartz.system.drawing.drawtext(self.text, unpack(rectangleText))
	
    end

end

-- SetText -------------------------------------------------------------------

function UIBanner:SetText(text)

    self.text = text
    if (text) then

        quartz.system.drawing.loadfont(self.font or self.fonts.default)
    	local width, height = quartz.system.drawing.gettextdimensions(text, self.fontJustification or 0)

        self.width = width + (2 * self.margin)

	end

end

-- Update --------------------------------------------------------------------

function UIBanner:Update()

	local elapsedTime = quartz.system.time.gettimemicroseconds() - self.timer
	self.timer = quartz.system.time.gettimemicroseconds()

	-- movement

	self.position[1] = self.position[1] - (0.0002 * elapsedTime)

	-- when out of screen, then must restart

	if (self.position[1] < - (128 + self.width + self.sizeOffset)) then
		self.position[1] = 960 + self.sizeOffset
	end

end