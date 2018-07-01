
--[[--------------------------------------------------------------------------
--
-- File:            UILeaderboardItem.lua
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

require "Ui/UIPanel"
require "Ui/UIGrid"

--[[ Class -----------------------------------------------------------------]]

UTClass.UILeaderboardItem(UIMultiComponent)

-- default

UILeaderboardItem.teamColor = {
	{ "UIRedSlot_01.tga", "UIRedSlot_02.tga", "leaderboard_redline.tga" },
	{ "UIBlueSlot_01.tga", "UIBlueSlot_02.tga", "leaderboard_blueline.tga" },	
	{ "UIYellowSlot_01.tga", "UIYellowSlot_02.tga", "leaderboard_yellowline.tga" },	
	{ "UIGreenSlot_01.tga", "UIGreenSlot_02.tga", "leaderboard_greenline.tga" },		
}

-- __ctor ------------------------------------------------------------------

function UILeaderboardItem:__ctor(leaderboard, challenger)

    self.uiLeaderboard = leaderboard
    self.challenger = challenger
    self.data = self.challenger.data[self.uiLeaderboard.data]
    self.animationData = {}
    self.columnsDescriptor = {}

	if (self.challenger:IsKindOf(UTPlayer)) then

		--self.uiPanel = self:AddComponent(UIPanel:New(), "uiPanel")
		self.uiPanel = {}
		if (self.challenger.team or not self.uiLeaderboard.largePanel) then
			if (#activity.players > 8) then
				self.uiPanel.background = "base:texture/ui/components/UILeaderboardPlayerTeamSmallPanel.tga"
				self.uiPanel.rectangle = { 0, 18, 0 + 380, 18 + 28 }
			else
				self.uiPanel.background = "base:texture/ui/components/UILeaderboardPlayerTeamPanel.tga"
				self.uiPanel.rectangle = { 0, 0, 380, 60 }
			end
		else
			if (self.uiLeaderboard.smallPanel) then
				self.uiPanel.background = "base:texture/ui/components/UILeaderboardPlayerSmallPanel.tga"
				self.uiPanel.rectangle = { 0, 0, 310, 70 }
			else
				self.uiPanel.background = "base:texture/ui/components/UILeaderboardPlayerPanel.tga"
				self.uiPanel.rectangle = { 0, 0, 380, 70 }
			end			
		end

	end

end

-- __dtor ------------------------------------------------------------------

function UILeaderboardItem:__dtor()
end

-- CreateGrid --------------------------------------------------------------

function UILeaderboardItem:BuildItem()

    self.challenger._DataChanged:Add(self, self.OnDataChanged)

    if (self.challenger:IsKindOf(UTTeam)) then

		-- ITERATIF please

		self.rankedList = {}
        table.foreachi(self.challenger.players, function(index, player)

            player._DataChanged:Add(self, self.OnDataChanged)

	        local uiLeaderboardItem = self:AddComponent(UILeaderboardItem:New(self.uiLeaderboard, player), "uiLeaderboardItem" .. index)
		    table.insert(self.rankedList, uiLeaderboardItem)
			uiLeaderboardItem.ranking = index
			uiLeaderboardItem.team = self
			uiLeaderboardItem:BuildItem()

        end )
		self:Sort(true)

    end

end

-- Draw --------------------------------------------------------------------

function UILeaderboardItem:Draw()

    -- blend color is there to gray out disconnected players,
    -- warning: blend color has alpha and is a 4f component

    local blendColor = { 1.0, 1.0, 1.0, 1.0 }

    if (activity.category ~= UTActivity.categories.single and self.challenger:IsKindOf(UTPlayer)) then
        blendColor = self.challenger.rfGunDevice and blendColor or { 0.70, 0.65, 0.60, 0.85 }
        self.uiPanel.color = blendColor
    end

	-- special background

	if (self.challenger:IsKindOf(UTTeam)) then

		if ((#activity.players > 8) and (#activity.teams > 2)) then

			quartz.system.drawing.pushcontext()
			quartz.system.drawing.loadtranslation(unpack(self.rectangle))
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
			quartz.system.drawing.loadtexture("base:texture/ui/Leaderboard_Line_Bg.tga")
			quartz.system.drawing.drawtextureh(-35, 0, 385, 8 + 35 * #self.challenger.players)
			quartz.system.drawing.pop()

		end

	end

    UIMultiComponent.Draw(self)

    --

	quartz.system.drawing.pushcontext()
    quartz.system.drawing.loadtranslation(unpack(self.rectangle))

	-- panel

	if (self.uiPanel) then
		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
		quartz.system.drawing.loadtexture(self.uiPanel.background)
		quartz.system.drawing.drawtexture(unpack(self.uiPanel.rectangle))
	end

	if (self.challenger:IsKindOf(UTTeam)) then

		-- score zone
		
		if ((#activity.players > 8) and (#activity.teams > 2)) then

			local position = (25 + 16 * #self.challenger.players) - 50
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
			quartz.system.drawing.loadtexture("base:texture/ui/Leaderboard_Score_Bg.tga")
			quartz.system.drawing.drawtexture(-105, position + 35, -10, position + 94)

		end

		-- borders

		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
        quartz.system.drawing.loadtexture("base:texture/ui/components/" .. self.teamColor[self.challenger.index][1])
		if (#activity.players > 8) then
			if (#activity.teams <= 2) then
				quartz.system.drawing.drawwindow(-45, 0, -5, 35 + 35 * #self.challenger.players)
			else
				quartz.system.drawing.drawwindow(-45, 0, -5, 8 + 35 * #self.challenger.players)
			end
		else
			quartz.system.drawing.drawwindow(-45, 0, -5, 25 + 64 * #self.challenger.players)
		end

		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
        quartz.system.drawing.loadtexture("base:texture/ui/components/" .. self.teamColor[self.challenger.index][2])
        
		if (#activity.players > 8) then
			if (#activity.teams <= 2) then
				quartz.system.drawing.drawwindow(380 + 5, 0, 380 + 15, 35 + 35 * #self.challenger.players)
			else
				quartz.system.drawing.drawwindow(380 + 5, 0, 380 + 15, 8 + 35 * #self.challenger.players)
			end
		else
			quartz.system.drawing.drawwindow(380 + 5, 0, 380 + 15, 25 + 64 * #self.challenger.players)
		end

		if ((#activity.teams <= 2) or (#activity.players <= 8)) then
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
			quartz.system.drawing.loadtexture("base:texture/ui/" .. self.teamColor[self.challenger.index][3])
			quartz.system.drawing.drawtexture(2, 0, 2 + 378, 0 + 25)
		end

		-- name

		if ((#activity.players <= 8) or (#activity.teams <= 2)) then
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
			quartz.system.drawing.loadfont(UIComponent.fonts.header)
			quartz.system.drawing.drawtextjustified(self.challenger.profile.name, quartz.system.drawing.justification.left, unpack({12, 0, 12 + 240, 0 + 20 }))
		end

		--score

		--quartz.system.drawing.loadcolor3f(unpack(self.challenger.profile.color))
		if (self.uiLeaderboard.showRanking) then

			if ((#activity.players <= 8) or (#activity.teams <= 2)) then
				quartz.system.drawing.loadfont(UIComponent.fonts.header)
				quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
				quartz.system.drawing.drawtextjustified(self.challenger.data.heap.score, quartz.system.drawing.justification.right, unpack({300, 0, 370, 0 + 20 }))
			else
				local position = (25 + 16 * #self.challenger.players)
				quartz.system.drawing.loadfont(UIComponent.fonts.header)
				quartz.system.drawing.loadcolor3f(unpack(self.challenger.profile.color))
				quartz.system.drawing.drawtextjustified(self.challenger.data.heap.score, quartz.system.drawing.justification.center, unpack({-110, position + 20,  -40, position + 40 }))	
			end

		end

		-- some informations

			local offset = 0
			table.foreachi(self.uiLeaderboard.fields, function(index, field)

				if (field.icon) then

					quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
					quartz.system.drawing.loadtexture(field.icon)
					if ((#activity.players <= 8) or (#activity.teams <= 2)) then
						quartz.system.drawing.drawtexture(200 + offset, 10, 200 + offset + 32, 10 + 32)
					else
						quartz.system.drawing.drawtexture(200 + offset, -10, 200 + offset + 32, -10 + 32)
					end

				end

				offset = offset + 40

			end )

		-- icon

		local position
		if (#activity.players > 8) then
			position = (25 + 16 * #self.challenger.players) - 50
		else
			position = (25 + 32 * #self.challenger.players) - 40
		end
		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
        quartz.system.drawing.loadtexture(self.challenger.profile.icon)
        quartz.system.drawing.drawtexture(-120, position, -120 + 120, position + 80)

	else
	
		-- hud + player name + icon

		local offset = 10
		if (self.challenger.team or not self.uiLeaderboard.largePanel) then
			offset = 5
		end

		quartz.system.drawing.loadcolor4f(unpack(blendColor))
		if (self.challenger.rfGunDevice) then quartz.system.drawing.loadtexture("base:texture/ui/pictograms/64x/hud_" .. self.challenger.rfGunDevice.classId .. ".tga")
		else quartz.system.drawing.loadtexture("base:texture/ui/pictograms/64x/hud_guest.tga")
		end
		quartz.system.drawing.drawtexture(55, offset + 6, 55 + 32, offset + 6 + 32)

		quartz.system.drawing.loadcolor4f(unpack(blendColor))
		quartz.system.drawing.loadtexture("base:texture/Avatars/80x/" .. (self.challenger.data.heap.icon or self.challenger.profile.icon))
		if (self.challenger.team) then
			quartz.system.drawing.drawtexture(10, offset - 10, 10 + 60, offset + 50)
		else
			quartz.system.drawing.drawtexture(-10, offset - 20, -10 + 80, offset - 20 + 80)
		end

		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
		quartz.system.drawing.loadfont(UIComponent.fonts.default)
		quartz.system.drawing.drawtext(self.challenger.profile.name, 90, offset + 18 )

		-- some informations

			local offsetX = 0
			table.foreachi(self.uiLeaderboard.fields, function(index, field)

				if ((not self.challenger.team) and field.icon) then

					quartz.system.drawing.loadcolor4f(unpack(blendColor))
					quartz.system.drawing.loadtexture(field.icon)
					quartz.system.drawing.drawtexture(200 + offsetX, offset - 20, 200 + offsetX + 32, offset - 20 + 32)

				end

				quartz.system.drawing.loadcolor3f(unpack(self.challenger.rfGunDevice and field.color or UIComponent.colors.darkgray))
				quartz.system.drawing.loadfont(field.font or UIComponent.fonts.default)

                local justification = field.justification or quartz.system.drawing.justification.center
                justification = quartz.system.bitwise.bitwiseor(justification, quartz.system.drawing.justification.singlelineverticalcenter)

                local rectangle
				if (field.font == UIComponent.fonts.header) then rectangle = { (field.position or (200 + offsetX)) - 44, offset + 14, (field.position or (200 + offsetX)) + 72, offset + 14 + 22 }
				else rectangle = { (field.position or (200 + offsetX)) - 44, offset + 16, (field.position or (200 + offsetX)) + 72, offset + 16 + 22 }
				end

                rectangle = { (field.position or (200 + offsetX)) - 44, offset + 16, (field.position or (200 + offsetX)) + 72, offset + 16 + 18 }

                local animationData = self.animationData[field.key]
                if (animationData) then

                    local time = quartz.system.time.gettimemicroseconds()
                    local elapsedTime = time - animationData.time
                    animationData.time, animationData.angle = time, math.max(0.0, animationData.angle - elapsedTime * 0.000180 * 4)

                    -- scaling depends on text justification

			        local w, h = quartz.system.drawing.gettextdimensions(self.data[field.key])

                    --if (0 ~= quartz.system.bitwise.bitwiseand(justification, quartz.system.drawing.justification.bottom)) then rectangle[2] = rectangle[4] - h
                    --elseif (0 ~= quartz.system.bitwise.bitwiseand(justification, quartz.system.drawing.justification.singlelineverticalcenter)) then rectangle[2] , rectangle[4] = rectangle[2] + (rectangle[4] - rectangle[2] - h) * 0.5, rectangle[4] - (rectangle[4] - rectangle[2] - h) * 0.5
                    --else rectangle[4] = rectangle[2] + h
                    --end

                    if (0 ~= quartz.system.bitwise.bitwiseand(justification, quartz.system.drawing.justification.right)) then rectangle[1] = rectangle[3] - w
                    elseif (0 ~= quartz.system.bitwise.bitwiseand(justification, quartz.system.drawing.justification.center)) then rectangle[1], rectangle[3] = rectangle[1] + (rectangle[3] - rectangle[1] - w) * 0.5, rectangle[3] - (rectangle[3] - rectangle[1] - w) * 0.5
                    else rectangle[3] = rectangle[1] + w
                    end

			        --justification = quartz.system.drawing.justification.center + quartz.system.drawing.justification.singlelineverticalcenter

                    --quartz.system.drawing.loadtexture("base:texture/ui/components/uipanel07.tga")
                    --quartz.system.drawing.drawtexture(unpack(rectangle))

                    local scale = 1.0 + math.sin(animationData.angle * 3.141592625 / 180.0) * 0.5
			        quartz.system.drawing.loadtextscale(scale)

			    end

				quartz.system.drawing.drawtextjustified(self.data[field.key], justification, unpack(rectangle))

                if (animationData) then
			        quartz.system.drawing.loadtextscale(1.0) -- restore original scaling
			        if (0.0 >= animationData.angle) then self.animationData[field.key] = nil -- kill animation when over
			        end
			    end

				offsetX = offsetX + 40

			end )

	end

	quartz.system.drawing.pop()

end

-- OnDataChanged  ----------------------------------------------------------

function UILeaderboardItem:OnDataChanged(_entity, _key, _value)

	if (self.uiLeaderboard.itemsSortField == _key) then

		if (self.team) then
			self.team:Sort()
		else
			self.uiLeaderboard:Sort()
		end

	end

    --[[
    local field = nil
    for _, _field in ipairs(self.uiLeaderboard.fields) do
        if (_field.key == _key) then field = _field ; break
        end
    end

    if (field) then
        local animationData = self.animationData[_key]
        if (not animationData) then
            self.animationData[_key] = { angle = 180.0, time = quartz.system.time.gettimemicroseconds() }
        else
            animationData.angle = math.max(animationData.angle, 180.0 - animationData.angle)
            --animationData.angle = 90.0
            animationData.time = quartz.system.time.gettimemicroseconds()
        end
    end
    --]]

end

-- RemoveDataChangedEvents ------------------------------------------------

function UILeaderboardItem:RemoveDataChangedEvents()

	self.challenger._DataChanged:Remove(self, self.OnDataChanged)

    if (0 < #activity.teams) then

        table.foreachi(self.challenger.players, function(index, player)
            player._DataChanged:Remove(self, self.OnDataChanged)
        end )

    end

end

-- Sort ---------------------------------------------------------------------

function UILeaderboardItem:Sort(init)

	-- sorting now !

	function sorting(item1, item2)
		if (item1.data[self.uiLeaderboard.itemsSortField] > item2.data[self.uiLeaderboard.itemsSortField]) then 
			return true
		elseif ((item1.data[self.uiLeaderboard.itemsSortField] == item2.data[self.uiLeaderboard.itemsSortField]) and (item1.ranking < item2.ranking)) then 
			return true
		end
	end

	table.sort(self.rankedList, sorting)
	
	-- then compute new position

    for index, item in ipairs(self.rankedList) do

        item.ranking = index

		-- make a move ...

		if (init) then
			if (#activity.players > 8) then
				if (#activity.teams <= 2) then
					item:MoveTo(0, 27 + 35 * (index - 1))
				else
					item:MoveTo(0, 0 + 35 * (index - 1))
				end
			else
				item:MoveTo(0, 27 + 64 * (index - 1))
			end
		else

			if (item.mvtFx) then

				UIManager:RemoveFx(item.mvtFx)
				item.mvtFx = nil

			end
			if (#activity.players > 8) then
				item.mvtFx = UIManager:AddFx("position", { duration = 0.8, __self = item, from = { 0, item.rectangle[2]}, to = { 0, 27 + 35 * (index - 1) }, type = "descelerate" })
			else
				item.mvtFx = UIManager:AddFx("position", { duration = 0.8, __self = item, from = { 0, item.rectangle[2]}, to = { 0, 27 + 64 * (index - 1) }, type = "descelerate" })
			end
		end

	end

end