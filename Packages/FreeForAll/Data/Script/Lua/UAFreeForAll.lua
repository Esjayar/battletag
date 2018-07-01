
--[[--------------------------------------------------------------------------
--
-- File:			UTActivity_FreeForAll.lua
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

UTClass.UAFreeForAll(UTActivity)

-- state dependencies

UAFreeForAll.State = {}

	require "UAFreeForAll.State.RoundLoop"

-- default

UAFreeForAll.bytecodePath = "game:../packages/freeforall/data/script/bytecode/UAFreeForAll.ByteCode.lua"
UAFreeForAll.bitmap = "base:texture/ui/loading_freeforall.tga"

-- __ctor --------------------------------------------------------------------

function UAFreeForAll:__ctor(...)

	-- properties

    self.name = l"title007"
    self.category = UTActivity.categories.closed

    self.textScoring = l"score004"
    self.textRules = l"rules001"
    self.iconBanner = "base:texture/ui/Ranking_Bg_FreeForAll.tga"
    
	-- scoringField
	
    self.scoringField = {
		{"hit", "base:texture/ui/icons/32x/hit.tga", l"iconrules004"},
		{"death", "base:texture/ui/icons/32x/death.tga", l"iconrules003"},
		{"lifePoints", "base:texture/ui/icons/32x/heart.tga", l"iconrules002"},
		{"score", nil, nil, 280, quartz.system.drawing.justification.right, UIComponent.fonts.header, UIComponent.colors.orange},
	}

    -- settings

    self.settings = {

        [1] = { title = l"titlemen006", options = {

            [1] = { label = l"goption001", tip = l"tip027", choices = { { value = 5 }, { value = 10 }, { value = 15 }, { value = 20 } }, index = "playtime", },
            [2] = { label = l"goption007", tip = l"tip040", choices = { { value = 0, displayMode = "large", text = "Off" }, { value = 1, displayMode = "large", text = "On"  } }, index = "swap", },
            [3] = { label = l"goption002", tip = l"tip025", choices = { { value = 0, displayMode = "large", text = "Auto"}, { value = 1, displayMode = "large", text = l"oth032" } }, index = "gameLaunch" },
            [4] = { label = l"goption003", tip = l"tip026", choices = { { value = 1, icon = "base:texture/ui/components/uiradiobutton_house.tga" }, { value = 2 }, { value = 3}, { value = 4 }, { value = 5, icon = "base:texture/ui/components/uiradiobutton_sun.tga" } }, index = "beamPower" },
            [5] = { label = l"goption014", tip = l"tip004", choices = { { value = 0, displayMode = "large", text = "Off"}, { value = 1, displayMode = "large", text = "On" } }, index = "assist" },

            },
        },
        
        [2] = { title = l"titlemen007", options = {

            [1] = { label = l"goption004", tip = l"tip028", choices = { { value = 6 }, { value = 9 }, { value = 12 }, { value = 20, text = "", icon = "base:texture/ui/components/uiradiobutton_infinity.tga" } }, index = "ammunitions", },
            [2] = { label = l"goption005", tip = l"tip032", choices = { { value = 1 }, { value = 2 }, { value = 3 }, { value = 4 }, { value = 5 }, { value = 6 } }, index = "clips", },
          --  [3] = { label = l"goption011", choices = { { value = 0, displayMode = "large", text = "Auto" } }, index = "respawnMode", },
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
        clips = 3,
        lifePoints = 5,
        respawnMode = 0,
        respawnTime = 0,
        swap = 0,

		-- no team

        numberOfTeams = 0,
    }

    -- playground
    -- !! TABLE FORMAT : { [numberofplayer] = { ["ITEM_BITMAP"] = { category = "string", priority = number, size = number, positions = { { number, number }, ... }, title = "string", text = "string", condition = function() }, ... }

    self.playground = {

        [1] = { 

            RF01 = { category = "Ammo", positions = { { 265, 50 }, }, title = l"goption010", text = string.format(l"psexp014"), },
            RF02 = { category = "Ammo", positions = { { 265, 250 }, }, title = l"goption010", text = string.format(l"psexp014"), },
            RF07 = { category = "Med-Kit", positions = { { 50, 150 }, }, title = l"goption009", text = string.format(l"psexp015"), condition = function (self) return (1 == game.settings.addons.medkitPack) end },
            RF08 = { category = "Med-Kit", positions = { { 480, 150 }, }, title = l"goption009", text = string.format(l"psexp015"), condition = function (self) return (1 == game.settings.addons.medkitPack) end },

        },
    }

    -- ?? CONFIG DATA SEND WITH RF 

    self.configData = {

		"lifePoints",
		"ammunitions",
		"clips",
		"swap",
		"respawnTime",
		"assist",
		"medkit",

    }

    -- details columms descriptor

	self.detailsDescriptor = {
		information = {
			{ key = "score", icon = "base:texture/ui/Icons/32x/Score.tga", tip = l"tip072" },
			{ key = "accuracy", icon = "base:texture/ui/Icons/32x/precision.tga", tip = l"tip073" }
		},
		details = {
			{ key = "name", width = 175, style = UIGridLine.RowTitleCellStyle },
			{ key = "hitByName", width = 75, style = UIGridLine.RowTitleCellStyle, icon = "base:texture/ui/Icons/32x/Hit.tga" },
			{ key = "killByName", width = 50, style = UIGridLine.RowTitleCellStyle, icon = "base:texture/ui/Icons/32x/Death.tga" },
		}
	}

    -- overriden states

    self.states["roundloop"] = UAFreeForAll.State.RoundLoop:New(self)
    
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

function UAFreeForAll:__dtor()
end

-- InitEntityBakedData  ------------------------------------------------------

function UAFreeForAll:InitEntityBakedData(entity, ranking)

	UTActivity:InitEntityBakedData(entity, ranking)

	entity.data.baked.score = 0
	entity.data.baked.ranking = ranking

	-- player 

	entity.data.baked.accuracy = 0
	entity.data.baked.nbShot = 0
	entity.data.baked.nbRespawn = 0
	entity.data.baked.nbAmmoPack = 0
	entity.data.baked.nbMediKit = 0
	entity.data.baked.hitByName = {}
	entity.data.baked.killByName = {}

end

-- InitEntityHeapData --------------------------------------------------------------------

function UAFreeForAll:InitEntityHeapData(entity, ranking)

	UTActivity:InitEntityHeapData(entity, ranking)

	entity.data.heap.score = 0
	entity.data.heap.ranking = ranking
	
	-- data config

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
	entity.data.heap.respawnTime = activity.settings.respawnTime
	entity.data.heap.assist = activity.settings.assist
	entity.data.heap.medkit = game.settings.addons.medkitPack

	-- statistics

	entity.data.heap.nbShot = 0
	entity.data.heap.hit = 0
	entity.data.heap.death = 0
	entity.data.heap.accuracy = 0
	entity.data.heap.isDead = 0
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

-- UpdateEntityBakedData  ---------------------------------------------

function UAFreeForAll:UpdateEntityBakedData(entity, ranking)

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
	entity.data.baked.accuracy = string.format("%0.1f", entity.data.baked.accuracy) .. "%"
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
		details.hitByName = (entity.data.baked.hitByName[player.nameId] or 0)
		details.killByName = (entity.data.baked.killByName[player.nameId] or 0)
		entity.data.details[player.nameId] = details

	end

end
