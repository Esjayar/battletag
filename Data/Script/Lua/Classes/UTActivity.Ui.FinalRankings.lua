
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.FinalRankings.lua
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

require "Ui/UIMenuPage"
require "Ui/UIFinalRanking"
require "Ui/UILeaderboardRanking"
require "UTActivity.Ui.Details"

--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.FinalRankings = UTClass(UIMenuPage)

-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.FinalRankings:__ctor(...)

    assert(activity)

	-- panel

    self.uiPanel = self:AddComponent(UIPanel:New(), "uiPanel")
    self.uiPanel.background = "base:texture/ui/components/uipanel05.tga"
    self.uiPanel.rectangle = UIMenuPage.panelMargin

    -- buttons,

	-- uiButton1: exit activity & get back to game selection

    self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
    self.uiButton1.rectangle = UIMenuWindow.buttonRectangles[1]
	self.uiButton1.text = l"menu02"
	self.uiButton1.tip = l"tip065"
	self.uiButton1.enabled = false

	self.uiButton1.OnAction = function (self) 

		activity:PostStateChange("end") 
		
		quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()

		game:PostStateChange("selector")

	end

	-- uiButton3: debrief details button only if present in activity

	if (activity.detailsDescriptor) then

		self.uiButton3 = self:AddComponent(UIButton:New(), "uiButton3")
		self.uiButton3.rectangle = UIMenuWindow.buttonRectangles[3]
		self.uiButton3.text = l"but021"
		self.uiButton3.tip = l"tip109"
		self.uiButton3.OnAction = function (self) UIMenuManager.stack:Push(UTActivity.Ui.Details) end
		--activity:PostStateChange("details") end		

	end

	-- uiButton4: replay button 
	
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
		activity:PostStateChange("playersmanagement") 
	end

	self.uiFinalRanking = self:AddComponent(UIFinalRanking:New(), "uiFinalRanking")
	
	if (0 < #activity.teams) then
		self.uiFinalRanking:Build(activity.teams)		
	else
		self.uiFinalRanking:Build(activity.players)
	end
end

-- OnClose -------------------------------------------------------------------

function UTActivity.Ui.FinalRankings:OnClose()

	if (self.uiFinalRanking) then
		self.uiFinalRanking:Destroy()
	end
	
	if (self.uiLeaderboard) then
		self.uiLeaderboard:RemoveDataChangedEvents()
	end

end

-- Update -------------------------------------------------------------------

function UTActivity.Ui.FinalRankings:Update()

    
	if (self.uiFinalRanking) then
		self.uiFinalRanking:Update() 
	end

	if (activity.states["finalrankings"].isReady) then 

		self.uiButton1.enabled = true
		self.uiButton4.enabled = true

	end

end
