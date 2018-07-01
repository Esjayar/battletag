
--[[--------------------------------------------------------------------------
--
-- File:            UIPopupWindow.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 6, 2010
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

UTClass.UIPopupWindow(UIPage)

-- defaults

UIPopupWindow.buttonRectangles = { 

    [1] = { 92, 260, 229, 294 },
    [2] = { 316, 260, 453, 294 },
    [3] = { 200, 130, 337, 164 },
    [4] = { 200, 190, 337, 224 },
}

UIPopupWindow.rectangle = { 207, 168, 752, 552 }
UIPopupWindow.size = { UIPopupWindow.rectangle[3] - UIPopupWindow.rectangle[1], UIPopupWindow.rectangle[4] - UIPopupWindow.rectangle[2] }
UIPopupWindow.transparent = true

-- title

UIPopupWindow.title = {

    font = UIComponent.fonts.title,
    fontColor = UIComponent.colors.orange,
    fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter,

    -- 96, 33, 396, 58
    rectangle = { 303, 201, 603, 226 },
}

UIPopupWindow.video = {

    default = "base:/video/uianimatedbutton_games.avi",
    rectangle = { 228, 188, 228 + 52, 188 + 52 },

}

UIPopupWindow.iconTexture = "base:texture/ui/mainmenu_settings.tga"

-- __ctor -------------------------------------------------------------------

function UIPopupWindow:__ctor(...)

	local desktopWidth
    local desktopHeight
   
    desktopWidth, desktopHeight = quartz.system.drawing.getviewportdimensions()
    self.backRectangle = { 0, 0, desktopWidth, desktopHeight }
    
    self.title = "UIPopupWindow.title"
    self.clientRectangle = { 44, 110, 501, 246}

end

-- __dtor -------------------------------------------------------------------

function UIPopupWindow:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UIPopupWindow:Draw()

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
    quartz.system.drawing.loadtexture("base:texture/ui/components/uiwindow_popup.tga")
    quartz.system.drawing.drawtexture(unpack(self.rectangle))

    -- video / icon

    if (quartz.system.drawing.loadvideo(self.icon or UIWindow.video.default)) then

        if (quartz.system.drawing.getvideostatus() ~=  1) then 
		    quartz.system.drawing.playvideo(true) 
        end

        quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))	 
        quartz.system.drawing.drawvideo(unpack(self.video.rectangle)) 
    
    elseif (self.iconTexture) then

		quartz.system.drawing.loadtexture(self.iconTexture)
		quartz.system.drawing.drawtexture(unpack(self.video.rectangle)) 

    end
    
    --quartz.system.drawing.loadvideo(self.icon or UIWindow.video.default)
    --quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))	 
    --quartz.system.drawing.drawvideo(unpack(self.video.rectangle)) 

    -- window title

    if (self.title) then

	    quartz.system.drawing.loadcolor3f(unpack(UIPopupWindow.title.fontColor))
	    quartz.system.drawing.loadfont(UIPopupWindow.title.font or UIComponent.fonts.title)
	    quartz.system.drawing.drawtextjustified(self.title, UIPopupWindow.title.fontJustification, unpack(UIPopupWindow.title.rectangle))

    end

    -- base

    UIMultiComponent.Draw(self)

    if (self.text) then

        local fontJustification = quartz.system.drawing.justification.topleft + quartz.system.drawing.justification.wordbreak
        local rectangle = {

            UIPopupWindow.rectangle[1] + self.clientRectangle[1] + 20,
            UIPopupWindow.rectangle[2] + self.clientRectangle[2] + 20,
            UIPopupWindow.rectangle[1] + self.clientRectangle[3] - 20,
            UIPopupWindow.rectangle[2] + self.clientRectangle[4] - 20,

        }

        quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
	    quartz.system.drawing.loadfont(UIComponent.fonts.default)
	    quartz.system.drawing.drawtextjustified(self.text, fontJustification, unpack(rectangle) )

    end

end

-- OnOpen --------------------------------------------------------------------

function UIPopupWindow:OnOpen()

    if (quartz.system.drawing.loadvideo(self.icon or UIWindow.video.default)) then
        quartz.system.drawing.playvideo(true) 
    end

end
