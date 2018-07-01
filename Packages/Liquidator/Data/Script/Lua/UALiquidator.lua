
--[[--------------------------------------------------------------------------
--
-- File:			UALiquidator.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            November 18, 2010
--
------------------------------------------------------------------------------
--
-- Description:     test activity
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity"

--[[ Class -----------------------------------------------------------------]]

UTClass.UALiquidator(UTActivity)

-- state dependencies

UALiquidator.State = {}

	require "UALiquidator.State.RoundLoop"
	require "UALiquidator.UIPlayerSlot"

-- default

UALiquidator.bytecodePath = "game:../packages/liquidator/data/script/bytecode/UALiquidator.ByteCode.lua"
UALiquidator.bitmap = "base:texture/ui/Loading_Liquidator.tga"

UALiquidator.maxNumberOfPlayer = 8
UALiquidator.minNumberOfPlayer = 3

UALiquidator.playerSlot = UALiquidator.UIPlayerSlot

UALiquidator.numberOfLiquidator = 0

-- __ctor --------------------------------------------------------------------

function UALiquidator:__ctor(...)

	-- activity name

    self.name = l"title014"
    self.category = UTActivity.categories.closed

	self.dontDisplayScore = true
    self.textScoring = l"score007"
    self.Ui.Title.textScoring.rectangle = { 20, 50, 640, 210 }
    self.Ui.Title.scoringOffset = 40
    self.textRules = l"rules009"
    self.iconBanner = "base:texture/ui/Ranking_Bg_Liquidator.tga"

	-- scoringField

    self.scoringField = {
		{"hit", "base:texture/ui/icons/32x/hit.tga", l"iconrules004"},
		{"death", "base:texture/ui/icons/32x/death.tga", l"iconrules003"},
		{"lifePoints", "base:texture/ui/icons/32x/heart.tga", l"iconrules002"},
		--{"score", nil, nil, 280, quartz.system.drawing.justification.right, UIComponent.fonts.header, UIComponent.colors.orange},
	}
	
    -- settings

    self.settings = {

        [1] = { title = l"titlemen006", options = {

            [1] = { displayMode = nil, label = l"goption001", tip = l"tip114", choices = { { value = 5 }, { value = 10 }, { value = 15 }, { value = 20 } }, index = "playtime", },
            [2] = { label = l"goption002", tip = l"tip025", choices = { { value = 0, displayMode = "large", text = "Auto"}, { value = 1, displayMode = "large", text = l"oth032" } }, index = "gameLaunch" },
            [3] = { label = l"goption003", tip = l"tip026", choices = { { value = 1, icon = "base:texture/ui/components/uiradiobutton_house.tga" }, { value = 2 }, { value = 3}, { value = 4 }, { value = 5, icon = "base:texture/ui/components/uiradiobutton_sun.tga" } }, index = "beamPower" },

            },
        },

--        [2] = { title = l"titlemen007", options = {
        [2] = { title = l"oth077", options = {

            [1] = { label = l"goption006", tip = l"tip115", choices = { { value = 10 }, { value = 15 }, { value = 19 } }, index = "lifePointsLiquidator", },
            [2] = { label = l"goption004", tip = l"tip028", choices = { { value = 20, text = "", icon = "base:texture/ui/components/uiradiobutton_infinity.tga" } }, index = "ammunitionsLiquidator", },
            [3] = { label = l"goption016", tip = l"tip117", choices = { { value = 5 }, { value = 10 } }, index = "invulnerabilityTimeLiquidator", },
            [4] = { displayMode = nil, label = l"goption013", tip = l"tip041", choices = { { value = 0, displayMode = "large", text = l"oth076" }, { value = 1, displayMode = "large", text = l"oth075"  } }, index = "teamFragLiquidator", },

            },
        },
        
--        [3] = { title = l"titlemen007", options = {
        [3] = { title = l"oth078", options = {        

            [1] = { label = l"goption004", tip = l"tip028", choices = { { value = 9 } }, index = "ammunitionsSurvivor", },
            [2] = { label = l"goption005", tip = l"tip118", choices = { { value = 3 } }, index = "clipsSurvivor", },
            [3] = { label = l"goption006", tip = l"tip119", choices = { { value = 3 }, { value = 5 }, { value = 7 } }, index = "lifePointsSurvivor", },
            [4] = { label = l"oth071", tip = l"tip123", choices = { { value = 5 }, { value = 10 }, { value = 15 } }, index = "timePenality", },
            [5] = { label = l"goption012", tip = l"tip121", choices = { { value = 0 } }, index = "respawnTimeSurvivor", },
            [6] = { displayMode = nil, label = l"goption013", tip = l"tip041", choices = { { value = 0, displayMode = "large", text = l"oth076" }, { value = 1, displayMode = "large", text = l"oth075"  } }, index = "teamFragSurvivor", },
            [7] = { displayMode = nil, label = l"goption007", tip = l"tip040", choices = { { value = 0, displayMode = "large", text = l"oth076" }, { value = 1, displayMode = "large", text = l"oth075"  } }, index = "swap", },

            },
        },        

        -- keyed settings

	    playtime = 5,
        gameLaunch = 0,
        beamPower = 3,        
        ammunitionsLiquidator = 20,
        ammunitionsSurvivor = 9,
        clipsSurvivor = 5,
        lifePointsLiquidator = 15,
        lifePointsSurvivor = 3,
        respawnTimeSurvivor = 0,
        swap = 0,
        numberOfTeams = 0,
        teamFragLiquidator = 0,
        teamFragSurvivor = 0,
        invulnerabilityTimeLiquidator = 10,
        timePenality = 10,

    }

    -- playground
    -- !! TABLE FORMAT : { [numberofplayer] = { ["ITEM_BITMAP"] = { category = "string", priority = number, size = number, positions = { { number, number }, ... }, title = "string", text = "string", condition = function() }, ... }

    self.playground = {

        [1] = { 

            RedArea = { priority = 20, size = 128, text = string.format(l"psexp032"), positions = { { 50, 150 }, }, },
            BlueArea = { priority = 20, size = 128, text = string.format(l"psexp035"), positions = { { 480, 150 }, }, },

            RF01 = { category = "Ammo", title = l"goption010", text = string.format(l"psexp014"), positions = { { 200, 50 }, }, condition = function (self) return (20 ~= activity.settings.ammunitions) end  },
            RF02 = { category = "Ammo2", title = l"goption010", text = string.format(l"psexp014"), positions = { { 200, 250 }, }, condition = function (self) return (20 ~= activity.settings.ammunitions) end  },
            RF03 = { priority = 1, title = l"oth056" ..  " (" .. l"oth027" .. ")", text = string.format(l"psexp031"), positions = { { 50, 150 }, }, },
            RF07 = { category = "Med-Kit", title = l"goption009", text = string.format(l"psexp015"), positions = { { 330, 50 }, }, condition = function (self) return (1 == game.settings.addons.medkitPack) end },
            RF08 = { category = "Med-Kit2", title = l"goption009", text = string.format(l"psexp015"), positions = { { 330, 250 }, }, condition = function (self) return (1 == game.settings.addons.medkitPack) end },
        },
    }

    -- ?? CONFIG DATA SEND WITH RF 

    self.configData = {

		"lifePoints",
		"ammunitions",
		"clips",
		"swap",
		"respawnTime",
		"liquidator",
		"teamFrag",
		"medkit",

    }    

    self.gameplayData = { 0x00, 0x00 }
    
	-- details columms descriptor

	self.detailsDescriptor = {
		information = {
			--{key = "detailsScore", icon = "base:texture/ui/Icons/32x/score.tga", tip = l"tip072" },
			{key = "detailAccuracy", icon = "base:texture/ui/Icons/32x/precision.tga", tip = l"tip073" }
		},
		details = {
			{key = "detailsTeam", width = 55, style = UIGridLine.ImageCellStyle:New(35, 10), preferredHeight = 10, preferredWidth = 35},
			{key = "name", width = 130, style = UIGridLine.RowTitleCellStyle},
			{key = "hitByName", width = 75, style = UIGridLine.RowTitleCellStyle, icon = "base:texture/ui/Icons/32x/Hit.tga", tip = l"tip068"},
			{key = "killByName", width = 50, style = UIGridLine.RowTitleCellStyle, icon = "base:texture/ui/Icons/32x/Death.tga", tip = l"tip070"},
		}
	}

    -- overriden states

    self.states["roundloop"] = UALiquidator.State.RoundLoop:New(self)
    
    -- ?? LES SETTINGS SONT RENSEIGNÉS DANS LE CONSTRUCTEUR DE L'ACTIVITÉ
    -- ?? LES PARAMÈTRES (DISPLAYMODE, TEXTE, ICONE...) DES COLONES DE GRID SONT RENSEIGNÉS DANS LE COMPOSANT DÉDIÉ DU LEADERBOARD
    -- ?? LES ATTRIBUTS - HEAP, BAKED - DES ENTITÉS SONT RENSEIGNÉS PAR 2 APPELS DE FONCTION DÉDIÉS DANS L'ACTIVITÉ (À SURCHARGER)
    -- ?? POUR LES DONNÉES DE CONFIGURATION DE BYTECODE, CE SERA SUREMENT PAREIL QUE POUR LES ATTRIBUTS = FONCTION DÉDIÉ (À SURCHARGER)
    -- ?? POUR LE LEADERBOARD:
    -- ??       - SURCHARGER LA PAGE QUI UTILISE LE LEADERBOARD STANDARD,
    -- ??       - RAJOUTER DES PARAMÈTRES (DISPLAYMODE, TEXTE, ICONE...) DES COLONES DE GRID SI NÉCESSAIRE EN + DE CEUX PAR DÉFAUT (LIFE, HIT, AMMO...)
    -- ??       - RENSEIGNER QUELS ATTRIBUTS ON SOUHAITE REPRÉSENTER PARMIS CEUX EXISTANT EN HEAP

end

-- __dtor --------------------------------------------------------------------

function UALiquidator:__dtor()
end

-- Check ---------------------------------------------------------------------

function UALiquidator:Check()

	-- check number of liquidator

	local numberOfLiquidator = self:GetLiquidatorNumber()
	if (((#activity.players < 6) and (numberOfLiquidator == 1)) or ((#activity.players >= 6) and (numberOfLiquidator == 2))) then

		return true

	else

		local uiPopup = UIPopupWindow:New()

		uiPopup.title = l"con035"
		if (numberOfLiquidator == 1) then
			uiPopup.text = l"tip125"
		else
			uiPopup.text = l"tip124"
		end
		

		-- buttons

        uiPopup.uiButton2 = uiPopup:AddComponent(UIButton:New(), "uiButton2")
        uiPopup.uiButton2.rectangle = UIPopupWindow.buttonRectangles[2]
	    uiPopup.uiButton2.text = l"but019"

		uiPopup.uiButton2.OnAction = function ()

			UIManager.stack:Pop()
			--activity:PostStateChange("revision", "bytecode")

		end

		UIManager.stack:Push(uiPopup)
		return false

	end

end

-- InitEntityBakedData  ------------------------------------------------------

function UALiquidator:InitEntityBakedData(entity, ranking)

	entity.data.baked.score = 0
	entity.data.baked.ranking = ranking

	-- init entity specific data

	if (entity:IsKindOf(UTTeam)) then

		-- team

		for i, player in ipairs(entity.players) do
			self:InitEntityBakedData(player, i)
		end

	else

        UTActivity:InitEntityBakedData(entity, ranking)

		-- player 

		entity.data.baked.accuracy = 0
		entity.data.baked.nbShot = 0
		entity.data.baked.nbRespawn = 0
		entity.data.baked.nbAmmoPack = 0
		entity.data.baked.nbMediKit = 0
		entity.data.baked.hitByName = {}
		entity.data.baked.killByName = {}

	end

end

-- InitEntityHeapData  -----------------------------------------------------

function UALiquidator:InitEntityHeapData(entity, ranking)

    -- !! INITIALIZE ALL HEAP DATA (RELEVANT DURING ONE MATCH ONLY)

	entity.data.heap.score = 0
	entity.data.heap.ranking = ranking
	
	-- init entity specific data

	if (entity:IsKindOf(UTTeam)) then

		-- team

		for i, player in ipairs(entity.players) do
			self:InitEntityHeapData(player, i)
		end

	else

        UTActivity:InitEntityHeapData(entity, ranking)

		-- !! PLAYER : CAN BE TAKEN FROM SETTINGS OR NOT ... TODO

		if (entity.liquidator) then

			entity.data.heap.lifePoints =  activity.settings.lifePointsLiquidator
			entity.data.heap.ammunitions = activity.settings.ammunitionsLiquidator
			entity.data.heap.clips = 0
			entity.data.heap.respawnTime = activity.settings.invulnerabilityTimeLiquidator
			entity.data.heap.teamFrag = activity.settings.teamFragLiquidator
			entity.data.heap.liquidator = 2

		else

			entity.data.heap.lifePoints = activity.settings.lifePointsSurvivor
			entity.data.heap.ammunitions = activity.settings.ammunitionsSurvivor
			entity.data.heap.clips = activity.settings.clipsSurvivor
			entity.data.heap.respawnTime = activity.settings.respawnTimeSurvivor
			entity.data.heap.teamFrag = activity.settings.teamFragSurvivor
			entity.data.heap.liquidator = 1

		end
		entity.data.heap.swap = activity.settings.swap
		entity.data.heap.medkit = game.settings.addons.medkitPack

		entity.data.heap.hit = 0
		entity.data.heap.death = 0
		entity.data.heap.accuracy = 0
		entity.data.heap.isDead = 0

		-- statistics

		entity.data.heap.accuracy = 0
		entity.data.heap.nbShot = 0
		entity.data.heap.nbRespawn = 0
		entity.data.heap.nbAmmoPack = 0
		entity.data.heap.nbMediKit = 0
		entity.data.heap.hitByName = {}
		entity.data.heap.killByName = {}

		--print("my team index is : " .. entity.data.heap.team)

		-- gameMaster
		
		entity.data.heap.hitLost = 0
		entity.data.heap.lastPlayerShooted = {}
		entity.data.heap.nbHitLastPlayerShooted = 0
		
	end
	
end

-- GetLiquidatorNumber  ------------------------------------------------------

function UALiquidator:GetLiquidatorNumber()

	local numberOfLiquidator = 0
	for _, player in ipairs(activity.players) do
		if (player.liquidator) then numberOfLiquidator = numberOfLiquidator  + 1
		end
	end
	return numberOfLiquidator

end

-- UpdateEntityBakedData  ---------------------------------------------

function UALiquidator:UpdateEntityBakedData(entity, ranking)

	entity.data.baked.score = (entity.data.baked.score or 0) + (entity.data.heap.score or 0)

	if (entity:IsKindOf(UTTeam)) then

		-- team

		for i, player in pairs(entity.players) do
			self:UpdateEntityBakedData(player, i)
		end

	else

		-- statistics

		entity.data.baked.nbShot = (entity.data.baked.nbShot or 0) + entity.data.heap.nbShot
		entity.data.baked.hit = (entity.data.baked.hit or 0) + entity.data.heap.hit
		entity.data.baked.death = (entity.data.baked.death or 0) + entity.data.heap.death
		if (entity.data.baked.nbShot > 0) then
			entity.data.baked.accuracy = (100 * (entity.data.baked.hit + entity.data.baked.death) / entity.data.baked.nbShot)
		else
			entity.data.baked.accuracy = 0
		end
		entity.data.baked.detailAccuracy = string.format("%0.1f", entity.data.baked.accuracy) .. "%"
		--entity.data.baked.detailsScore = entity.data.baked.score .. " " .. l"oth068"
		entity.data.baked.nbRespawn = (entity.data.baked.nbRespawn or 0) + entity.data.heap.nbRespawn
		entity.data.baked.nbAmmoPack = (entity.data.baked.nbAmmoPack or 0) + entity.data.heap.nbAmmoPack
		entity.data.baked.nbMediKit = (entity.data.baked.nbMediKit or 0) + entity.data.heap.nbMediKit
		
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
			details.detailsTeam = player.team.profile.details
			details.hitByName = (entity.data.baked.hitByName[player.nameId] or 0)
			details.killByName = (entity.data.baked.killByName[player.nameId] or 0)
			entity.data.details[player.nameId] = details

		end

	end

end