
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.OptionsPopup.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 20s, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIPopupWindow"

--[[ Class -----------------------------------------------------------------]]

UTActivity.Ui = UTActivity.Ui or {}
UTActivity.Ui.OptionsPopup = UTClass(UIPopupWindow)

-- __ctor -------------------------------------------------------------------

function UTActivity.Ui.OptionsPopup:__ctor(...)

    assert(activity)

	self.title = l"title029"

	-- uiButton1: quit

    self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
    self.uiButton1.rectangle = UIPopupWindow.buttonRectangles[1]
	self.uiButton1.text = l"but003"
	self.uiButton1.tip = l"tip006"
    
	self.uiButton1.OnAction = function (_self) 
	
		UIManager.stack:Pop()
	end
    
    self.uiButton2 = self:AddComponent(UIButton:New(), "uiButton2")
    self.uiButton2.rectangle= {97, 135, 234, 169}
	self.uiButton2.text = l"but026"
	self.uiButton2.tip = l"tip179"
    
	self.uiButton2.OnAction = function () 

		self:Fill()		
	end

    self.uiButton3 = self:AddComponent(UIButton:New(), "uiButton3")
    self.uiButton3.rectangle= {321, 135, 458, 169}
	self.uiButton3.text = l"but041"
	self.uiButton3.tip = l"tip250"
    
	self.uiButton3.OnAction = function () 
		
		self:Combine()
	end
	
	if (#activity.teams > 0) then
	
		self.uiButton4 = self:AddComponent(UIButton:New(), "uiButton4")
		self.uiButton4.rectangle= {97, 185, 234, 219}
		self.uiButton4.text = l"but031"
		self.uiButton4.tip = l"tip202"
    
		self.uiButton4.OnAction = function () 

			self:Swap()
		end
	end

end

-- OnClose -------------------------------------------------------------------

function UTActivity.Ui.OptionsPopup:OnClose()
	self:Deactivate()
	UTActivity.Ui.PlayersManagement.hasPopup = false


end

-- OnDispatchMessage ---------------------------------------------------------

function UTActivity.Ui.OptionsPopup:OnDispatchMessage(device, addressee, command, arg)



end

-- OnOpen --------------------------------------------------------------------

function UTActivity.Ui.OptionsPopup:OnOpen()
	self:Activate()
	UTActivity.Ui.PlayersManagement.hasPopup = true

end

-- Update --------------------------------------------------------------------

function UTActivity.Ui.OptionsPopup:Update()



end

function UTActivity.Ui.OptionsPopup:Fill()
	-- uiButton2: team defaults
	
	for _, player in ipairs(activity.players) do
		local teamchange = true
		for i, team in ipairs(activity.teams) do
			if (0 >= #team.players) then
				teamIndex = i
				teamchange = nil
				activity.states["playersmanagement"]:ChangeTeam(player, teamIndex)
				break
			end
		end
		if (teamchange and player.profile.team) then
			local curplayer = player
			local curteam = player.profile.team
			for _, player in ipairs(activity.players) do
				if (player ~= curplayer and curteam == player.profile.team) then
					teamIndex = player.team.index
					activity.states["playersmanagement"]:ChangeTeam(curplayer, teamIndex)
					break
				end
			end
		end
	end
	activity:SaveTeamInformation()

end

function UTActivity.Ui.OptionsPopup:Swap()


	-- uiButton3: Swap Teams

	for _, player in ipairs(activity.players) do
		teamIndex = player.team.index + 1
		while (teamIndex > #activity.teams) do
			teamIndex = teamIndex - #activity.teams
		end
		activity.states["playersmanagement"]:ChangeTeam(player, teamIndex)
	end
end

function UTActivity.Ui.OptionsPopup:Combine()

	for _, player in ipairs(activity.players) do
		teamIndex = 1
		activity.states["playersmanagement"]:ChangeTeam(player, teamIndex)
	end
end

function UTActivity.Ui.OptionsPopup:KeyDown(virtualKeyCode, scanCode)
		
	if (27 == virtualKeyCode) then

		UIManager.stack:Pop()
	end
	if (49 == virtualKeyCode) then

		self:Fill()
	end
	if (50 == virtualKeyCode) then

		self:Combine()
	end
	if (51 == virtualKeyCode) then

		self:Swap()
	end
end

-- Activate ---------------------------------------------------------------

function UTActivity.Ui.OptionsPopup:Activate()

    if (not self.keyboardActive) then

        game._KeyDown:Add(self, self.KeyDown)
        self.keyboardActive = true

    end

end

-- Deactivate ---------------------------------------------------------------

function UTActivity.Ui.OptionsPopup:Deactivate()

    if (self.keyboardActive) then 
    
        game._KeyDown:Remove(self, self.KeyDown)
        self.keyboardActive = false

    end

end