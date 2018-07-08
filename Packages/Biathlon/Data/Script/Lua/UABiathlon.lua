
--[[--------------------------------------------------------------------------
--
-- File:			UTActivity_Biathlon.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 29, 2010
--
------------------------------------------------------------------------------
--
-- Description:     test activity
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity"

--[[ Class -----------------------------------------------------------------]]

UTClass.UABiathlon(UTActivity)

-- state dependencies

UABiathlon.State = {}

	require "UABiathlon.State.RoundLoop"

-- default

UABiathlon.bitmap = "base:texture/ui/loading_Biathlon.tga"

-- __ctor --------------------------------------------------------------------

function UABiathlon:__ctor(...)

	-- properties

    self.name = l"title027"
    self.category = UTActivity.categories.closed
	--self.teamdefaults = true
    self.handicap = true

    self.textScoring = l"score019"
    self.textRules = l"rules006"
    self.iconBanner = "base:texture/ui/Ranking_Bg_Biathlon.tga"
    
	-- scoringField
	
    self.scoringField = {
		{"hit", "base:texture/ui/icons/32x/hit.tga", l"iconrules004"},
		{"score", nil, nil, 280, quartz.system.drawing.justification.right, UIComponent.fonts.header, UIComponent.colors.orange},
	}

    -- settings

    self.settings = {

        [1] = { title = l"titlemen006", options = {

         	[1] = { displayMode = nil, label = l"goption001", tip = l"tip027", choices = { { value = 1.0 }, { value = 1.5 }, { value = 2.0 }, { value = 3 }, { value = 4 }, { value = 5 }, { value = 6 }, { value = 8 }, { value = 10 } }, index = "playtime", },
            [2] = { label = l"goption064", tip = l "tip029", choices = { { value = 2 }, { value = 4, conditional = true } }, index = "numberOfBase", condition = function (self) return (1 == game.settings.addons.medkitPack) end },
          --[3] = { label = l"goption004", tip = l"tip028", choices = { { value = 6 }, { value = 9 }, { value = 12 }, { value = 15 }, { value = 18 }, { value = 255, text = "", icon = "base:texture/ui/components/uiradiobutton_infinity.tga" } }, index = "ammunitions", },
 
            },
        },
        


        -- keyed settings

        playtime = 1,
		numberOfBase = 2,
        ammunitions = 9,

		-- no team

        numberOfTeams = 0,
    }
    
    -- playground
    -- !! TABLE FORMAT : { [numberofplayer] = { ["ITEM_BITMAP"] = { category = "string", priority = number, size = number, positions = { { number, number }, ... }, title = "string", text = "string", condition = function() }, ... }

    self.playground = {

        selection = function (self) return activity.settings.numberOfBase end,

        [2] = {

            RF03 = { priority = 1, positions = { { 75, 100 }, }, title = l"oth056" ..  " (" .. l"oth027" .. ")", text = string.format(l"psexp001"), },
            RF04 = { priority = 2, positions = { { 455, 100 }, }, title = l"oth057" ..  "  (" .. l"oth028" .. ")", text = string.format(l"psexp002"), },
            --Start = { positions = { { 265, 100 }, }, title = "Med-kit", text = string.format("Blah blah Med-kit"), },
            RF09 = { positions = { { 265, 250 }, }, title = "UbiConnect", text = string.format(l"psexp013"), },

        },

        [4] = {

            RF03 = { priority = 1, positions = { { 120, 150 }, }, title = l"oth056" ..  " (" .. l"oth027" .. ")", text = string.format(l"psexp001"), },
            RF04 = { priority = 2, positions = { { 200, 60 }, }, title = l"oth057" ..  " (" .. l"oth028" .. ")", text = string.format(l"psexp002"), },
            RF05 = { priority = 3, positions = { { 330, 60 }, }, title = l"oth058" ..  " (" .. l"oth029" .. ")", text = string.format(l"psexp003"), },
            RF06 = { priority = 4, positions = { { 410, 150 }, }, title = l"oth059" ..  " (" .. l"oth030" .. ")", text = string.format(l"psexp004"), },
            --Start = { positions = { { 265, 100 }, }, title = "Med-kit", text = string.format("Blah blah Med-kit"), },
            RF09 = { positions = { { 265, 250 }, }, title = l"oth055", text = string.format(l"psexp013"), },

        },
    }

    -- ?? CONFIG DATA SEND WITH RF 

    self.configData = {

		"ammunitions",
		"numberOfBase",
		"team"

    }

    -- details columms descriptor

	self.detailsDescriptor = {
		information = {
			{ key = "detailsScore", icon = "base:texture/ui/Icons/32x/score.tga", tip = l"tip072" },
			{ key = "detailAccuracy", icon = "base:texture/ui/Icons/32x/precision.tga", tip = l"tip073" }
		},
		details = {
			{ key = "name", width = 175, style = UIGridLine.RowTitleCellStyle },
			{ key = "hitByName", width = 75, style = UIGridLine.RowTitleCellStyle, icon = "base:texture/ui/Icons/32x/Hit.tga", tip = l"tip068"},
			{ key = "killByName", width = 50, style = UIGridLine.RowTitleCellStyle, icon = "base:texture/ui/Icons/32x/Death.tga", tip = l"tip070" },
		}
	}

    -- overriden states

    self.states["roundloop"] = UABiathlon.State.RoundLoop:New(self)
    
end

-- __dtor --------------------------------------------------------------------

function UABiathlon:__dtor()
end

-- InitEntityBakedData  ------------------------------------------------------

function UABiathlon:InitEntityBakedData(entity, ranking)

	UTActivity:InitEntityBakedData(entity, ranking)

	entity.data.baked.score = 0
	entity.data.baked.ranking = ranking

	-- player 

	entity.data.baked.accuracy = 0
	entity.data.baked.nbShot = 0
	entity.data.baked.timeshit = 0
	entity.data.baked.hitByName = {}
	entity.data.baked.killByName = {}

end

-- InitEntityHeapData --------------------------------------------------------------------

function UABiathlon:InitEntityHeapData(entity, ranking)

	UTActivity:InitEntityHeapData(entity, ranking)

	if (not game.gameMaster.ingame) then
		entity.data.heap.score = 0
		entity.data.heap.ranking = ranking
	end

	-- data config

	entity.gameplayData = { 0x00, 0x00 }
	entity.data.heap.numberOfBase = activity.settings.numberOfBase
	entity.data.heap.team = entity.profile.team


		entity.data.heap.lifePoints = 1000
		entity.data.heap.ammunitions = activity.settings.ammunitions
		entity.data.heap.clips = activity.settings.clips

	entity.data.heap.audio = game.settings.audio["volume:blaster"]
	entity.data.heap.beamPower = game.settings.ActivitySettings.beamPower

	if (not game.gameMaster.ingame) then
		-- statistics

		entity.data.heap.nbShot = 0
		entity.data.heap.hit = 0
		entity.data.heap.death = 0
		entity.data.heap.accuracy = 0
		entity.data.heap.isDead = 0
		entity.data.heap.nbRespawn = 0
		entity.data.heap.nbAmmoPack = 0
		entity.data.heap.nbMediKit = 0
		entity.data.heap.timeshit = 0
		entity.data.heap.hitByName = {}
		entity.data.heap.killByName = {}
	
		-- gameMaster
	
		entity.data.heap.hitLost = 0
		entity.data.heap.lastPlayerShooted = {}
		entity.data.heap.nbHitLastPlayerShooted = 0
	end
	
end

-- UpdateEntityBakedData  ---------------------------------------------

function UABiathlon:UpdateEntityBakedData(entity, ranking)

	entity.data.baked.score = (entity.data.baked.score or 0) + entity.data.heap.score

	-- statistics

	entity.data.baked.nbShot = (entity.data.baked.nbShot or 0) + entity.data.heap.nbShot
	entity.data.baked.hit = (entity.data.baked.hit or 0) + entity.data.heap.hit
	entity.data.baked.death = (entity.data.baked.death or 0) + entity.data.heap.death
	if (entity.data.baked.nbShot > 0) then
		entity.data.baked.accuracy = (100 * (entity.data.baked.hit + entity.data.baked.death) / entity.data.baked.nbShot)
	else
		entity.data.baked.accuracy = 0
	end
	entity.data.baked.detailsScore = entity.data.baked.score .. " " .. l"oth068"
	entity.data.baked.detailAccuracy = string.format("%0.1f", entity.data.baked.accuracy) .. "%"
	entity.data.baked.nbRespawn = (entity.data.baked.nbRespawn or 0) + entity.data.heap.nbRespawn
	entity.data.baked.nbAmmoPack = (entity.data.baked.nbAmmoPack or 0) + entity.data.heap.nbAmmoPack
	entity.data.baked.nbMediKit = (entity.data.baked.nbMediKit or 0) + entity.data.heap.nbMediKit
	entity.data.baked.timeshit = (entity.data.baked.timeshit or 0) + entity.data.heap.timeshit
	
	for player, value in pairs(entity.data.heap.hitByName) do
		entity.data.baked.hitByName[player] = (entity.data.baked.hitByName[player] or 0) + value
	end
	for player, value in pairs(entity.data.heap.killByName) do
		entity.data.baked.killByName[player] = (entity.data.baked.killByName[player] or 0) + value
	end

	-- details data

	entity.data.details = {}
	for i, player in ipairs(activity.players) do

		local details = {}
		details.name = player.profile.name
		details.hitByName = (entity.data.baked.hitByName[player.nameId] or 0)
		details.killByName = (entity.data.baked.killByName[player.nameId] or 0)
		entity.data.details[player.nameId] = details
	end

end
