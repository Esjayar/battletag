
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.Ui.Settings.TBoxesManagement.lua
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
UTGame.Ui.Settings.TBoxesManagement = UTClass(UITitledPanel)

UTGame.Ui.Settings.TBoxesManagement.options = nil

UTGame.Ui.Settings.TBoxesManagement.backgroundTexture = "base:texture/ui/Option_TTag.tga"
-- __ctor --------------------------------------------------------------------

function UTGame.Ui.Settings.TBoxesManagement:__ctor()

	UTGame.Ui.Settings.TBoxesManagement.options = UTGame.Ui.Settings.TBoxesManagement.options or {
    [1] = { label = l"oth013", choices = { { value = 0, displayMode = "large", text = l"but002", tip = l"tip078" }, { value = 1, displayMode = "large", text = l"but001", tip = l"tip077"  } }, index = "medkitPack", },
	}

    for i, option in ipairs(UTGame.Ui.Settings.TBoxesManagement.options) do

		self.uiOption = self:AddComponent(UIOption:New(option, game.settings.addons[option.index]))

		self.uiOption:MoveTo(30, 120 + i * 70)
		self.uiOption.width = self.uiOption.width - 100

		self.uiOption.ChangeValue = function(self, value)

            game.settings.addons[self.option.index] = value

		end

    end
end

-- Draw ---------------------------------------------------------------------


function UTGame.Ui.Settings.TBoxesManagement:Draw()

	UITitledPanel.Draw(self)

	local rectangle = {15, 35, 361, 180}

    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
    quartz.system.drawing.loadtexture("base:texture/ui/components/uipanel05.tga")
    quartz.system.drawing.drawwindow(unpack(rectangle))

    quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
    quartz.system.drawing.loadtexture(self.backgroundTexture)
    quartz.system.drawing.drawtexture(30, 40)

end
