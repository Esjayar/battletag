
--[[--------------------------------------------------------------------------
--
-- File:            UIPlayerSlotGrid.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 06, 2010
--
------------------------------------------------------------------------------
--
-- Description:     Display a list of UIPlayerSlot as a grid
--
----------------------------------------------------------------------------]]

--[[Dependencies ----------------------------------------------------------]]

	require "Ui/UIPlayerSlot"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIPlayerSlotGrid(UIMultiComponent)

-- default

UIPlayerSlotGrid.horizontalPadding = 50

UIPlayerSlotGrid.teamColor = {
	{ "UIRedSlot_01.tga", "UIRedSlot_02.tga" },
	{ "UIBlueSlot_01.tga", "UIBlueSlot_02.tga" },	
	{ "UIYellowSlot_01.tga", "UIYellowSlot_02.tga" },	
	{ "UIGreenSlot_01.tga", "UIGreenSlot_02.tga" },		
}

-- __ctor -------------------------------------------------------------------

function UIPlayerSlotGrid:__ctor( numberOfSlot, numberOfTeam ) 

	-- team panel ...

	self.uiTeamSlots = {}
	for i = 1, numberOfTeam do

		self.uiTeamSlots[i] = {}

		self.uiTeamSlots[i].left = self:AddComponent(UIPanel:New(), "uiTeamPanelLeft" .. i)
		self.uiTeamSlots[i].left.color = UIComponent.colors.white
		self.uiTeamSlots[i].left.background = "base:texture/ui/components/" .. self.teamColor[i][1]

		self.uiTeamSlots[i].right = self:AddComponent(UIPanel:New(), "uiTeamPanelRight" .. i)
		self.uiTeamSlots[i].right.color = UIComponent.colors.white
		self.uiTeamSlots[i].right.background = "base:texture/ui/components/" .. self.teamColor[i][2]	

	end
	
	self.uiPlayerSlots = {}
	for i = 1, numberOfSlot do

		local slot = self:AddComponent(UIPlayerSlot:New(), "uiPlayerSlot" .. i)
		table.insert(self.uiPlayerSlots, slot)

	end   

	-- rearrange slots

	self:Rearrange()

end

-- __ctor -------------------------------------------------------------------

function UIPlayerSlotGrid:__dtor()
end

-- AddPlayer ----------------------------------------------------------------

function UIPlayerSlotGrid:AddSlot(player, button)

    assert(player:IsKindOf(UTPlayer))

    -- if there's an available slot : add the player to the list and update this slot

	local slot = nil
	for i = 1, #self.uiPlayerSlots do

		if (not self.uiPlayerSlots[i].player) then	

			slot = self.uiPlayerSlots[i]
			slot:SetPlayer(player, button)
			break

		end

	end

	-- rearrange slots

	self:Rearrange()

	return slot

end

-- GetSlot -------------------------------------------------------------------

function UIPlayerSlotGrid:GetSlot(player)

	for i = 1, #self.uiPlayerSlots do
		if (player == self.uiPlayerSlots[i].player) then	
			return self.uiPlayerSlots[i]
		end
	end

end

-- Rearrange ----------------------------------------------------------------

function UIPlayerSlotGrid:Rearrange()

	for i, slot in ipairs(self.uiPlayerSlots) do

		slot:MoveTo( 0, self.horizontalPadding * (i - 1) )

	end

	-- for team only

	if (0 < #activity.teams) then

		-- construct by team

		local teams = {}
		for i = 1, #activity.teams do
			teams[i] = {}
		end

		-- add slot
		
		for i, slot in ipairs(self.uiPlayerSlots) do

			if (slot.player) then
				table.insert(teams[slot.player.team.index], slot)
			else

				-- take an empty team ... or leave it 

				for i, team in ipairs(teams) do

					if (0 == #team) then
						table.insert(team, slot)
						break
					end

				end

			end

		end

		-- change display

		local playerOffset = 0
		local teamOffset = 0
		for i, team in ipairs(teams) do

			-- team slot

			self.uiTeamSlots[i].left.rectangle = { -50, teamOffset, -10, teamOffset + 35 + (50 * (#team - 1)) }
			self.uiTeamSlots[i].right.rectangle = { 310, teamOffset, 330, teamOffset + 35 + (50 * (#team - 1))  }
			teamOffset = teamOffset + (50 * #team)

			-- player slot

			for j, slot in ipairs(team) do
				slot:MoveTo( 0, self.horizontalPadding * (playerOffset + (j - 1)))
			end
			playerOffset = playerOffset + #team

		end

	end

end

-- RemoveSlot ----------------------------------------------------------------

function UIPlayerSlotGrid:RemoveSlot(removedPlayer)

    assert(removedPlayer:IsKindOf(UTPlayer))

    -- search for player, delete and shift !

	local slot = nil
	for i = 1, #self.uiPlayerSlots do

		if (removedPlayer) then

			if (self.uiPlayerSlots[i].player == removedPlayer) then	

				removedPlayer = nil
				slot = self.uiPlayerSlots[i]
				self.uiPlayerSlots[i]:SetPlayer(nil)

			end

		else

			self.uiPlayerSlots[i - 1]:SetPlayer(self.uiPlayerSlots[i].player, self.uiPlayerSlots[i].button)
			self.uiPlayerSlots[i - 1].updating = self.uiPlayerSlots[i].updating
			self.uiPlayerSlots[i]:SetPlayer(nil)

		end		

	end

	-- rearrange

	self:Rearrange()

	return slot

end