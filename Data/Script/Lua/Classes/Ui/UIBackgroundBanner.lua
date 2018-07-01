
--[[--------------------------------------------------------------------------
--
-- File:            UIBackgroundBanner.lua
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

UTClass.UIBackgroundBanner(UIMultiComponent)

-- defaults

UIBackgroundBanner.fontColor = UIComponent.colors.backcolor
UIBackgroundBanner.font = UIComponent.fonts.backgroundBanner
UIBackgroundBanner.fontJustification = quartz.system.drawing.justification.topleft
UIBackgroundBanner.text = nil
UIBackgroundBanner.width = 128
UIBackgroundBanner.margin = 260
UIBackgroundBanner.defaultIcon = "base:texture/ui/Ranking_Bg_Star.tga"

-- __ctor ------------------------------------------------------------------

function UIBackgroundBanner:__ctor()

	-- timer

	self.timer = quartz.system.time.gettimemicroseconds()

	-- full size

	self.viewportWidth, self.viewportHeight = quartz.system.drawing.getviewportdimensions()
	self.sizeOffset = 1600

    quartz.system.drawing.loadtexture("base:texture/ui/Ranking_Bg.tga")
    self.width, self.height = quartz.system.drawing.gettexturedimensions()
	-- init pos

	self.positionBanner = {1600, 100}

end

-- __dtor -------------------------------------------------------------------

function UIBackgroundBanner:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UIBackgroundBanner:Draw()

	if (activity) then
	
		local color = self.color or UIComponent.colors.white

		-- banner BOTTOM

		quartz.system.drawing.loadcolor3f(unpack(color))
		quartz.system.drawing.loadtexture("base:texture/ui/Ranking_Bg_bottom.tga")
		quartz.system.drawing.drawtexture(self.positionBanner[1], 470)
		
		-- banner UP

		quartz.system.drawing.loadcolor3f(unpack(color))
		quartz.system.drawing.loadtexture("base:texture/ui/Ranking_Bg_top.tga")
		quartz.system.drawing.drawtexture(self.positionBanner[1] + self.width - 1460, 60)
			
		if (self.text ~= activity.name) then
		
			self:SetText(activity.name)

		end
		quartz.system.drawing.loadcolor3f(unpack(self.fontColor))
		quartz.system.drawing.loadfont(self.font or self.fonts.default)
		local rectangleText = { self.positionBanner[1] + UIBackgroundBanner.margin, self.positionBanner[2] + 100 }
		quartz.system.drawing.drawtext(self.text, unpack(rectangleText))

	
		-- banner STAR

		quartz.system.drawing.loadcolor3f(unpack(color))
		quartz.system.drawing.loadtexture(activity and activity.iconBanner or UIBackgroundBanner.defaultIcon)
		quartz.system.drawing.drawtexture(self.positionBanner[1], self.positionBanner[2] + 120)
		quartz.system.drawing.drawtexture(self.positionBanner[1] + self.width + UIBackgroundBanner.margin, self.positionBanner[2] + 120)
			
	end
	
end

-- SetText -------------------------------------------------------------------

function UIBackgroundBanner:SetText(text)

    self.text = text
    if (text) then

        quartz.system.drawing.loadfont(self.font or self.fonts.default)
    	local width, height = quartz.system.drawing.gettextdimensions(text, self.fontJustification or 0)

        self.width = width / UIManager.scale
        
	end

end

-- Update --------------------------------------------------------------------

function UIBackgroundBanner:Update()

	local elapsedTime = quartz.system.time.gettimemicroseconds() - self.timer
	self.timer = quartz.system.time.gettimemicroseconds()

	-- movement

	self.positionBanner[1] = self.positionBanner[1] - (0.0004 * elapsedTime)

	-- when out of screen, then must restart

	if (self.positionBanner[1] < - self.width - 4 * UIBackgroundBanner.margin) then
		self.positionBanner[1] = self.sizeOffset 
	end

end