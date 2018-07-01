
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.Ui.Settings.Credits.lua
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

--[[ Class -----------------------------------------------------------------]]

UTGame.Ui.Settings = UTGame.Ui.Settings or {}
UTGame.Ui.Settings.Credits = UTClass(UITitledPanel)

-- __ctor --------------------------------------------------------------------

function UTGame.Ui.Settings.Credits:__ctor()
           	
	self.width = 350
	self.height = 360
    self.marge = {13, 40}
    
    quartz.system.drawing.loadvideo("base:video/credits.avi")
    quartz.system.drawing.playvideo(true)
	
end

-- Draw ---------------------------------------------------------------------


function UTGame.Ui.Settings.Credits:Draw()

	UITitledPanel.Draw(self)
	  

	
    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
    quartz.system.drawing.loadvideo("base:video/credits.avi")    
    quartz.system.drawing.drawvideo(self.marge[1], self.marge[2], self.marge[1] + self.width, self.marge[2] + self.height)
    
end