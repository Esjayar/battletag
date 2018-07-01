
--[[--------------------------------------------------------------------------
--
-- File:			UALastManStanding.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 22, 2010
--
------------------------------------------------------------------------------
--
-- Description:     test activity
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity"

--[[ Class -----------------------------------------------------------------]]

UTClass.UALastManStanding(UTActivity)

-- state dependencies

UALastManStanding.State = {}

    require "UALastManStanding.State.RoundLoop"

-- default

UALastManStanding.bytecodePath = "game:../packages/lastmanstanding/data/script/bytecode/UALastManStanding.ByteCode.lua"
UALastManStanding.bitmap = "base:texture/ui/loading_lastmanstanding.tga"

-- __ctor --------------------------------------------------------------------

function UALastManStanding:__ctor(...)

	-- properties

    self.name = l"title011"
    self.category = UTActivity.categories.closed

    self.textScoring = l"score005"
    self.textRules = l"rules003"
    
    self.dontDisplayScore = true
    self.iconBanner = "base:texture/ui/Ranking_Bg_LastManStanding.tga"
    
	-- scoringField
	
    self.scoringField = {
		{"hit", "base:texture/ui/icons/32x/hit.tga", l"iconrules004"},
		{"death", "base:texture/ui/icons/32x/death.tga", l"iconrules003"},
		{"lifePoints", "base:texture/ui/icons/32x/heart.tga", l"iconrules002"},
	}

    -- settings

    self.settings = {

        [1] = { title = l"titlemen006", options = {

            [1] = { label = l"goption007", tip = l"tip040", choices = { { value = 0, displayMode = "large", text = "Off" }, { value = 1, displayMode = "large", text = "On"  } }, index = "swap", },
            [2] = { label = l"goption002", tip = l"tip025", choices = { { value = 0, displayMode = "large", text = "Auto"}, { value = 1, displayMode = "large", text = l"oth032" } }, index = "gameLaunch" },
            [3] = { label = l"goption003", tip = l"tip026", choices = { { value = 1, icon = "base:texture/ui/components/uiradiobutton_house.tga" }, { value = 2 }, { value = 3}, { value = 4 }, { value = 5, icon = "base:texture/ui/components/uiradiobutton_sun.tga" } }, index = "beamPower" },
            [4] = { label = l"goption014", tip = l"tip004", choices = { { value = 0, displayMode = "large", text = "Off"}, { value = 1, displayMode = "large", text = "On" } }, index = "assist" },

            },
        },
        
        [2] = { title = l"titlemen007", options = {

            [1] = { label = l"goption004", tip = l"tip028", choices = { { value = 6 }, { value = 9 }, { value = 12 }, { value = 20 , text = "", icon = "base:texture/ui/components/uiradiobutton_infinity.tga" } }, index = "ammunitions", },
            [2] = { label = l"goption005", tip = l"tip032", choices = { { value = 1 }, { value = 2 }, { value = 3 }, { value = 4 }, { value = 5 }, { value = 6 } }, index = "clips", },
           -- [3] = { label = l"goption011", choices = { { value = 0, displayMode = "large", text = "Auto" } }, index = "respawnMode", },
            [3] = { label = l"goption006", tip = l"tip033", choices = { { value = 3 }, { value = 5 }, { value = 7 }, { value = 9 } }, index = "lifePoints", },

            },
        },

        -- keyed settings

        gameLaunch = 0,
        beamPower = 3,
        ammunitions = 9,
        clips = 3,
        lifePoints = 5,
        respawnMode = 0,
        respawnTime = 10,
        swap = 0,
        assist = 1,

		-- no team

        numberOfTeams = 0,
    }

    -- playground
    -- !! TABLE FORMAT : { [numberofplayer] = { ["ITEM_BITMAP"] = { category = "string", priority = number, size = number, positions = { { number, number }, ... }, title = "string", text = "string", condition = function() }, ... }

    self.playground = {

        [1] = { 

            RF01 = { category = "Ammo", positions = { { 132, 75 }, }, title = l"goption010", text = string.format(l"psexp014"), },
            RF02 = { category = "Ammo", positions = { { 397, 225 }, }, title = l"goption010", text = string.format(l"psexp014"), },
            RF07 = { category = "Med-Kit", positions = { { 132, 225 }, }, title = l"goption009", text = string.format(l"psexp015"), condition = function (self) return (1 == game.settings.addons.medkitPack) end },
            RF08 = { category = "Med-Kit", positions = { { 397, 75 }, }, title = l"goption009", text = string.format(l"psexp015"), condition = function (self) return (1 == game.settings.addons.medkitPack) end },

        },
    }



    -- ?? CONFIG DATA SEND WITH RF 

    self.configData = {

		"lifePoints",
		"ammunitions",
		"clips",
		"swap",
		"assist",
		"medkit",

    }

    -- details columms descriptor

	self.detailsDescriptor = {
		information = {
			--{key = "score", icon = "base:texture/ui/Icons/32x/Score.tga"},
			{key = "accuracy", icon = "base:texture/ui/Icons/32x/precision.tga", tip = l"tip073" }
		},
		details = {
			{key = "name", width = 175, style = UIGridLine.RowTitleCellStyle},
			{key = "hitByName", width = 75, style = UIGridLine.RowTitleCellStyle, icon = "base:texture/ui/Icons/32x/Hit.tga"},
			{key = "killByName", width = 50, style = UIGridLine.RowTitleCellStyle, icon = "base:texture/ui/Icons/32x/Death.tga"},
		}
	}

    -- overriden states

    self.states["roundloop"] = UALastManStanding.State.RoundLoop:New(self)
    
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

function UALastManStanding:__dtor()
end

-- InitEntityBakedData  ------------------------------------------------------

function UALastManStanding:InitEntityBakedData(entity, ranking)

	UTActivity:InitEntityBakedData(entity, ranking)		

	entity.data.baked.score = 0
	entity.data.baked.ranking = ranking

	entity.data.baked.accuracy = 0
	entity.data.baked.nbShot = 0
	entity.data.baked.nbAmmoPack = 0
	entity.data.baked.nbMediKit = 0
	entity.data.baked.hitByName = {}
	entity.data.baked.killByName = {}

end

-- InitEntityHeapData --------------------------------------------------------------------

function UALastManStanding:InitEntityHeapData(entity, ranking)

	UTActivity:InitEntityHeapData(entity, ranking)	

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
	entity.data.heap.assist = activity.settings.assist
	entity.data.heap.medkit = game.settings.addons.medkitPack

	entity.data.heap.score = activity.settings.lifePoints + #activity.match.players
	entity.data.heap.ranking = ranking
	
	-- statistics

	entity.data.heap.nbShot = 0
	entity.data.heap.hit = 0
	entity.data.heap.death = 0
	entity.data.heap.accuracy = 0
	entity.data.heap.isDead = 0
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

function UALastManStanding:UpdateEntityBakedData(entity, ranking)

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
