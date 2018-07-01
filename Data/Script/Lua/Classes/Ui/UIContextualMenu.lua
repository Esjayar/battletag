
--[[--------------------------------------------------------------------------
--
-- File:            UIContextualMenu.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 17, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIMultiComponent"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIContextualMenu(UIMultiComponent)

-- defaults

UIContextualMenu.defaultWidth = 175
UIContextualMenu.defaultHeight = 20
UIContextualMenu.defaultMargin = 4

-- __ctor -------------------------------------------------------------------

function UIContextualMenu:__ctor(x, y, ...)

	-- set rectangle

	self.rectangle = { 0, 0, 960, 720 }	

	-- a label 

	self.panel = self:AddComponent(UIPanel:New(), "uiLabel")
    self.panel.background  = "base:texture/ui/components/uipanel04.tga"
    self.panel.color = UIComponent.colors.lightgray
    self.location = { x, y }

	-- items list
	self.items = {}

end

-- __dtor -------------------------------------------------------------------

function UIContextualMenu:__dtor()
end

-- AddItem ------------------------------------------------------------------

function UIContextualMenu:AddItem(item)

	local offset = #self.items * self.defaultHeight

	-- add a panel and label
	item.panel = self.panel:AddComponent(UIPanel:New(), "uiLabel")
    item.panel.background  = "base:texture/ui/components/uipanel07.tga"
    item.panel.color = UIComponent.colors.orange
    item.panel.rectangle  = { 0, offset + self.defaultMargin, self.defaultWidth, offset + self.defaultMargin + self.defaultHeight }
    item.panel.visible = false
    
    item.label = self.panel:AddComponent(UILabel:New(), "uiLabel")
    item.label.fontColor = UIComponent.colors.black
	item.label.tip = item.tip
    item.label.font = UIComponent.font.default
    item.label.rectangle  = { 0, offset + self.defaultMargin , self.defaultWidth, offset + self.defaultMargin + self.defaultHeight }
    item.label.text = item.text
    item.label.fontJustification = quartz.system.drawing.justification.center
    item.label.item = item
	
	item.parent = self
    item.label.OnFocus = function (self)
		self.item.panel.visible = true
    end

    item.label.OnFocusLost = function (self)
		self.item.panel.visible = false
    end

    item.label.OnAction = function (self)
		if (self.item.action) then
			self.item.action()
			self.item.parent.parent:RemoveComponent(self.item.parent)
		end
    end

    -- insert into table

	table.insert(self.items, item)

    -- increase size
	
    self.panel.rectangle  = { self.location[1], self.location[2], self.location[1] + self.defaultWidth, self.location[2] + (self.defaultHeight * #self.items) + (self.defaultMargin * 2)}

end

-- OnAction -------------------------------------------------------------------

function UIContextualMenu:OnAction()

	self.parent:RemoveComponent(self)

end

-- RegisterPickRegions -------------------------------------------------------

function UIContextualMenu:RegisterPickRegions(regions, left, top)

	-- myself
	if (self.sensitive and self.rectangle) then

		local region = {
			component = self,
			rectangle = { self.rectangle[1] + left, self.rectangle[2] + top, self.rectangle[3] + left, self.rectangle[4] + top }
		}

		table.insert(regions, region)

	end

	-- all my items
	for i, item in ipairs(self.items) do

		local region = {
			component = item.label,
			rectangle = { self.panel.rectangle[1] + item.label.rectangle[1] + left, self.panel.rectangle[2] + item.label.rectangle[2] + top, self.panel.rectangle[3] + item.label.rectangle[3] + left, self.panel.rectangle[4] + item.label.rectangle[4] + top }
		}
		table.insert(regions, region)

	end

end