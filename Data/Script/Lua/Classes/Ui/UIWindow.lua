
--[[--------------------------------------------------------------------------
--
-- File:            UIWindow.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 15, 2010
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

UTClass.UIWindow(UIMultiComponent)

-- defaults

UIWindow.rectangle = { 95, 56, 865, 666 }
UIWindow.size = { UIWindow.rectangle[3] - UIWindow.rectangle[1], UIWindow.rectangle[4] - UIWindow.rectangle[2] }

-- title

UIWindow.title = {

    font = UIComponent.fonts.title,
    fontColor = UIComponent.colors.orange,
    fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter,

    -- 96, 34, 560, 59
    rectangle = { 191, 90, 655, 113 },
}

UIWindow.video = {

    default = "base:/video/uianimatedbutton_games.avi",
    rectangle = { 116, 76, 116 + 52, 76 + 52 },

}

UIWindow.iconTexture = "base:texture/ui/mainmenu_settings.tga"

-- __ctor -------------------------------------------------------------------

function UIWindow:__ctor(...)

    self.title = "UIWindow.title"
    self.clientRectangle = { 13, 87, 768, 608 }
    
    if (quartz.system.drawing.loadvideo(self.icon or UIWindow.video.default)) then
        quartz.system.drawing.playvideo(true) 
    end

end

-- __dtor -------------------------------------------------------------------

function UIWindow:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UIWindow:Draw()
    
    assert(self.rectangle)

    -- window

    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))	 
    quartz.system.drawing.loadtexture("base:texture/ui/components/uiwindow_main.tga")
    quartz.system.drawing.drawtexture(unpack(self.rectangle))

    -- animated icon

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

    -- window title

    if (self.title) then

	    quartz.system.drawing.loadcolor3f(unpack(UIWindow.title.fontColor))
	    quartz.system.drawing.loadfont(UIWindow.title.font or UIComponent.fonts.title)
	    quartz.system.drawing.drawtextjustified(self.title, UIWindow.title.fontJustification, unpack(UIWindow.title.rectangle))

    end

    -- base

    UIMultiComponent.Draw(self)

    if (self.text) then

        local fontJustification = quartz.system.drawing.justification.topleft + quartz.system.drawing.justification.wordbreak
        local rectangle = {

            UIWindow.rectangle[1] + self.clientRectangle[1] + 20 + 20,
            UIWindow.rectangle[2] + self.clientRectangle[2] + 20 + 20,
            UIWindow.rectangle[1] + self.clientRectangle[3] - 20 - 20,
            UIWindow.rectangle[2] + self.clientRectangle[4] - 20 - 20 - 12 - 34,

        }

        quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
	    quartz.system.drawing.loadfont(UIComponent.fonts.default)
	    quartz.system.drawing.drawtextjustified(self.text, fontJustification, unpack(rectangle) )

    end

end