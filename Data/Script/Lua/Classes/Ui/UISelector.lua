
--[[--------------------------------------------------------------------------
--
-- File:            UiSelector.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 9, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UI/UIMenuWindow"

    require "UI/UIArrowDown"
    require "UI/UIArrowUp"

--[[ Class -----------------------------------------------------------------]]

UISelector = UTClass(UIMenuWindow)

    require "UI/UISelector.Item"

-- defaults

UISelector.capacity = 6

-- __ctor --------------------------------------------------------------------

function UISelector:__ctor(...)

    self.items = {}
    self.index = nil
    self.indexed = nil

    -- contents,

    self.uiPanel = self.uiWindow:AddComponent(UIPanel:New(), "uiPanel")
    self.uiPanel.rectangle = self.clientRectangle

    -- left panel

    self.uiSelector = self.uiPanel:AddComponent(UITitledPanel:New(), "uiSelector")
    self.uiSelector.rectangle = { 20, 20, 300, 435 }
    self.uiSelector.title = "Selector"

        -- !! ADD SUPPORT FOR SCROLLBAR & FILTER

        --[[
        -- arrows

        self.uiArrowUp = self.uiSelector:AddComponent(UIArrowUp:New(), "uiArrowUp")
        self.uiArrowUp:MoveTo(280 - 35 - 10, 25 + 10)

        self.uiArrowUp.enabled = false
        self.uiArrowUp.OnAction = function ()
            self:Scroll(-1)
        end

        self.uiArrowDown = self.uiSelector:AddComponent(UIArrowDown:New(), "uiArrowDown")
        self.uiArrowDown:MoveTo(280 - 35 - 10, 25 + 20 + 34 + self.capacity * 40)

        self.uiArrowDown.enabled = false
        self.uiArrowDown.OnAction = function ()
            self:Scroll(1)
        end
        --]]

    -- right windows

    self.uiPanel.clientRectangle = { 320, 20, 695, 435 }

    self.uiWindows = self.uiPanel:AddComponent(UIMultiComponent:New(), "uiWindows")
    self.uiWindows.rectangle = self.uiPanel.clientRectangle
    self.uiWindows.clientRectangle = { 0, 0, self.uiPanel.clientRectangle[3] - self.uiPanel.clientRectangle[1], self.uiPanel.clientRectangle[4] - self.uiPanel.clientRectangle[2] }

end

-- AddItem -------------------------------------------------------------------

function UISelector:AddItem(properties)

    local item = {}

    if (properties and (properties.headerIcon or properties.headerText)) then
        item.header = { icon = properties.headerIcon, text = properties.headerText }
    end

    item.color = properties and properties.color
    item.text = properties and properties.text or "text"
    item.userData = properties and properties.userData

    -- insert

    table.insert(self.items, item)
    item.index = #self.items

    self.index = self.index or item.index

    return item

end

-- AddItem -------------------------------------------------------------------

function UISelector:RemoveItem(item)
    
    for index = item.index + 1, #self.items do
		
		self.items[index].index = self.items[index].index - 1
		
    end
    
    table.remove(self.items, item.index)
    
    self:Scroll(0)

end

-- Scroll --------------------------------------------------------------------

function UISelector:Reserve(capacity, iconType)

    self.capacity = capacity or UISelector.capacity

    -- items

    self.uiItems = {}

    local dx, dy = 10, --[[ uititledpanel.header --]] 25 + 0 + --[[ uiarrowup.height --]] 0 + 10    

    for i = 1, self.capacity do

        local uiItem = self.uiSelector:AddComponent(UISelector.Item:New(), "uiItem" .. i)
        table.insert(self.uiItems, uiItem)
		
        uiItem.rectangle = { dx, dy, dx + 280 - 10, dy + uiItem.height }
		
		if (iconType and iconType == true) then
		
			uiItem.height = 40
			uiItem.rectangle[2] = uiItem.rectangle[2] + 20
			uiItem.rectangle[4] = uiItem.rectangle[4] + 20
			uiItem.iconType = iconType
			
		end
		
        dy = dy + uiItem.height + 4

        -- forward call

        uiItem.OnAction = function ()

            if (uiItem.item and uiItem.item.Action) then
                uiItem.item:Action()
            end

            -- the indexed item appears differently ...

            if (self.indexed ~= uiItem) then

                if (self.indexed) then
                    self.indexed.indexed = false
                end

                self.indexed = uiItem
                self.indexed.indexed = true
            end

        end

    end

end

-- Scroll --------------------------------------------------------------------

function UISelector:Scroll(number)

    assert(self.uiItems and (0 < #self.uiItems))

    self.index = self.index + number
    if (self.index < 1) then

        self.index = 1

    elseif (self.index + #self.uiItems - 1 > #self.items) then

        self.index = math.max(1, #self.items - #self.uiItems)

    end

    for index = 1, #self.uiItems do

        local item = self.items[self.index + (index - 1)]
        local uiItem = self.uiItems[index]

        uiItem.item = item

        if (uiItem.item) then

            uiItem.enabled = true

            uiItem.color = item.color
            uiItem.header = item.header
            uiItem.text = item.text
            uiItem.tip = item.tip

            --uiItem.color = item.color or UIComponent.colors.red
            --uiItem.pictogram = (item.pictogram  and ("base:texture/ui/pictograms/32x/" .. item.pictogram)) or "base:texture/ui/pictograms/32x/empty.tga"
            --uiItem.text = item.name or item.__directory

        else

            uiItem.enabled = false

        end

    end

    -- the indexed item appears differently ...

    if (not self.indexed) then
        self.indexed = self.uiItems[1]
        self.indexed.indexed = true
    end

end