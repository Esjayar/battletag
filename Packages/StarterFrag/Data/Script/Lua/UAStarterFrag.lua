
--[[--------------------------------------------------------------------------
--
-- File:			UTActivity_UAStarterFrag.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 21, 2010
--
------------------------------------------------------------------------------
--
-- Description:     test activity
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity"

--[[ Class -----------------------------------------------------------------]]

UTClass.UAStarterFrag(UTActivity)

-- state dependencies

UAStarterFrag.State = {}

    require "UAStarterFrag.State.RoundLoop"

-- default

UAStarterFrag.bytecodePath = "game:../packages/starterfrag/data/script/bytecode/UAStarterFrag.ByteCode.lua"
UAStarterFrag.bitmap = "base:texture/ui/loading_starterfrag.tga"

-- __ctor --------------------------------------------------------------------

function UAStarterFrag:__ctor(...)

	-- properties

    self.name = l "title004"
    self.category = UTActivity.categories.closed

    self.textScoring = l "score003"
    self.textRules = l "rules005"
    self.iconBanner = "base:texture/ui/Ranking_Bg_StarterFrag.tga"
    
	-- scoringField
	
    self.scoringField = {
		{"score", nil, nil, 280, quartz.system.drawing.justification.right, UIComponent.fonts.header, UIComponent.colors.orange},
	}

    -- settings

    self.settings = {

        [1] = { title = l "titlemen006", options = {

            [1] = { label = l "goption001", tip = l "tip001", choices = { { value = 5 } }, index = "playtime", },
            [2] = { label = l "goption002", tip = l "tip002", choices = { { value = 0, displayMode = "large", text = "Auto"}, { value = 1, displayMode = "large", text = l"oth032" } }, index = "gameLaunch" },
            [3] = { label = l "goption003", tip = l "tip003", choices = { { value = 1, icon = "base:texture/ui/components/uiradiobutton_house.tga" }, { value = 2 }, { value = 3}, { value = 4 }, { value = 5, icon = "base:texture/ui/components/uiradiobutton_sun.tga" } }, index = "beamPower" },
            [4] = { label = l "goption014", tip = l "tip004", choices = { { value = 0, displayMode = "large", text = l"oth076"}, { value = 1, displayMode = "large", text = l"oth075" } }, index = "assist" },

            },
        },
        
        [2] = { title = l"titlemen007", options = {

            [1] = { label = l"goption004", tip = l"tip028", choices = { { value = 12 } }, index = "ammunitions", },
            [2] = { label = l"goption005", tip = l"tip032", choices = { { value = 3 } }, index = "clips", },

            },
        },

        -- keyed settings

        playtime = 5,
        gameLaunch = 0,
        beamPower = 3,
        ammunitions = 12,
        assist = 1,
        clips = 3,

		-- no team

        numberOfTeams = 0,
    }

    -- playground
    -- !! TABLE FORMAT : { [numberofplayer] = { ["ITEM_BITMAP"] = { category = "string", priority = number, size = number, positions = { { number, number }, ... }, title = "string", text = "string", condition = function() }, ... }

    self.playground = {

        [1] = {

            Arrows = { category = "Position", size = 256, positions = { { 265, 150 }, }, title = l"goption002", text = string.format(l"psexp016"), },
            RF01 = { category = "Ammo", positions = { { 92, 150 }, }, title = l"goption010", text = string.format(l"psexp014"), condition = function (self) return (20 ~= activity.settings.ammunitions) end  },
            RF02 = { category = "Ammo2", positions = { { 437, 150 }, }, title = l"goption010", text = string.format(l"psexp014"), condition = function (self) return (20 ~= activity.settings.ammunitions) end  },

        },
    }

    -- ?? CONFIG DATA SEND WITH RF 

    self.configData = {
		"assist",
		"ammunitions",
		"clips",
    }

    -- details columms descriptor

	self.detailsDescriptor = {
		information = {
			{ key = "detailsScore", icon = "base:texture/ui/Icons/32x/score.tga", tip = l"tip072" },
			{key = "detailAccuracy", icon = "base:texture/ui/Icons/32x/precision.tga", tip = l"tip073" }
		},
		details = {
			{key = "name", width = 175, style = UIGridLine.RowTitleCellStyle},
			{key = "hitByName", width = 75, style = UIGridLine.RowTitleCellStyle, icon = "base:texture/ui/Icons/32x/Hit.tga", tip = l"tip068"},
		}
	}

    -- overriden states

    self.states["roundloop"] = UAStarterFrag.State.RoundLoop:New(self)
    
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

function UAStarterFrag:__dtor()
end

-- InitEntityBakedData  ------------------------------------------------------

function UAStarterFrag:InitEntityBakedData(entity, ranking)

	UTActivity:InitEntityBakedData(entity, ranking)

	entity.data.baked.score = 0
	entity.data.baked.ranking = ranking

	entity.data.baked.accuracy = 0
	entity.data.baked.nbShot = 0
	entity.data.baked.nbAmmoPack = 0
	entity.data.baked.hitByName = {}

end

-- InitEntityHeapData  --------------------------------------------------------------------

function UAStarterFrag:InitEntityHeapData(entity, ranking)

    UTActivity:InitEntityHeapData(entity, ranking)

	entity.data.heap.score = 0
	entity.data.heap.ranking = ranking
	
	-- data config

	entity.data.heap.nbHit = 0
	entity.data.heap.ammunitions = activity.settings.ammunitions
	entity.data.heap.assist = activity.settings.assist
	entity.data.heap.clips = activity.settings.clips
	if (activity.settings.ammunitions == 20) then
		entity.data.heap.ammunitionsAndClips = "-/-"
	else
		entity.data.heap.ammunitionsAndClips = activity.settings.ammunitions .. "/" .. entity.data.heap.clips
	end
		
	-- statistics

	entity.data.heap.nbShot = 0
	entity.data.heap.hit = 0
	entity.data.heap.accuracy = 0
	entity.data.heap.nbAmmoPack = 0
	entity.data.heap.hitByName = {}
	
	-- gameMaster
	
	entity.data.heap.hitLost = 0
	entity.data.heap.lastPlayerShooted = {}
	entity.data.heap.nbHitLastPlayerShooted = 0

end

-- UpdateEntityBakedData  ---------------------------------------------

function UAStarterFrag:UpdateEntityBakedData(entity, ranking)

	entity.data.baked.score = (entity.data.baked.score or 0) + entity.data.heap.score

	-- statistics

	entity.data.baked.nbShot = (entity.data.baked.nbShot or 0) + entity.data.heap.nbShot
	entity.data.baked.hit = (entity.data.baked.hit or 0) + entity.data.heap.hit
	if (entity.data.baked.nbShot > 0) then
		entity.data.baked.accuracy = (100 * (entity.data.baked.hit / entity.data.baked.nbShot))
	else
		entity.data.baked.accuracy = 0
	end
	entity.data.baked.detailsScore = entity.data.baked.score .. " " .. l"oth068"
	entity.data.baked.detailAccuracy = string.format("%0.1f", entity.data.baked.accuracy) .. "%"
	entity.data.baked.nbAmmoPack = (entity.data.baked.nbAmmoPack or 0) + entity.data.heap.nbAmmoPack
	
	for player, value in pairs(entity.data.heap.hitByName) do
		entity.data.baked.hitByName[player] = (entity.data.baked.hitByName[player] or 0) + value
	end

	-- details data

	entity.data.details = {}
	for i, player in ipairs(activity.players) do

		local details = {}
		details.name = player.profile.name
		details.hitByName = (entity.data.baked.hitByName[player.nameId] or 0)
		entity.data.details[player.nameId] = details

	end

end
