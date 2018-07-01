
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.Ui.Basics.Principle.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 2, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIOption"
require "Ui/UIPanel"
require "Ui/UITitledPanel"
require "Ui/UIArrowLeft"
require "Ui/UIArrowRight"

--[[ Class -----------------------------------------------------------------]]

assert(UTGame.Ui.Basics)
UTGame.Ui.Basics.Principle = UTClass(UITitledPanel)

-- __ctor --------------------------------------------------------------------

function UTGame.Ui.Basics.Principle:__ctor(slide)

	self.slide = slide
	self.slideIndex = 1
	
	if (#self.slide.bitmaps > 1) then

		--  uiButtonleft	    

		self.uiButtonleft = self:AddComponent(UIArrowLeft:New(), "uiButtonleft")
		self.uiButtonleft:MoveTo(20,213)

		self.uiButtonleft.OnAction = function (_self) 

			quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
			quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
			quartz.framework.audio.playsound()

			self.slideIndex = self.slideIndex - 1

			if (self.slideIndex < 1) then
				self.slideIndex = #self.slide.bitmaps
			end

		end

		--  uiButtonright

		self.uiButtonright = self:AddComponent(UIArrowRight:New(), "uiButtonright")
		self.uiButtonright:MoveTo(320,213)

		self.uiButtonright.OnAction = function (_self) 
	    
			quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
			quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
			quartz.framework.audio.playsound()
			
			self.slideIndex = self.slideIndex + 1
			
			if (self.slideIndex > #self.slide.bitmaps) then
				self.slideIndex = 1
			end
		end    

	end
	
end

-- Draw --------------------------------------------------------------------

function UTGame.Ui.Basics.Principle:Draw()

	UITitledPanel.Draw(self)

    --

    if (self.slide) then

        if (self.slide.bitmaps and self.slide.bitmaps[self.slideIndex]) then
            quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
            quartz.system.drawing.loadtexture(self.slide.bitmaps[self.slideIndex])
            quartz.system.drawing.drawtexture(unpack(self.rectangleBitmap))
        end

        if (self.slide.texts and self.slide.texts[self.slideIndex]) then
            quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
            quartz.system.drawing.loadfont(UIComponent.fonts.default)
            quartz.system.drawing.drawtextjustified(self.slide.texts[self.slideIndex], quartz.system.drawing.justification.wordbreak, unpack(self.rectangleText)) 
        end
    end

end
