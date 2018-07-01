
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.Details.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 28, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UI/UISelector"

	require "UI/UIButton"
	require "UI/UIPicture"
	require "UI/UILabel"

--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.Details = UTClass(UISelector)

-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.Details:__ctor(...)

    assert(activity)

	self.transparent = false

	-- window settings

	self.uiWindow.title = l"oth019"
    self.uiSelector.title = l"oth020"

    -- contents,

    self:Reserve(#activity.players, --[[ --?? SCROLLBAR ]] false)

    -- activity description on the right side,

    self.uiDetails = self.uiWindows:AddComponent(UITitledPanel:New(), "uiDetails")
    self.uiDetails.rectangle = self.uiWindows.clientRectangle
    self.uiDetails.title = "-"
    self.uiDetails.visible = false

	-- grid label : frag and team frag
	self.uiDetails.fragLabel = self.uiDetails:AddComponent(UILabel:New(), "uiDetailsFragLabel")
	self.uiDetails.fragLabel.font = UIComponent.fonts.header
	self.uiDetails.fragLabel.fontColor = UIComponent.colors.orange
	self.uiDetails.fragLabel.text = l"oth021"
	if (#activity.teams > 0) then

		self.uiDetails.teamfragLabel = self.uiDetails:AddComponent(UILabel:New(), "uiDetailsTeamFragLabel")
		self.uiDetails.teamfragLabel.font = UIComponent.fonts.header
		self.uiDetails.teamfragLabel.fontColor = UIComponent.colors.orange
		self.uiDetails.teamfragLabel.text = l"oth022"

	end

	-- small panel for player's information

    self.uiInformation = self.uiWindows:AddComponent(UIPanel:New(), "uiInformation")
    self.uiInformation.color = UIComponent.colors.gray
    self.uiInformation.background = "base:texture/ui/components/uipanel07.tga"
    self.uiInformation.rectangle = { self.uiWindows.clientRectangle[1], self.uiWindows.clientRectangle[2] + 25, self.uiWindows.clientRectangle[3], 80}
    
    -- buttons,

    -- uiButton1: back

    self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
    self.uiButton1.rectangle = UIMenuWindow.buttonRectangles[1]
    self.uiButton1.text = l"but003"
    self.uiButton1.tip = l"tip006"

    self.uiButton1.OnAction = function (self) 
		quartz.framework.audio.loadsound("base:audio/ui/back.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()
		UIMenuManager.stack:Pop()
    end

    -- uiButton4: replay

    self.uiButton4 = self:AddComponent(UIButton:New(), "uiButton4")
    self.uiButton4.rectangle = UIMenuWindow.buttonRectangles[4]
    self.uiButton4.text = l"but022"
	self.uiButton4.tip = l"tip067"
	self.uiButton4.enabled = false

    self.uiButton4.OnAction = function (self) 

    	-- save team information

		activity:SaveTeamInformation()	

		quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()
		UIMenuManager.stack:Pop()
		activity:PostStateChange("playersmanagement") 
    end

end

-- DisplaySelectedPlayer -----------------------------------------------------

function UTActivity.Ui.Details:DisplaySelectedPlayer(player)

    self.uiDetails.visible = true
    self.uiDetails.title = player.profile.name
    self.player = player

    -- remove old components

    if (self.uiGridFrag) then
		self.uiDetails:RemoveComponent(self.uiGridFrag)
    end	
	self.uiGridFrag = nil
    if (self.uiGridTeamFrag) then
		self.uiDetails:RemoveComponent(self.uiGridTeamFrag)
    end	
	self.uiGridTeamFrag = nil

	if (self.uiInformation.data) then
	
		for i, info in ipairs(self.uiInformation.data) do

			self.uiInformation:RemoveComponent(self.uiInformation.data[i].panel)
			self.uiInformation:RemoveComponent(self.uiInformation.data[i].icon)
			self.uiInformation:RemoveComponent(self.uiInformation.data[i].label)

		end

		self.uiInformation.data = nil

	end

	if (activity.detailsDescriptor) then

		self.uiGridFrag = self.uiDetails:AddComponent(UIGrid:New(activity.detailsDescriptor.details), "uiGridFrag")
		if (#activity.teams > 0) then
			self.uiGridTeamFrag = self.uiDetails:AddComponent(UIGrid:New(activity.detailsDescriptor.details), "uiGridTeamFrag")
		end

		local numFrag = 1
		local index
		local numTeamFrag = 1
		for i, player in ipairs(activity.players) do

			if (not (player == self.player)) then

				if (player.team and (player.team.index == self.player.team.index)) then
					index = 2 + math.mod(numFrag,2)
					numFrag = numFrag + 1
					self.uiGridTeamFrag:AddLine(self.player.data.details[player.nameId], 16, "base:texture/ui/components/uigridline_background0" .. index .. ".tga")								
				else
					index = 2 + math.mod(numTeamFrag,2)
					numTeamFrag = numTeamFrag + 1
					print("nameID : " .. player.nameId)
					print("details : ")
					print(self.player.data.details)
					print(self.player.data.details[player.nameId])
					self.uiGridFrag:AddLine(self.player.data.details[player.nameId], 16, "base:texture/ui/components/uigridline_background0" .. index .. ".tga")				
				end

			end

		end

		-- pos and size and grid label !

		self.uiDetails.fragLabel.rectangle = { 40, 110 }
		self.uiGridFrag:MoveTo(40, 140)
		self.uiGridFrag:SetRowsPadding(2)
		if (self.uiGridTeamFrag) then

			self.uiDetails.teamfragLabel.rectangle = { 40, 160 + (16 * #self.uiGridFrag.rows) }
			self.uiGridTeamFrag:MoveTo(40, 185 + (16 * #self.uiGridFrag.rows))
			self.uiGridTeamFrag:SetRowsPadding(2)

		end

		-- player's information: panel, icon and value for each information needed

		self.uiInformation.data = {}
		local location = self.uiInformation.rectangle[3] - self.uiInformation.rectangle[1] - 20
		for i, info in ipairs(activity.detailsDescriptor.information) do

			self.uiInformation.data[i] = {}

			-- panel
			self.uiInformation.data[i].panel = self.uiInformation:AddComponent(UIPanel:New(), "uiInformationPanel")
			self.uiInformation.data[i].panel.color = UIComponent.colors.lightgray
			self.uiInformation.data[i].panel.background = "base:texture/ui/components/uipanel01.tga"
			self.uiInformation.data[i].panel.rectangle = { location - 120, 10, location, 50 }
			self.uiInformation.data[i].panel.tip = info.tip
			self.uiInformation.data[i].panel.RegisterPickRegions = UIButton.RegisterPickRegions
			self.uiInformation.data[i].panel.sensitive = true

			-- icon
			self.uiInformation.data[i].icon = self.uiInformation:AddComponent(UIPicture:New(), "uiInformationIcon")
			self.uiInformation.data[i].icon.texture = info.icon
			self.uiInformation.data[i].icon.rectangle = { location - 120, 15, location - 120 + 32, 47 }

			-- label
			self.uiInformation.data[i].label = self.uiInformation:AddComponent(UILabel:New(), "uiInformationLabel")
			self.uiInformation.data[i].label.font = UIComponent.fonts.header
			self.uiInformation.data[i].label.fontColor = UIComponent.colors.orange
			self.uiInformation.data[i].label.fontJustification = quartz.system.drawing.justification.center
			self.uiInformation.data[i].label.rectangle = { location - 90, 20, location, 40 }
			self.uiInformation.data[i].label.text = self.player.data.baked[info.key]

			-- next one
			location = location - (140 * i)

		end

	end

end

-- Draw ----------------------------------------------------------------------

function UTActivity.Ui.Details:Draw()

    UIPage.Draw(self)

    --

    if (self.player) then

        quartz.system.drawing.pushcontext()

        quartz.system.drawing.loadtranslation(unpack(self.uiWindows.rectangle))
        quartz.system.drawing.loadtranslation(unpack(self.uiWindow.rectangle))
        quartz.system.drawing.loadtranslation(unpack(self.clientRectangle))
        
        -- special reward

		if (self.player.data.baked.reward) then

			quartz.system.drawing.loadfont(UIComponent.fonts.header)
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
			quartz.system.drawing.drawtextjustified(self.player.data.baked.reward, quartz.system.drawing.justification.right, unpack({150, 0, 350, 50}))

		end

        -- all header icons

		if (activity.detailsDescriptor) then

			local rectangle = { 40 - 10, 100, 40 - 10 + 32, 100 + 32 }
			for i, descriptor in ipairs(activity.detailsDescriptor.details) do

				if (descriptor.icon) then


					quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
					quartz.system.drawing.loadtexture(descriptor.icon)
					quartz.system.drawing.drawtexture(unpack(rectangle))

				end
				rectangle[1] = rectangle[1] + descriptor.width
				rectangle[3] = rectangle[3] + descriptor.width

			end

		end
		
        quartz.system.drawing.pop()

    end

end

-- OnOpen --------------------------------------------------------------------

function UTActivity.Ui.Details:OnOpen()

    for i, player in ipairs(activity.players) do

        local properties = { headerText = i, text = player.profile.name, userData = player }
        local item = self:AddItem(properties)

        item.Action = function ()

            if (item.userData) then
                self:DisplaySelectedPlayer(item.userData)
            end

        end

    end

    self.index = 1
    self:Scroll(0)
    self:DisplaySelectedPlayer(activity.players[1])

end

-- Update --------------------------------------------------------------------

function UTActivity.Ui.Details:Update()

	if (activity.states["finalrankings"].isReady) then 

		self.uiButton4.enabled = true

	end

end