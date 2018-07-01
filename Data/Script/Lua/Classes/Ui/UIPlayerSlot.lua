
--[[--------------------------------------------------------------------------
--
-- File:            UIPlayerSlot.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 02, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[Dependencies -----------------------------------------------------------]]

	require "Ui/UIMoreButton"
    require "Ui/UIContextualMenu"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIPlayerSlot(UIMultiComponent)

-- default

-- __ctor --------------------------------------------------------------------

function UIPlayerSlot:__ctor(...)

	-- main panel

		self.uiMainPanel = self:AddComponent(UIPanel:New(), "uiMainPanel")
		self.uiMainPanel.color = UIComponent.colors.white
		self.uiMainPanel.rectangle = { 0, 0, 300, 35 }
		self.uiMainPanel.background = "base:texture/ui/components/UIPanel02.tga"


		-- right panel

			self.uiRightPanel = self:AddComponent(UIPanel:New(), "uiRightPanel")
			self.uiRightPanel.color = UIComponent.colors.lightgray
			self.uiRightPanel.rectangle = { 255, 0, 300, 35 }
			self.uiRightPanel.background = "base:texture/ui/components/UIPanel12.tga"

		-- left panel

			self.uiLeftPanel = self:AddComponent(UIPanel:New(), "uiLeftPanel")
			self.uiLeftPanel.color = UIComponent.colors.lightgray
			self.uiLeftPanel.rectangle = { 0, 0, 80, 35 }
			self.uiLeftPanel.background = "base:texture/ui/components/UIPanel13.tga"

	-- more button

	self.uiButton = self:AddComponent(UIMoreButton:New(), "uiButton")
	self.uiButton:MoveTo( 262, 2 )
	self.uiButton.visible = false
	self.uiButton.tip = l"tip045"

	-- no player

	self.player = nil

	-- icon or button ?

	self.icon = nil

	-- updating

	self.updating = false
	self._ProfileUpdated = UTEvent:New()

end

-- __dtor --------------------------------------------------------------------

function UIPlayerSlot:__dtor()

	if (self.player) then self.player._ProfileUpdated:Remove(self, self.OnProfileUpdated)
	end

end

-- Draw ----------------------------------------------------------------------

function UIPlayerSlot:Draw()

	-- father

	UIComponent.Draw(self)

	if (self.player) then

		quartz.system.drawing.pushcontext()
        quartz.system.drawing.loadtranslation(unpack(self.rectangle))

		-- player information

			-- icon

			if (self.player.profile.icon) then

				local rectangle = { -45, -25, -45 + 80, -25 + 80 }
				quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
				quartz.system.drawing.loadtexture("base:texture/avatars/80x/" .. self.player.profile.icon)
				quartz.system.drawing.drawtexture(unpack(rectangle))			

			end

			-- hud

			local rectangle = { 34, -5, 34 + 45, -5 + 45 }
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
			if (self.player.rfGunDevice) then
				quartz.system.drawing.loadtexture("base:texture/ui/pictograms/64x/Hud_" .. self.player.rfGunDevice.classId .. ".tga")
			else
				quartz.system.drawing.loadtexture("base:texture/ui/pictograms/64x/Hud_guest.tga")			
			end
			quartz.system.drawing.drawtexture(unpack(rectangle))			

			-- name

			local rectangle = { 85, 7 }
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
			quartz.system.drawing.loadfont(UIComponent.fonts.header)
			quartz.system.drawing.drawtext(self.player.profile.name, rectangle[1], rectangle[2] )

			-- icon
			if (self.icon) then

				local rectangle = { 262, 2, 262 + 32, 2 + 32 }
				quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
				quartz.system.drawing.loadtexture(self.icon)
				quartz.system.drawing.drawtexture(unpack(rectangle))	

			end

		quartz.system.drawing.pop()

	end

end

-- DisplayButton -------------------------------------------------------------

function UIPlayerSlot:DisplayButton()

	self.uiButton.visible = true
	self.uiButton.OnAction = function ()

		-- contextual menu 
		local mouse = UIManager.stack.mouse.cursor
		local menu =  UIMenuManager.stack.top:AddComponent(UIContextualMenu:New(mouse.x - 40, mouse.y), "uiContextualMenu")
		local item = {
			text = l"pop001",
			tip = l"tip053",
			action = function (_self)

				local ui = UTGame.Ui.Associate:New(self.player)
				UIManager.stack:Push(ui)

			end
		}
		menu:AddItem(item)
		
		if ((0 < #activity.teams) and  (1 < #self.player.team.players)) then
			item = {
				text = l"pop002",
				tip = l"tip049",
				action = function (_self) activity.states["playersmanagement"]:ChangeTeam(self.player) end
			}
			menu:AddItem(item)
		end
		
		if (not self.player.rfGunDevice) then
			item = {
				text = l"pop003",
				tip = l"tip055",
				action = function (_self) activity.states["playersmanagement"]:DeletePlayer(self.player) end
			}
			menu:AddItem(item)
		end	
	
	end

end

-- OnProfileUpdated ----------------------------------------------------------

function UIPlayerSlot:OnProfileUpdated(player)

	if (self.player) then 
		self:DisplayButton()
		self.button = true
	end

	-- event

	self.updating = false
	self._ProfileUpdated:Invoke(self)

end

-- SetPlayer -----------------------------------------------------------------

function UIPlayerSlot:SetPlayer(player, button)

	-- profile

	if (self.player) then self.player._ProfileUpdated:Remove(self, self.OnProfileUpdated)
	end
	if (player) then 
		self.updating = true
		player._ProfileUpdated:Add(self, self.OnProfileUpdated) 
	end

	-- store player

	self.player = player 
	self.button = button
	if (player and button) then 
		self:DisplayButton()
	else
		self.uiButton.visible = false
	end

end