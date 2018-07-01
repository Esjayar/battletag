
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.Ui.Video.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 27, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UI/UIPage"


--[[ Class -----------------------------------------------------------------]]

UTGame.Ui = UTGame.Ui or {}
UTGame.Ui.Video = UTClass(UIPage)

-- defaults

UTGame.Ui.Video.rectangle  = { 0, 0, 960, 720 }

-- __ctor --------------------------------------------------------------------

function UTGame.Ui.Video:__ctor(...)
       
	local scale, translation = 1.0, { 0.0, 0.0 }

	local viewportWidth, viewportHeight = quartz.system.drawing.getviewportdimensions()

	quartz.system.drawing.loadtexture("base:video/ubisoft.avi")  
	local textureWidth, textureHeight = quartz.system.drawing.gettexturedimensions()
		
	local viewportAspectRatio = viewportHeight / viewportWidth
	local textureAspectRatio = textureHeight / textureWidth

	if (viewportAspectRatio > textureAspectRatio) then

	    scale = viewportWidth / textureWidth
	    translation[2] = (viewportHeight - scale * textureHeight) / 2.0

	else

	    scale = viewportHeight / textureHeight
	    translation[1] = (viewportWidth - scale * textureWidth) / 2.0

	end

    UTGame.Ui.Video.rectangle = { translation[1], translation[2], translation[1] + textureWidth * scale, translation[2] + textureHeight * scale}

end

-- Draw ----------------------------------------------------------------------

function UTGame.Ui.Video:Draw()

	quartz.system.drawing.pushcontext()
	
    quartz.system.drawing.loadidentity()
    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
    quartz.system.drawing.loadvideo("base:video/ubisoft.avi")
    quartz.system.drawing.drawvideo(unpack(UTGame.Ui.Video.rectangle))
    
	quartz.system.drawing.pop()

end

-- OnOpen --------------------------------------------------------------------

function UTGame.Ui.Video:OnOpen()

    quartz.system.drawing.showcursor(false)

end

-- OnClose -------------------------------------------------------------------

function UTGame.Ui.Video:OnClose()

    quartz.system.drawing.showcursor(true)

end
