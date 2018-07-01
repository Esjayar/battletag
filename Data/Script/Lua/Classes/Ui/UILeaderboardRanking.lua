
--[[--------------------------------------------------------------------------
--
-- File:            UILeaderboardRanking.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 09, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UILeaderboard"
require "Ui/UILeaderboardItem"

--[[ Class -----------------------------------------------------------------]]

UTClass.UILeaderboardRanking(UILeaderboard)

-- __ctor ------------------------------------------------------------------

function UILeaderboardRanking:__ctor()
end

-- __dtor ------------------------------------------------------------------

function UILeaderboardRanking:__dtor()
end

-- setFx -------------------------------------------------------------------

function UILeaderboardRanking:setFx(challengers, data)

	-- add stars and offset to three firsts

    table.foreachi(self.uiLeaderboardItems, function (index, uiLeaderboardItem)

		local posY = uiLeaderboardItem.rectangle[2]
		if (index <= 3) then

			uiLeaderboardItem:MoveTo(50 * (index - 1) , posY)
			uiLeaderboardItem.rankingNbStar = 4 - index

        else
			uiLeaderboardItem:MoveTo(50 * 2 , posY)
        end

    end )	

--[[
    local itemsAddedHeight = 0
    local currentTeams = #activity.teams

	table.foreachi(challengers, function(index, challenger) 	

		-- add a ranking for each challenger
		if (0 < currentTeams) then

			challenger.data.heap.ranking = index
			table.foreachi(challenger.players, function(index, player)
				player.data.heap.ranking = index
	        end )			

		else

			challenger.data.heap.ranking = index
		
		end

		-- add items
        local uiLeaderboardItem = self:AddComponent(UILeaderboardItem:New(self, challenger), "uiLeaderboardItem" .. #self.uiLeaderboardItems + 1)
		uiLeaderboardItem.itemHeaderHeight = 45
        uiLeaderboardItem.rankInfoWidth = 150
        uiLeaderboardItem.rankInfoHeight = 80
        table.insert(self.uiLeaderboardItems, uiLeaderboardItem)

        -- ranking is used
        uiLeaderboardItem.ranking = index

		-- icon profil for winners and stars        
        if (3 >= index) then

			uiLeaderboardItem.rankingNbStar = 4 - index
			if (challenger:IsKindOf(UTPlayer)) then

                local column = { key = "icon", width = 60, style = UIGridLine.IconCellStyle:New(64, 64) }
				uiLeaderboardItem:ReplaceFieldAt(column, 1)

			end

		end

		-- no grid header
        uiLeaderboardItem.headerLine = (self.showItemsHeader and UILeaderboard.teamHeaders[challenger.profile.teamColor] or nil)
        uiLeaderboardItem.showGridHeader = false
        uiLeaderboardItem:BuildItem()

        itemsAddedHeight = itemsAddedHeight + uiLeaderboardItem.rectangle[4]

    end )

    -- organize the layout of the leaderboarditems

    local spaceLeft = 0

    if (0 < currentTeams) then
        
        -- if there are teams, we need to set the right padding between rows

        spaceLeft = self.maxHeight - itemsAddedHeight

        itemsAddedHeight = 0
        local rowPadding = math.floor(((spaceLeft - #activity.match.players * UILeaderboardItem.rowHeight) / #activity.match.players))

        table.foreachi(self.uiLeaderboardItems, function (index, uiLeaderboardItem)

            uiLeaderboardItem:SetGridPadding(12)--rowPadding)
            itemsAddedHeight = itemsAddedHeight + uiLeaderboardItem.rectangle[4]

        end )

    else
    
        -- else, we need to compute the good margin of each UILeaderboardItem

        spaceLeft = self.maxHeight - #activity.match.players * (UILeaderboardItem.rowHeight + self.minPadding)

        itemsAddedHeight = 0
        local itemMargin = math.floor((spaceLeft  / #activity.match.players) / 2 )

        table.foreachi(self.uiLeaderboardItems, function (index, uiLeaderboardItem)

			if (index <= 3) then
				uiLeaderboardItem:SetMargin(30)
			else
				uiLeaderboardItem:SetMargin(8)
			end
            itemsAddedHeight = itemsAddedHeight + uiLeaderboardItem.rectangle[4]

        end )

    end

    -- set the padding between the uiLeaderboardItems

    spaceLeft = self.maxHeight - itemsAddedHeight
    self.padding = math.ceil(math.max(math.min(spaceLeft / #self.uiLeaderboardItems, self.maxPadding), self.minPadding))
    local itemOffset = 0

    table.foreachi(self.uiLeaderboardItems, function (index, uiLeaderboardItem)

		if (index <= 3) then
			uiLeaderboardItem:MoveTo(50 * (index - 1) , itemOffset)
        else
			uiLeaderboardItem:MoveTo(50 * 2 , itemOffset)
        end
        itemOffset = uiLeaderboardItem.rectangle[4] + self.padding

    end )

    self.rectangle[4] = itemsAddedHeight + self.padding * #self.uiLeaderboardItems
--]]
end