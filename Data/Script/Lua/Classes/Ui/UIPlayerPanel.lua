
--[[--------------------------------------------------------------------------
--
-- File:            UIPlayerPanel.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 24, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[Dependencies ----------------------------------------------------------]]

require "Ui/UITitledPanel"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIPlayerPanel(UITitledPanel)

-- default

UIPlayerPanel.header = "base:texture/ui/components/uipanel10.tga"
UIPlayerPanel.background = "base:texture/ui/components/uipanel02.tga"
UIPlayerPanel.fontPosition = 0
UIPlayerPanel.fontJustification = quartz.system.drawing.justification.center + quartz.system.drawing.justification.singlelineverticalcenter
UIPlayerPanel.fontColor = UIComponent.colors.white
UIPlayerPanel.headerSize = 35
UIPlayerPanel.width = 260
UIPlayerPanel.height = 150

-- __ctor ------------------------------------------------------------------

function UIPlayerPanel:__ctor(player, position)

    self.title = player.profile.name
    self.rectangle = { position[1], position[2], position[1] + self.width, position[2] + self.height }

	if (player) then

		-- hud icon and gun number

		self.uiGunhud= self:AddComponent(UIPicture:New(), "uiGunhud")
		self.uiGunhud.rectangle = { 5, -10, 5 + 55, -10 + 55 }
		if (player.rfGunDevice) then
			self.uiGunhud.texture = "base:texture/ui/pictograms/64x/Hud_" .. player.rfGunDevice.classId .. ".tga"
		else
			self.uiGunhud.texture = "base:texture/ui/pictograms/64x/Hud_guest.tga"
		end	

		-- harness (if necessary) with state

		if (activity.category ~= UTActivity.categories.single) then

			self.uiHarness= self:AddComponent(UIPicture:New(), "uiHarness")
			self.uiHarness.rectangle = { self.width - 5 - 32, 0, self.width - 5, 32 }
			self.uiHarness.texture = "base:texture/ui/icons/32x/Harness_Off.tga"

		end

		-- icon

		self.uiIcon= self:AddComponent(UIPicture:New(), "uiIcon")
		self.uiIcon.rectangle = { self.width * 0.5 - 80, 20, self.width * 0.5 + 80, 180 }
		self.uiIcon.texture = "base:texture/avatars/256x/" .. player.profile.icon

	end

end

-- __dtor -------------------------------------------------------------------

function UIPlayerPanel:__dtor()
end