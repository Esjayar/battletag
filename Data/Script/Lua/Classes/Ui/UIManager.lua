
--[[--------------------------------------------------------------------------
--
-- File:            UIManager.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 7, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIComponent"
require "Ui/UIMenuManager"
require "Ui/UIMultiComponent"
require "Ui/UIPage"
require "Ui/UIStack"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIManager(UTProcess)

UIManager.stack = UIStack:New()

UIManager.translation = { 0, 0 } 
UIManager.scale = 0

-- defaults

UIManager.fxs = {}

UIManager.fxUpdate = {}
UIManager.fxFonction = {}

UIManager.updateFrameRate = 60
UIManager.activeBackgroundBanner = false
UIManager.alphaBackgroundBanner = 0.0
UIManager.uiBackgroundBanner = nil
UIManager.drawBackground = false

-- __ctor --------------------------------------------------------------------

function UIManager:__ctor(...)

    -- tip drawing system

    self.tip = nil
    self.drawTips = {

        enabled = true,
        rectangle = { 90, 672, 870, 720 },
        font = UIComponent.fonts.default,
        fontColor = UIComponent.colors.white,
        fontJustification = quartz.system.drawing.justification.top + quartz.system.drawing.justification.center + quartz.system.drawing.justification.wordbreak,

    }

    -- background interface, ie. the menu manager

    self.stack:Push("UIMenuManager")

end

-- __dtor --------------------------------------------------------------------

function UIManager:__dtor()
end

-- AddFx ------------------------------------------------------------------------

function UIManager:AddFx(typefx, data)
	
	local time = quartz.system.time.gettimemicroseconds()
	local fx = nil
	
	if (typefx == "position" and type(data.__self) == "table" and data.__self.__type == "instance" and data.__self:IsKindOf(UIComponent)) then

    	fx = { typefx = typefx, timeStart = time, duration = data.duration or 1, __self = data.__self, from = data.from, to = data.to, timeOffset = (data.timeOffset or 0)* 1000000, type = data.type or "linear" }
		self.fxs[fx] = fx

	end
	
	if (typefx == "value" ) then

		fx = { typefx = typefx, timeStart = time, duration = data.duration or 1, __self = data.__self, value = data.value or "", from = data.from, to = data.to, timeOffset = (data.timeOffset or 0)* 1000000, type = data.type or "linear" }
		self.fxs[fx] = fx

	end
	
	if (typefx == "callback" and data.__function ~= nil and type(data.__function) == "function") then
		
		fx = { __function = data.__function, params = data.params or "",typefx = typefx, timeStart = time, timeOffset = (data.timeOffset or 0)* 1000000, type = data.type or "linear"  }
		self.fxs[fx] = fx
			
	end

	return fx

end

-- Char ----------------------------------------------------------------------

function UIManager:Char(char)
		
end

-- Draw ----------------------------------------------------------------------

function UIManager:Draw()
    
    if (UIManager.drawBackground == true) then
		quartz.system.drawing.pushcontext()

		quartz.system.drawing.loadtranslation(UIManager.translation[1], UIManager.translation[2])
		quartz.system.drawing.loadscale(UIManager.scale)

		local desktopWidth
		local desktopHeight
	   
		desktopWidth, desktopHeight = quartz.system.drawing.getviewportdimensions()
		self.rectangle = { 0, 0, desktopWidth, desktopHeight }
	    
		quartz.system.drawing.pushcontext()
		quartz.system.drawing.loadidentity()

		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
		quartz.system.drawing.loadtexture("base:texture/ui/background01.tga") 
		quartz.system.drawing.drawtexture(unpack(self.rectangle))

		quartz.system.drawing.pop()	
	end

    if (self.uiBackgroundBanner) then

		quartz.system.drawing.loadalpha(UIManager.alphaBackgroundBanner)
		self.uiBackgroundBanner:Draw()
		quartz.system.drawing.loadalpha(1)

    end

    UIManager.stack:Draw()

    if (self.tip and self.drawTips.enabled) then

        quartz.system.drawing.loadfont(self.drawTips.font)
        quartz.system.drawing.loadcolor3f(unpack(self.drawTips.fontColor))
        quartz.system.drawing.drawtextjustified(self.tip, self.drawTips.fontJustification, unpack(self.drawTips.rectangle))

    end

	quartz.system.drawing.pop()

end

-- fxFonction.accelerate -----------------------------------------------------

UIManager.fxFonction.accelerate = function (from, to, ratetime)

	return (1 - ratetime) * (ratetime + 1) * from + (1 - (1 - ratetime) * (ratetime + 1)) * to  
	
end

-- fxFonction.descelerate ----------------------------------------------------

UIManager.fxFonction.descelerate = function (from, to, ratetime)

	return (1 - ratetime * (2 - ratetime)) * from + ratetime * (2 - ratetime) * to  
	
end

-- fxFonction.linear ---------------------------------------------------------

UIManager.fxFonction.linear = function (from, to, ratetime)

	return (1 - ratetime) * from + ratetime * to
	
end

-- fxFonction.blink ----------------------------------------------------------

UIManager.fxFonction.blink = function (from, to, ratetime)

	if (ratetime < 0.5) then
	
		return from
		
	else
	
		return to
	end
end


-- fxUpdate.position ---------------------------------------------------------

UIManager.fxUpdate.position = function (self, fx)

	local time = quartz.system.time.gettimemicroseconds()
	local ratetime = (time - fx.timeOffset - fx.timeStart) / (fx.duration * 1000000)
	
	if (ratetime >= 0 and ratetime < 1) then
	
		local newX = UIManager.fxFonction[fx.type](fx.from[1], fx.to[1], ratetime)
		local newY = UIManager.fxFonction[fx.type](fx.from[2], fx.to[2], ratetime)
		
		fx.__self:MoveTo(newX, newY)
		
	end
	
	if (ratetime >= 1) then
    
		fx.__self:MoveTo(fx.to[1], fx.to[2])
		
		if (fx.type == "blink") then
		
			fx.timeOffset = fx.timeOffset + fx.duration* 1000000
		
		else
		
			return true
			
		end
		
	end   
	
	return false
end

-- fxUpdate.value ------------------------------------------------------------

UIManager.fxUpdate.value = function (self, fx)

	local time = quartz.system.time.gettimemicroseconds()
	local ratetime = (time - fx.timeOffset - fx.timeStart) / (fx.duration * 1000000)
	
	if (ratetime >= 0 and ratetime < 1) then
	
		local newValue = UIManager.fxFonction[fx.type](fx.from, fx.to, ratetime)
		
		fx.__self[fx.value] = newValue;
		
	end
	
	if (ratetime >= 1) then
    
		fx.__self[fx.value] = fx.to;
		
		if (fx.type == "blink") then
		
			fx.timeOffset = fx.timeOffset + fx.duration * 1000000
		
		else
		
			return true
			
		end
		
	end   
	
	return false
end

-- fxUpdate.callback ---------------------------------------------------------

UIManager.fxUpdate.callback = function (self, fx)

	local time = quartz.system.time.gettimemicroseconds()
	local timeLeft = (time - fx.timeOffset - fx.timeStart)
	
	if (timeLeft >= 0) then
    
		fx.__function(fx.params);
		return true
		
	end   
	
	return false
end

-- KeyDown -------------------------------------------------------------------

function UIManager:KeyDown(virtualKeyCode, scanCode)
		
end

-- MouseMove ----------------------------------------------------------------------

function UIManager:MouseMove(control, x, y)

	x = x - UIManager.translation[1]
	y = y - UIManager.translation[2]
	x = x / UIManager.scale
	y = y / UIManager.scale

	UIManager.stack:MouseMove(control, x , y)

end

-- OnResumed -----------------------------------------------------------------

function UIManager:OnResumed()

    if (game) then

		local desktopWidth, desktopHeight
		local rateDesktop
		local rateBase

		desktopWidth, desktopHeight = quartz.system.drawing.getviewportdimensions()

		rateDesktop = desktopHeight / desktopWidth
		rateBase = 720 / 960

		if (rateDesktop > rateBase) then

		    UIManager.scale = desktopWidth / 960
		    UIManager.translation[2] = (desktopHeight - UIManager.scale * 720) / 2.

		else

		    UIManager.scale = desktopHeight / 720
		    UIManager.translation[1] = (desktopWidth - UIManager.scale * 960) / 2.
		    
		end
	
        game._Draw:Add(self, UIManager.Draw)

        game._Char:Add(UIManager.stack, UIManager.Char)
        game._KeyDown:Add(UIManager.stack, UIManager.KeyDown)
        game._MouseMove:Add(UIManager.stack, UIManager.MouseMove)

        game._MouseButtonDown:Add(UIManager.stack, UIStack.MouseButtonDown)
        game._MouseButtonUp:Add(UIManager.stack, UIStack.MouseButtonUp)

    end

    UTProcess.OnResumed(self)

end

-- OnSuspended ---------------------------------------------------------------

function UIManager:OnSuspended()

    if (game) then
        game._Draw:Remove(self, UIManager.Draw)
    end

    UTProcess.OnSuspended(self)

end

-- RemoveFx -----------------------------------------------------------------

function UIManager:RemoveFx(fx)
	
        self.fxs[fx] = nil
	
end

-- Update --------------------------------------------------------------------

function UIManager:OnUpdate()
	
	UIManager.uiBackgroundBanner = UIManager.uiBackgroundBanner or UIBackgroundBanner:New()

    for index, fx in pairs(self.fxs) do

		if (UIManager.fxUpdate[fx.typefx](self, fx)) then
			self.fxs[fx] = nil
		end

    end

    if ((not activity) and (UIManager.activeBackgroundBanner == true)) then
		UIManager:StopBackgroundBanner()
	elseif (activity and (UIManager.activeBackgroundBanner == false)) then
		UIManager:StartBackgroundBanner()
	end

    if (self.uiBackgroundBanner) then
		self.uiBackgroundBanner:Update()
	end

    UIManager.stack:Update()

end

-- StartBackgroundBanner --------------------------------------------------------------------

function UIManager:StartBackgroundBanner()

	if (self.alphaFx) then

		UIManager:RemoveFx(self.alphaFx)

	end

	UIManager.uiBackgroundBanner = UIManager.uiBackgroundBanner or UIBackgroundBanner:New()	
	UIManager.uiBackgroundBanner.positionBanner = {self.viewportWidth or 1600, 100}
	UIManager.uiBackgroundBanner.timer = quartz.system.time.gettimemicroseconds()
	
	if (activity) then
	
		UIManager.uiBackgroundBanner:SetText(activity.name)
		UIManager.uiBackgroundBanner.iconBanner = activity.iconBanner
		
	end
	
	UIManager.activeBackgroundBanner = true
	UIManager.alphaBackgroundBanner = 1

end

-- StopBackgroundBanner --------------------------------------------------------------------

function UIManager:StopBackgroundBanner()

	UIManager.activeBackgroundBanner = false
	self.alphaFx = UIManager:AddFx("value", { duration = 1, __self = self, value = "alphaBackgroundBanner", from = 1, to = 0, })

end

