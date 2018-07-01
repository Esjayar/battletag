
--[[--------------------------------------------------------------------------
--
-- File:            UIClosingWindow.lua
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

require "Ui/UIComponent"
require "Ui/UIMultiComponent"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIClosingWindow(UIMultiComponent)

-- defaults

-- __ctor -------------------------------------------------------------------

function UIClosingWindow:__ctor(...)

	-- get viewport info

	self.viewportWidth, self.viewportHeight = quartz.system.drawing.getviewportdimensions()
	self.viewportHeight = self.viewportHeight * 0.5

	-- closing/opening events

	self._WindowOpened = UTEvent:New()
	self._WindowClosed = UTEvent:New()

	-- animation information

	self.wantedAcc = 0.0
	self.scale = 1

end

-- __dtor -------------------------------------------------------------------

function UIClosingWindow:__dtor()
end

-- build -------------------------------------------------------------------

function UIClosingWindow:Build(topTexture, bottomTexture)

	-- windows texture

	self.topTexture = topTexture
	self.bottomTexture = bottomTexture

	-- get texture dimension

	quartz.system.drawing.loadtexture(self.topTexture)
	local textureWidth, textureHeight = quartz.system.drawing.gettexturedimensions()

	-- compute real position

    self.scale = self.viewportHeight / textureHeight
	self.topRectangle = { 0.0, -self.viewportHeight, textureWidth, 0}
    self.topRectangle[1] = (self.viewportWidth - self.scale * textureWidth) / 2.0
    self.topRectangle[3] = self.topRectangle[1] + textureWidth * self.scale
	self.bottomRectangle = {self.topRectangle[1], 2.0 * self.viewportHeight, self.topRectangle[3], 3.0 * self.viewportHeight }

end

-- Close Window -------------------------------------------------------------------

function UIClosingWindow:CloseWindow()

	quartz.framework.audio.loadsound("base:audio/ui/closewindow.wav")
	quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
	quartz.framework.audio.playsound()
	
	-- animation

	self.acc = 0.0	
	self.wantedAcc = 0.0008
	self.wantedPos = 0.0
	self.side = 1
	self.scale = 1

end

-- Draw ---------------------------------------------------------------------

function UIClosingWindow:Draw()

	-- MultiComponent draw

	UIMultiComponent.Draw(self)	
	
	-- draw top
	quartz.system.drawing.pushcontext()

	quartz.system.drawing.loadidentity()
	
	quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
	quartz.system.drawing.loadtexture(self.topTexture )
	quartz.system.drawing.drawtexture(unpack(self.topRectangle))

	-- draw bottom

	quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
	quartz.system.drawing.loadtexture(self.bottomTexture )
	quartz.system.drawing.drawtexture(unpack(self.bottomRectangle))

	quartz.system.drawing.pop()		

end

-- OnWindowOpened ------------------------------------------------------------

function UIClosingWindow:OnWindowOpened()

    self._WindowOpened:Invoke(self)

end

-- OnWindowClosed ------------------------------------------------------------

function UIClosingWindow:OnWindowClosed()

    self._WindowClosed:Invoke(self)

end

-- Open Window -------------------------------------------------------------------

function UIClosingWindow:OpenWindow()

	quartz.framework.audio.loadsound("base:audio/ui/openwindow.wav")
	quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
	quartz.framework.audio.playsound()

	self.acc = 0.0	
	self.wantedAcc = 0.001
	self.wantedPos = -self.viewportHeight
	self.side = -1

end

-- Update -------------------------------------------------------------------

function UIClosingWindow:Update(elapsedTime)

	-- window animation

	if (self.wantedAcc > 0.0) then

		local speed
		self.acc = self.acc + math.min(self.wantedAcc - self.acc, 0.00005 * elapsedTime)
		speed = self.side * math.min(math.abs(self.wantedPos - self.topRectangle[2]), self.acc * elapsedTime)
		
		--if ((speed == 0) and (self.acc >= self.wantedAcc)) then
		if (self.wantedPos == self.topRectangle[2]) then

			if (self.side > 0) then
				self:OnWindowClosed()	
			else
				self:OnWindowOpened()	
			end
			self.wantedAcc = 0.0		

		else

			self.topRectangle[2] = self.topRectangle[2] + speed
			self.topRectangle[4] = self.topRectangle[4] + speed
			self.bottomRectangle[2] = self.bottomRectangle[2] - speed
			self.bottomRectangle[4] = self.bottomRectangle[4] - speed

		end

	end

end