
--[[--------------------------------------------------------------------------
--
-- File:            UARustlers.Ui.RoundLoop.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            November 25, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity.Ui.RoundLoop"
require "Ui/UIAFP"
require "Ui/UILeaderboard"

--[[ Class -----------------------------------------------------------------]]

UARustlers.Ui = UARustlers.Ui or {}
UARustlers.Ui.RoundLoop = UTClass(UIMenuPage)

-- default

	UARustlers.Ui.RoundLoop.profiles = UARustlers.Ui.RoundLoop.profiles or {

    [1] = { icon = "base:texture/ui/leaderboard_rustlersredteam.tga", name = l"oth033", teamColor = "red", color = { 0.85, 0.15, 0.04 }, 
		details = "base:texture/ui/Detail_LineRedTeam.tga", detailsHeader = "base:texture/ui/Detail_HeaderRed.tga" },
    [2] = { icon = "base:texture/ui/leaderboard_rustlersblueteam.tga", name = l"oth034", teamColor = "blue", color = { 0.05, 0.53, 0.84 }, 
		details = "base:texture/ui/Detail_LineBlueTeam.tga", detailsHeader = "base:texture/ui/Detail_HeaderBlue.tga" },

	}

-- __ctor -------------------------------------------------------------------

function UARustlers.Ui.RoundLoop:__ctor(...)

	-- label

    self.uiLabel = self:AddComponent(UILabel:New(), "uiLabel")
    self.uiLabel.fontColor = UIComponent.colors.black
    self.uiLabel.rectangle = { 300, 0, 700, 80 }

    ------------------------------------------------
    -- AFP TEST
    ------------------------------------------------

    activity.uiAFP = self:AddComponent(UIAFP:New(), "uiAFP")
    activity.uiAFP:MoveTo(20, 40)

	-- change team icon

	activity.match.challengers[1].profile = self.profiles[1]
	activity.match.challengers[2].profile = self.profiles[2]

    ------------------------------------------------
    -- LEADERBOARD TEST
    ------------------------------------------------

    self.uiLeaderboard = self:AddComponent(UILeaderboard:New(), "uiLeaderboardTest")
    self.uiLeaderboard.showSlotEmpty = true
    self.uiLeaderboard:MoveTo(550, 40)

    -- key / icon / position / justification

	if (activity.scoringField) then
		for i, field in ipairs(activity.scoringField) do
			self.uiLeaderboard:RegisterField(unpack(field))
		end
	end

    self.uiLeaderboard:Build(activity.match.challengers, "heap")
end

-- __dtor -------------------------------------------------------------------

function UARustlers.Ui.RoundLoop:__dtor()    

	-- unregister to all data heap
	--for i, challenger in ipairs(activity.match.challengers) do
--
		--challenger._DataChanged:Remove(_UTActivityTest.Ui.RoundLoop, _UTActivityTest.Ui.RoundLoop.OnDataChanged)
		--if (challenger:IsKindOf(UTTeam)) then
--
			--for j, player in ipairs(challenger.players) do
				--player._DataChanged:Remove(_UTActivityTest.Ui.RoundLoop, _UTActivityTest.Ui.RoundLoop.OnDataChanged)
			--end
		--end
	--end

end

-- Update -------------------------------------------------------------------

function UARustlers.Ui.RoundLoop:Update()
end

-- Draw -------------------------------------------------------------------

--function _UTActivityTest.Ui.RoundLoop:Draw()
--
	---- base
--
	--UIMenuPage.Draw(self)
--
    ---- !! USE LEADERBOARD UI CLASS INSTEAD
    ---- !! USE GRID ASAP
	--
	--quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.black))
    --quartz.system.drawing.loadfont(UIComponent.fonts.default)
    --local lastOffset = 50
	--if (0 < #activity.teams) then
--
		--for i, team in ipairs(activity.match.challengers) do
--
			--quartz.system.drawing.drawtext(team.profile.name .. " : " .. (team.data.heap.score or 0), 650, lastOffset)
			--for j, player in ipairs(team.players) do
--
				--quartz.system.drawing.drawtext(player.profile.name .. " : " .. (player.data.heap.score or 0), 650, lastOffset + (20 * j))
				----for k, value in ipairs(activity.displayData) do
					----quartz.system.drawing.drawtext(player.data.heap[value[1]], 750 + (40 * k), lastOffset + (20 * j))
				----end
--
			--end
			--
			--lastOffset = lastOffset + (math.max(2, #team.players) * 30)
--
		--end
--
	--else
--
		--for i, challenger in ipairs(activity.match.challengers) do
			--quartz.system.drawing.drawtext(challenger.profile.name .. " : " .. (challenger.data.heap.score or 0), 650, lastOffset)
			----for j, value in ipairs(activity.displayData) do
				----quartz.system.drawing.drawtext(challenger.data.heap[value[1]], 750 + (40 * j), lastOffset)
			----end
			--lastOffset = lastOffset + 30
		--end
--
	--end	
--
--end

-- OnDataChanged  ------------------------------------------------------------

--function _UTActivityTest.Ui.RoundLoop:OnDataChanged(_table, _key, _value)
--
    ---- ?? HOW DO WE KNOW WHOSE ENTITY'S DATA WAS CHANGED, DO WE HAVE TO CARE
--
	--print(_table, _key, _value)
--
--end
