
--[[--------------------------------------------------------------------------
--
-- File:            UIPopupLargeWindow.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            October 5, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIComponent"
require "Ui/UIMultiComponent"
require "Ui/UIPage"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIPopupLargeWindow(UIPage)

-- defaults

UIPopupLargeWindow.buttonRectangles = { 

    [1] = { 72, 474, 209, 504 },
    [2] = { 336, 474, 473, 504 },
}

UIPopupLargeWindow.rectangle = { 205, 60, 755, 660 }
UIPopupLargeWindow.size = { UIPopupLargeWindow.rectangle[3] - UIPopupLargeWindow.rectangle[1], UIPopupLargeWindow.rectangle[4] - UIPopupLargeWindow.rectangle[2] }
UIPopupLargeWindow.transparent = true

-- title

UIPopupLargeWindow.title = {

    font = UIComponent.fonts.title,
    fontColor = UIComponent.colors.orange,
    fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter,

    rectangle = { 303, 101, 603, 126 },
}

UIPopupLargeWindow.video = {

    default = "base:/video/uianimatedbutton_games.avi",
    rectangle = { 228, 88, 228 + 52, 88 + 52 },

}

-- __ctor -------------------------------------------------------------------

function UIPopupLargeWindow:__ctor(...)

	local desktopWidth
    local desktopHeight
   
    desktopWidth, desktopHeight = quartz.system.drawing.getviewportdimensions()
    self.backRectangle = { 0, 0, desktopWidth, desktopHeight }
    
    self.title = "UIPopupLargeWindow.title"
    self.clientRectangle = { 44, 110, 501, 246}

end

-- __dtor -------------------------------------------------------------------

function UIPopupLargeWindow:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UIPopupLargeWindow:Draw()

    assert(self.rectangle)

    -- background
    
    quartz.system.drawing.pushcontext()
    quartz.system.drawing.loadidentity();

    quartz.system.drawing.loadcolor4f(1.0, 1.0, 1.0, 0.9) -- 0.8
    quartz.system.drawing.loadtexture("base:texture/ui/background01.tga")
    quartz.system.drawing.drawtexture(unpack(self.backRectangle))

    quartz.system.drawing.pop()

    -- window

    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))	 
    quartz.system.drawing.loadtexture("base:texture/ui/components/uiwindow_popup_large.tga")
    quartz.system.drawing.drawtexture(unpack(self.rectangle))

    quartz.system.drawing.loadvideo(self.icon or UIWindow.video.default)
    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))	 
    quartz.system.drawing.drawvideo(unpack(self.video.rectangle)) 

    -- window title

    if (self.title) then

	    quartz.system.drawing.loadcolor3f(unpack(UIPopupLargeWindow.title.fontColor))
	    quartz.system.drawing.loadfont(UIPopupLargeWindow.title.font or UIComponent.fonts.title)
	    quartz.system.drawing.drawtextjustified(self.title, UIPopupLargeWindow.title.fontJustification, unpack(UIPopupLargeWindow.title.rectangle))

    end

    -- base

    UIMultiComponent.Draw(self)

end

-- OnOpen --------------------------------------------------------------------

function UIPopupLargeWindow:OnOpen()

    quartz.system.drawing.loadvideo(self.icon or UIWindow.video.default)
    quartz.system.drawing.playvideo(true) 

end
