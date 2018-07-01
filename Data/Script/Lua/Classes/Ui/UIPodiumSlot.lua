
--[[--------------------------------------------------------------------------
--
-- File:            UIPodiumSlot.lua
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

require "Ui/UIComponent"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIPodiumSlot(UIComponent)

require "Ui/UILeaderboard"

-- default

UIPodiumSlot.medalIcons = {

    [1] = "base:texture/ui/ranking_medal_gold.tga",
    [2] = "base:texture/ui/ranking_medal_silver.tga",
    [3] = "base:texture/ui/ranking_medal_bronze.tga",

}

UIPodiumSlot.rankingPictures = {

    [1] = "base:texture/ui/Rankings_Arrow1.tga",
    [2] = "base:texture/ui/Rankings_Arrow2.tga",
    [3] = "base:texture/ui/Rankings_Arrow3.tga",

}

-- __ctor --------------------------------------------------------------------


function UIPodiumSlot:__ctor()
	self.rankVector = {0, 0}
end

-- __dtor --------------------------------------------------------------------

function UIPodiumSlot:__dtor()
end

-- Build ---------------------------------------------------------------------

function UIPodiumSlot:Build(challenger, ranking, size, realRanking, teamPosition, teamScore)
		
	local start = -0.8 + ranking * 0.9
	
	self.playerVectorY = 400
	self.size = size + 3
	self.width = 140
	self.nameOffset = { 105, -40} 
	self.scoreOffset = { 340, -40} 
	
	if (#activity.teams == 0) then
		
		self.challenger = challenger
		if (self.size == 1) then
			self.playerVectorY = 200
		elseif (self.size == 2) then
			self.playerVectorY = 280
		else
			self.playerVectorY = 400
		end
		
	else	
		self.team = challenger
		self.teamPosition = teamPosition
		self.teamScore = teamScore
		self.width = 80 + 30 * #self.team.players
		self.playerVectorY = 280 + self.size * 50
		self.scoreOffset = { 360, -68} 
		self.nameOffset = { 110, -32} 
	end
	
	self.playerVectorX = 1000
	self.ranking = ranking
	self.realRanking = realRanking
	self.visible = false

	self.rankVectorX = -100	
		
	self.alphaMedal = 0 
	self.scaleIcon = 1 	
		
	self.fxs = {}
	self.fxs[1] = UIManager:AddFx("callback", { timeOffset = start, 
	__function = function() 
	
		quartz.framework.audio.loadsound("base:audio/ui/ranking.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()
		
		self.visible = true 
	
	end})
	self.fxs[2] = UIManager:AddFx("value", { timeOffset = start, duration = 0.2, __self = self, value = "rankVectorX", from = -100, to = 50 + self.realRanking * 50 , })
	self.fxs[3] = UIManager:AddFx("value", { timeOffset = start, duration = 0.2, __self = self, value = "playerVectorX", from = 1000, to = 350 + self.realRanking * 50 , })
	self.fxs[4] = UIManager:AddFx("value", { timeOffset = start + 0.2, duration = 0.1, __self = self, value = "scaleIcon", from = 0, to = 5, type = "descelerate" })
	self.fxs[5] = UIManager:AddFx("value", { timeOffset = start + 0.3, duration = 0.15, __self = self, value = "scaleIcon", from = 5, to = 0, type = "accelerate" })
	self.fxs[6] = UIManager:AddFx("value", { timeOffset = start + 0.45, duration = 0.2, __self = self, value = "alphaMedal", from = 0, to = 1 })
	
	if (#activity.teams == 0) then
		if (self.size == 2) then
			self.fxs[7] = UIManager:AddFx("value", { timeOffset = start + 0.7, duration = 0.3, __self = self, value = "playerVectorY", from = self.playerVectorY, to = self.ranking * self.width , type = "accelerate"})
		elseif (self.size > 2) then
			self.fxs[7] = UIManager:AddFx("value", { timeOffset = start + 0.7, duration = 0.3, __self = self, value = "playerVectorY", from = self.playerVectorY, to = -80 + self.ranking * self.width , type = "accelerate"})
		end
	else
		self.fxs[7] = UIManager:AddFx("value", { timeOffset = start + 0.7, duration = 0.3, __self = self, value = "playerVectorY", from = self.playerVectorY, to = 180 - self.size * 40 + self.teamPosition, type = "accelerate"})
	end
	

end

-- Destroy ---------------------------------------------------------------------

function UIPodiumSlot:Destroy()
	
	print("UIPodiumSlot:Destroy")

	for i, fx in ipairs(self.fxs) do
		UIManager:RemoveFx(fx)
	end

end


-- Draw --------------------------------------------------------------------

function UIPodiumSlot:Draw()

	color = UIComponent.colors.white
	
	if (self.realRanking < 4) then
		quartz.system.drawing.loadcolor3f(unpack(color))		
		quartz.system.drawing.loadtexture(self.rankingPictures[self.realRanking])
		quartz.system.drawing.drawtexture(self.rankVectorX, self.playerVectorY + 10)
	       
	    
		quartz.system.drawing.loadalpha(self.alphaMedal)
		local rectIcon = {-150 + -128 + self.playerVectorX + 10 * self.alphaMedal, -5 + self.playerVectorY + 10 * self.alphaMedal,-150 + self.playerVectorX - 10 * self.alphaMedal, -5 + self.playerVectorY - 10 * self.alphaMedal + 128}

		quartz.system.drawing.loadtexture(UIPodiumSlot.medalIcons[self.realRanking])
		quartz.system.drawing.drawtexture(unpack(rectIcon))
	    
		quartz.system.drawing.loadalpha(1)
    end
                    
    if (self.challenger) then
    
		local rectangleLine = {self.playerVectorX, self.playerVectorY + 40, self.playerVectorX + 400, self.playerVectorY + 40 + 40}

		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
		quartz.system.drawing.loadtexture("base:texture/ui/components/uigridline_background01.tga")
		quartz.system.drawing.drawwindow(unpack(rectangleLine))
	
		local rectangle = {self.playerVectorX - 20, self.playerVectorY + 10, self.playerVectorX + 420, self.playerVectorY + 110}
		
		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
		quartz.system.drawing.loadtexture("base:texture/ui/components/uipanel05.tga")
		quartz.system.drawing.drawwindow(unpack(rectangle))
    
		if (self.challenger.rfGunDevice and self.challenger.rfGunDevice.classId) then
			local rectangleHud = {self.playerVectorX + 35, self.playerVectorY + 30, self.playerVectorX + 99, self.playerVectorY + 94}
			quartz.system.drawing.loadtexture("base:texture/ui/pictograms/64x/Hud_" .. self.challenger.rfGunDevice.classId .. ".tga")
			quartz.system.drawing.drawtexture(unpack(rectangleHud))
		end
		
		local fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter

		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
		quartz.system.drawing.loadfont(UIComponent.fonts.title)
		quartz.system.drawing.drawtextjustified(self.challenger.profile.name, fontJustification, self.playerVectorX + self.nameOffset[1], self.playerVectorY + self.nameOffset[2], self.playerVectorX + 400 + self.nameOffset[1], self.playerVectorY + 200 + self.nameOffset[2])
	    
		if (self.challenger.data and self.challenger.data.baked and self.challenger.data.baked.score and activity.dontDisplayScore == nil) then
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.orange))
			quartz.system.drawing.loadfont(UIComponent.fonts.title) 
			quartz.system.drawing.drawtextjustified(self.challenger.data.baked.score, fontJustification, self.playerVectorX + self.scoreOffset[1], self.playerVectorY + self.scoreOffset[2], self.playerVectorX + 400 + self.scoreOffset[1], self.playerVectorY + 200 + self.scoreOffset[2])
		end
		
		local rectIcon = {-140 + self.playerVectorX - 10 * self.scaleIcon, self.playerVectorY - 40 - 10 * self.scaleIcon, -160 + self.playerVectorX + 200 + 10 * self.scaleIcon, self.playerVectorY - 40 + 200 + 10 * self.scaleIcon}
		
		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
		quartz.system.drawing.loadtexture("base:texture/avatars/256x/" .. self.challenger.profile.icon)
		quartz.system.drawing.drawtexture(unpack(rectIcon))
		
	elseif (self.team) then
		
		local rectangle = {self.playerVectorX - 20, self.playerVectorY + 10, self.playerVectorX + 420, self.playerVectorY + 60 + 30 * #self.team.players}
		
		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
		quartz.system.drawing.loadtexture("base:texture/ui/components/uipanel05.tga")
		quartz.system.drawing.drawwindow(unpack(rectangle))		
		
		local rectangleHeader = {self.playerVectorX - 20, self.playerVectorY + 10, self.playerVectorX + 420, self.playerVectorY + 50}
		
		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
		quartz.system.drawing.loadtexture("base:texture/ui/components/uipanel08.tga")
		quartz.system.drawing.drawwindow(unpack(rectangleHeader))
	
		local rectangleLine = {self.playerVectorX, self.playerVectorY + 20, self.playerVectorX + 350, self.playerVectorY + 20 + 23}

		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
		quartz.system.drawing.loadtexture("base:texture/ui/leaderboard_" .. self.team.profile.teamColor  .. "line.tga")
		quartz.system.drawing.drawtexture(unpack(rectangleLine))
		
		local fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter
		
		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
		quartz.system.drawing.loadfont(UIComponent.fonts.header) 
		quartz.system.drawing.drawtextjustified(self.team.profile.name, fontJustification, self.playerVectorX + self.scoreOffset[1] - 330, self.playerVectorY + self.scoreOffset[2], self.playerVectorX + self.scoreOffset[1] + 70, self.playerVectorY + 200 + self.scoreOffset[2])
		
		
		if (self.teamScore) then
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors[self.team.profile.teamColor]))
			quartz.system.drawing.loadfont(UIComponent.fonts.title) 
			quartz.system.drawing.drawtextjustified(self.teamScore, fontJustification, self.playerVectorX + self.scoreOffset[1], self.playerVectorY + self.scoreOffset[2], self.playerVectorX + 400 + self.scoreOffset[1], self.playerVectorY + 200 + self.scoreOffset[2])
		end
		
		for i, player in pairs(self.team.players) do
			local rectangleLine = {self.playerVectorX, self.playerVectorY + 30 + 30 * i, self.playerVectorX + 400, self.playerVectorY + 46 + 30 * i}

			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
			quartz.system.drawing.loadtexture("base:texture/ui/components/uigridline_background01.tga")
			quartz.system.drawing.drawwindow(unpack(rectangleLine))
			
			
			local rectIcon = {rectangleLine[1] + 25,rectangleLine[2] - 15,rectangleLine[1] + 35 + 32,rectangleLine[2] - 5 + 32}
			
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
			quartz.system.drawing.loadtexture("base:texture/avatars/42x/" .. player.profile.icon)
			quartz.system.drawing.drawtexture(unpack(rectIcon))		

			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
			quartz.system.drawing.loadfont(UIComponent.fonts.header)
			quartz.system.drawing.drawtextjustified(player.profile.name, fontJustification, self.playerVectorX + self.nameOffset[1], self.playerVectorY + self.nameOffset[2] - 30 + 30 * i, self.playerVectorX + 400 + self.nameOffset[1], self.playerVectorY + 200 + self.nameOffset[2] + 30 * i - 30)

			if (player.rfGunDevice and player.rfGunDevice.classId) then
				local rectangleHud = {self.playerVectorX + 70, self.playerVectorY + 20 + 30 * i, self.playerVectorX + 102, self.playerVectorY + 52 + 30 * i}
				quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
				quartz.system.drawing.loadtexture("base:texture/ui/pictograms/64x/hud_" .. player.rfGunDevice.classId .. ".tga")
				quartz.system.drawing.drawtexture(unpack(rectangleHud))
			end
			
			if (player.data and player.data.baked and player.data.baked.score) then
				quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.orange))
				quartz.system.drawing.loadfont(UIComponent.fonts.header) 
				quartz.system.drawing.drawtextjustified(player.data.baked.score, fontJustification, self.playerVectorX + self.nameOffset[1] + 220, self.playerVectorY + self.nameOffset[2] + 30 * i - 30, self.playerVectorX + 620 + self.nameOffset[1], self.playerVectorY + 200 + self.nameOffset[2] + 30 * i - 30)
			end
			
		end	
		
		local rectIcon = {-130 + self.playerVectorX - 10 * self.scaleIcon, self.playerVectorY - 10 - 10 * self.scaleIcon, -130 + self.playerVectorX + 168 + 10 * self.scaleIcon, self.playerVectorY - 10 + 100 + 10 * self.scaleIcon}
		
		quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
		quartz.system.drawing.loadtexture(self.team.profile.icon)
		quartz.system.drawing.drawtexture(unpack(rectIcon))
		
	end
	
end
