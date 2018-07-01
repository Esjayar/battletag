
--[[--------------------------------------------------------------------------
--
-- File:            UILeaderboard.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 13, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UILeaderboardItem"

--[[ Class -----------------------------------------------------------------]]

UTClass.UILeaderboard(UIMultiComponent)

UILeaderboard.showRanking = true
UILeaderboard.smallPanel = false
UILeaderboard.largePanel = true

-- sort mode 

UILeaderboard.itemsSortField = "score"

UILeaderboard.TeamColor = 
{
	["red"] = 1,
	["blue"] = 2,
	["yellow"] = 3,
	["green"] = 4,	
}

-- __ctor --------------------------------------------------------------------

function UILeaderboard:__ctor()

    self.rectangle = { 0, 0, 400, 0 }

end

-- __dtor --------------------------------------------------------------------

function UILeaderboard:__dtor()

    -- remove datachanged event

end

-- Build ---------------------------------------------------------------------

function UILeaderboard:Build(challengers, data)

	-- set in activity

	activity.uiLeaderboard = self

	-- ranking

	self.uiRankingPicture = {}
    table.foreachi(challengers, function(index, challenger) 

		if (self.showRanking  and (index <= 3)) then

			self.uiRankingPicture[index] = self:AddComponent(UIPicture:New(), "uiRankingPicture" .. index)
			self.uiRankingPicture[index].color = UIComponent.colors.white
			self.uiRankingPicture[index].texture = "base:texture/ui/afp_number_" .. index .. ".tga"

		end

	end)

	-- data used on challenger (baked or heap)

	self.data = data or "heap"

	-- create an item for each challenger 

    self.rankedList = {}
    table.foreachi(challengers, function(index, challenger) 

        local uiLeaderboardItem = self:AddComponent(UILeaderboardItem:New(self, challenger), "uiLeaderboardItem" .. #self.rankedList + 1)
        uiLeaderboardItem.ranking = index
        uiLeaderboardItem:BuildItem()
		table.insert(self.rankedList, uiLeaderboardItem)

	end )
	
	self:Sort(true)
	
end

-- RegisterFields ------------------------------------------------------------

function UILeaderboard:RegisterField(fieldKey, fieldIcon, fieldRules, fieldPosition, fieldJustification, fieldFont, fieldColor )

    assert(type(fieldKey) == "string", "Assertion failed in UILeaderboard:RegisterField() : key is not a string")

    self.fields = self.fields or {}
    local fieldDescriptor = { key = fieldKey, icon = fieldIcon, position = fieldPosition, justification = fieldJustification , font = fieldFont, color = fieldColor}
    table.insert(self.fields, fieldDescriptor)

end

-- RemoveDataChangedEvents -----------------------------------------------

function UILeaderboard:RemoveDataChangedEvents()

    table.foreachi(self.rankedList, function (index, item)

        item:RemoveDataChangedEvents()

    end )

end

-- Sort --------------------------------------------------------------------

function UILeaderboard:Sort(init)

	-- sorting now !

	function sorting(item1, item2)
		if (item1.challenger.data[self.data][self.itemsSortField] > item2.challenger.data[self.data][self.itemsSortField]) then 
			return true
		elseif ((item1.challenger.data[self.data][self.itemsSortField] == item2.challenger.data[self.data][self.itemsSortField]) and (item1.ranking < item2.ranking)) then 
			return true
		end
	end

	table.sort(self.rankedList, sorting)
	
	-- then compute new position

	local itemOffset = 0
    for index, item in ipairs(self.rankedList) do

		-- make a move ...

		if (init) then

	        item.ranking = index
			item:MoveTo(0, itemOffset)

		else

			if (item.ranking ~= index) then

				item.ranking = index
				if (item.mvtFx) then

					UIManager:RemoveFx(item.mvtFx)
					item.mvtFx = nil

				end
				if (item.challenger:IsKindOf(UTTeam) and game and game.gameMaster and game.gameMaster.ingame == true and itemOffset == 0 and item.rectangle[2] ~= 0) then
				
					game.gameMaster:RegisterSound({ paths = {"base:audio/gamemaster/DLG_GM_FRAG_TEAM_0" .. UILeaderboard.TeamColor[item.challenger.profile.teamColor] ..".wav"}, priority = 2})
				
				end
				item.mvtFx = UIManager:AddFx("position", { duration = 0.8, __self = item, from = {0, item.rectangle[2]}, to = { 0, itemOffset }, type = "descelerate" })

			end

		end
		
        -- ranking

		if (self.showRanking and (index <= 3)) then

			if (item.challenger:IsKindOf(UTTeam)) then
				self.uiRankingPicture[index].rectangle = {
					-140,
					itemOffset,
					-140 + 50,
					itemOffset + 50,
				}	
			else
				self.uiRankingPicture[index].rectangle = {
					-60,
					itemOffset,
					-60 + 50,
					itemOffset + 50,
				}				
			end

		end

		-- next one

        if (item.challenger:IsKindOf(UTTeam)) then
			itemOffset = itemOffset + 30 + (64 * #item.challenger.players)
		else
			if (self.largePanel) then
				itemOffset = itemOffset + 80
			else
				itemOffset = itemOffset + 65
			end
		end

	end

end