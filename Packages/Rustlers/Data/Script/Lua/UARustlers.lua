
--[[--------------------------------------------------------------------------
--
-- File:			UARustlers.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            November 25, 2010
--
------------------------------------------------------------------------------
--
-- Description:     
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity"

--[[ Class -----------------------------------------------------------------]]

UTClass.UARustlers(UTActivity)

-- state dependencies

UARustlers.State = {}

	require "UARustlers.State.RoundLoop"

-- default

UARustlers.bytecodePath = "game:../packages/rustlers/data/script/bytecode/UARustlers.ByteCode.lua"
UARustlers.bitmap = "base:texture/ui/loading_rustlers.tga"

-- __ctor --------------------------------------------------------------------

function UARustlers:__ctor(...)

	-- activity name

    self.name = l"title013"
    self.category = UTActivity.categories.closed

    self.textScoring = l"score006"
    self.textRules = l"rules008"
    self.iconBanner = "base:texture/ui/Ranking_Bg_Rustlers.tga"
    self.Ui.Title.textScoring.rectangle = { 20, 50, 640, 210 }
    self.Ui.Title.scoringOffset = 40
    
	-- scoringField
	
    self.scoringField = {
		{"hit", "base:texture/ui/icons/32x/hit.tga", l"iconrules004"},
		{"death", "base:texture/ui/icons/32x/death.tga", l"iconrules003"},
		--{"lifePoints", "base:texture/ui/icons/32x/heart.tga", l"iconrules002"},
		{"energy", "base:texture/ui/icons/32x/energy.tga", l"iconrules002"},
		{"score", nil, nil, 280, quartz.system.drawing.justification.right, UIComponent.fonts.header, UIComponent.colors.orange},
	}
	
    -- settings

    self.settings = {

        [1] = { title = l"titlemen006", options = {

            [1] = { displayMode = nil, label = l"goption001", tip = l"tip112", choices = { { value = 5 }, { value = 10 }, { value = 15 }, { value = 20 } }, index = "playtime", },
            [2] = { displayMode = nil, label = l"goption008", tip = l"tip113", choices = { { value = 2 } }, index = "numberOfTeams", },
            [3] = { label = l"goption002", tip = l"tip025", choices = { { value = 0, displayMode = "large", text = "Auto"}, { value = 1, displayMode = "large", text = l"oth032" } }, index = "gameLaunch" },
            [4] = { label = l"goption003", tip = l"tip026", choices = { { value = 1, icon = "base:texture/ui/components/uiradiobutton_house.tga" }, { value = 2 }, { value = 3}, { value = 4 }, { value = 5, icon = "base:texture/ui/components/uiradiobutton_sun.tga" } }, index = "beamPower" },
            [5] = { displayMode = nil, label = l"goption013", tip = l"tip041", choices = { { value = 0, displayMode = "large", text = l"oth076" }, { value = 1, displayMode = "large", text = l"oth075"  } }, index = "teamFrag", },
            [6] = { displayMode = nil, label = l"goption007", tip = l"tip040", choices = { { value = 0, displayMode = "large", text = l"oth076" }, { value = 1, displayMode = "large", text = l"oth075"  } }, index = "swap", },

            },
        },

        [2] = { title = l"titlemen007", options = {

            [1] = { label = l"goption004", tip = l"tip028", choices = { { value = 6 }, { value = 9 }, { value = 12 }, { value = 20, text = "", icon = "base:texture/ui/components/uiradiobutton_infinity.tga" } }, index = "ammunitions", },
            [2] = { label = l"goption005", tip = l"tip032", choices = { { value = 1 }, { value = 2 }, { value = 3 }, { value = 4 }, { value = 5 }, { value = 6 } }, index = "clips", },
           -- [3] = { label = l"goption011", choices = { { value = 0, displayMode = "large", text = "Auto" } }, index = "respawnMode", },
            [3] = { label = l"goption012", tip = l"tip036", choices = { { value = 0 }, { value = 3 }, { value = 5 }, { value = 10 } }, index = "respawnTime", },
            [4] = { label = l"goption006", tip = l"tip033", choices = { { value = 3 }, { value = 5 }, { value = 7 }, { value = 9 } }, index = "lifePoints", },

            },
        },

        -- keyed settings

		assist = 1,
        playtime = 5,
        gameLaunch = 0,
        beamPower = 3,        
        ammunitions = 9,
        clips = 5,
        lifePoints = 5,
        respawnMode = 0,
        respawnTime = 0,
        swap = 0,
        numberOfTeams = 2,
        teamFrag = 0;

    }

    -- playground
    -- !! TABLE FORMAT : { [numberofplayer] = { ["ITEM_BITMAP"] = { category = "string", priority = number, size = number, positions = { { number, number }, ... }, title = "string", text = "string", condition = function() }, ... }

    self.playground = {

        [1] = { 

            BlueArea = { priority = 20, size = 128, text = string.format(l"psexp025"), positions = { { 480, 50 }, }, },
            RedArea = { priority = 20, size = 128, text = string.format(l"psexp025"), positions = { { 50, 50 }, }, },

            RF01 = { category = "Ammo", title = l"goption010", text = string.format(l"psexp014"), positions = { { 270, 50 }, }, condition = function (self) return (20 ~= activity.settings.ammunitions) end  },
            RF02 = { category = "Ammo2", title = l"goption010", text = string.format(l"psexp014"), positions = { { 270, 250 }, }, condition = function (self) return (20 ~= activity.settings.ammunitions) end  },
            RF03 = { priority = 1, title = l"oth056" ..  " (" .. l"oth027" .. ")", text = string.format(l"psexp027"), positions = { { 50, 50 }, }, },
            RF04 = { priority = 2, title = l"oth057" ..  " (" .. l"oth028" .. ")", text = string.format(l"psexp028"), positions = { { 480, 50 }, }, },            
            RF05 = { priority = 3, title = l"oth058" ..  " (" .. l"oth029" .. ")", text = string.format(l"psexp029"), positions = { { 480, 250 }, }, },
            RF06 = { priority = 4, title = l"oth059" ..  " (" .. l"oth030" .. ")", text = string.format(l"psexp030"), positions = { { 50, 250 }, }, },           
            RF07 = { category = "Med-Kit", title = l"goption009", text = string.format(l"psexp015"), positions = { { 350, 150 }, }, condition = function (self) return (1 == game.settings.addons.medkitPack) end },
            RF08 = { category = "Med-Kit2", title = l"goption009", text = string.format(l"psexp015"), positions = { { 180, 150 }, }, condition = function (self) return (1 == game.settings.addons.medkitPack) end },
        },

    }

    -- ?? CONFIG DATA SEND WITH RF 

    self.configData = {

		"lifePoints",
		"ammunitions",
		"clips",
		"swap",
		"respawnTime",
		"team",
		"teamFrag",
		"medkit",

    }    
    
	-- details columms descriptor

	self.detailsDescriptor = {
		information = {
			{key = "detailsScore", icon = "base:texture/ui/Icons/32x/score.tga", tip = l"tip072" },
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

    self.states["roundloop"] = UARustlers.State.RoundLoop:New(self)
    
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

function UARustlers:__dtor()
end

-- InitEntityBakedData  ------------------------------------------------------

function UARustlers:InitEntityBakedData(entity, ranking)

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

function UARustlers:InitEntityHeapData(entity, ranking)

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

		entity.data.heap.lifePoints = activity.settings.lifePoints
		entity.data.heap.ammunitions = activity.settings.ammunitions
		entity.data.heap.clips = activity.settings.clips
		if (activity.settings.ammunitions == 20) then
			entity.data.heap.ammunitionsAndClips = "-/-"
		else
			entity.data.heap.ammunitionsAndClips = activity.settings.ammunitions .. "/" .. entity.data.heap.clips
		end
		entity.data.heap.swap = activity.settings.swap
		entity.data.heap.ammoPack = activity.settings.ammoPack
		entity.data.heap.medikit = activity.settings.medikit
		entity.data.heap.lives = activity.settings.lives
		entity.data.heap.hit = 0
		entity.data.heap.death = 0
		entity.data.heap.accuracy = 0
		entity.data.heap.respawnTime = activity.settings.respawnTime
		entity.data.heap.isDead = 0
		entity.data.heap.team = entity.team.index
		entity.data.heap.teamFrag = activity.settings.teamFrag
		entity.data.heap.medkit = game.settings.addons.medkitPack
		entity.data.heap.energy = 0

		-- statistics

		entity.data.heap.accuracy = 0
		entity.data.heap.nbShot = 0
		entity.data.heap.nbRespawn = 0
		entity.data.heap.nbAmmoPack = 0
		entity.data.heap.nbMediKit = 0
		entity.data.heap.hitByName = {}
		entity.data.heap.killByName = {}

		-- gameMaster
		
		entity.data.heap.hitLost = 0
		entity.data.heap.lastPlayerShooted = {}
		entity.data.heap.nbHitLastPlayerShooted = 0
		
	end
	
end

-- UpdateEntityBakedData  ---------------------------------------------

function UARustlers:UpdateEntityBakedData(entity, ranking)

	entity.data.baked.score = entity.data.baked.score + entity.data.heap.score

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
		entity.data.baked.detailsScore = entity.data.baked.score .. " " .. l"oth068"
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
