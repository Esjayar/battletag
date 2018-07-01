
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.Settings.lua
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

require "Ui/UIMenuWindow"
require "Ui/UITitledPanel"
require "Ui/UIOption"

--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.Settings = UTClass(UIMenuWindow)

-- default

UTActivity.Ui.Settings.categoryOffset = 15
UTActivity.Ui.Settings.optionOffset = { 10, 30 }
UTActivity.Ui.Settings.optionMargin = { 10, 10 }


-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.Settings:__ctor(...)

    -- holds the UIOptions to retrieve them easily

	self.uiOptions = {}

	-- window settings

	self.uiWindow.title = l "titlemen004"
	self.uiWindow.text = ""
	
    self.uiMultiComponent = self.uiWindow:AddComponent(UIMultiComponent:New(), "uiPanel")
    self.uiMultiComponent.rectangle = self.clientRectangle
    
	self.uiWindow.uiPanel = self.uiMultiComponent:AddComponent(UIPanel:New(), "uiPanel")
	self.uiWindow.uiPanel.rectangle = { 0, 0, 715, 455 }

    -- two pass algorithm

	local categories = {}

	-- first pass: parse all activity settings,
	-- foreach category, create category and parse all options

    table.foreachi(activity.settings, function (index, category) 

	    local uiPanelCategory = self.uiWindow.uiPanel:AddComponent(UITitledPanel:New(), "uiPanelCategory" .. index)
	    uiPanelCategory.title = category.title

		local entry = { uiOptions = {}, uiPanel = uiPanelCategory, }
		table.insert(categories, entry)

	    table.foreachi(category.options, function (index, option)

	        local uiOption = uiPanelCategory:AddComponent(UIOption:New(option, activity.settings[option.index]), "uiOption" .. index)

	        table.insert(self.uiOptions, uiOption)	        
	        table.insert(entry.uiOptions, uiOption)

	    end )

	end )

	-- second pass: organize components layout

	local position = { 10, 15 }

    table.foreachi(categories, function (index, entry)

        -- the height of the panel depends on the number of uiOptions

	    entry.uiPanel.rectangle =  { 0, 0, 695, 30 + (30 * math.ceil(#entry.uiOptions / 2)) + self.optionMargin[2] }
	    entry.uiPanel:MoveTo(position[1], position[2])

	    position[2] = entry.uiPanel.rectangle[4] + self.categoryOffset

	    local offset = { 10, 0 }

	    table.foreachi(entry.uiOptions, function (index, option)

	        --offset[1] = (index > math.ceil(#entry.uiOptions / 2) and 350) or 10	        
	        --offset[2] = ((index - 1) == math.ceil(#entry.uiOptions / 2) and 30) or offset[2] + 30

            offset[1] = (math.mod(index, 2) == 0 and 350) or 10
            offset[2] = math.floor((index-1) / 2) * self.optionOffset[2]

	        option:MoveTo(offset[1], entry.uiPanel.headerSize + self.optionMargin[2] + offset[2])

	    end )

	end )

	-- materials' panel
--[[
	self.uiWindow.uiPanel.uiPanelMaterials = self.uiWindow.uiPanel:AddComponent(UITitledPanel:New(), "uiPanelMaterials")
	self.uiWindow.uiPanel.uiPanelMaterials.title = l "titlemen008"
	self.uiWindow.uiPanel.uiPanelMaterials.rectangle = { 15, 350, 710, 440 }
]]--
	-- buttons,

	-- uiButton1: cancel changes, get back to title screen

    self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
    self.uiButton1.rectangle = UIMenuWindow.buttonRectangles[1]
	self.uiButton1.text = l"but003"
    self.uiButton1.tip = l"tip006"

	self.uiButton1.OnAction = function (self) 
	
		quartz.framework.audio.loadsound("base:audio/ui/back.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()
	    activity:PostStateChange("title") 
	
	end

	-- uiButton4: accept changes, get back to title screen

    self.uiButton4 = self:AddComponent(UIButton:New(), "uiButton4")
    self.uiButton4.rectangle = UIMenuWindow.buttonRectangles[4]
	self.uiButton4.text = l "but006"
    self.uiButton4.tip = l"tip017"

    local __self = self

	self.uiButton4.OnAction = function (self) 

	    table.foreach(__self.uiOptions, function (_, uiOption)

	        activity.settings[uiOption.option.index] = uiOption.value
	        --print(uiOption.option.index.." "..activity.settings[uiOption.option.index].." "..uiOption.value)

	    end )

		quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()

	    activity:PostStateChange("playground") 

	end

end
