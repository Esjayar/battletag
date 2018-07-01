
--[[--------------------------------------------------------------------------
--
-- File:			UAFreeFrag.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 27, 2010
--
------------------------------------------------------------------------------
--
-- Description:     test activity
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity"

--[[ Class -----------------------------------------------------------------]]

UTClass.UAFreeFrag(UTActivity)

-- state dependencies

UAFreeFrag.State = {}

	require "UAFreeFrag.State.RoundLoop"

-- default

UAFreeFrag.bytecodePath = "game:../packages/freefrag/data/script/bytecode/UAFreeFrag.ByteCode.lua"
UAFreeFrag.bitmap = "base:texture/ui/loading_freefrag.tga"

-- __ctor --------------------------------------------------------------------

function UAFreeFrag:__ctor(...)

	-- properties

    self.name = l"title005"
    self.category = UTActivity.categories.closed
    
    self.textScoring = l"score003"
    self.textRules = l"rules002"
    self.iconBanner = "base:texture/ui/Ranking_Bg_FreeFrag.tga"

	-- scoringField
	
    self.scoringField = {
		{"score", nil, nil, 280, quartz.system.drawing.justification.right, UIComponent.fonts.header, UIComponent.colors.orange},
	}
	
    -- settings

    self.settings = {

        [1] = { title = l"titlemen006", options = {

            [1] = { label = l"goption001", tip = l"tip027", choices = { { value = 5 }, { value = 10 } }, index = "playtime", },
            [2] = { label = l"goption002", tip = l"tip025", choices = { { value = 0, displayMode = "large", text = "Auto"}, { value = 1, displayMode = "large", text = l"oth032" } }, index = "gameLaunch" },
            [3] = { label = l"goption003", tip = l"tip026", choices = { { value = 1, icon = "base:texture/ui/components/uiradiobutton_house.tga" }, { value = 2 }, { value = 3}, { value = 4 }, { value = 5, icon = "base:texture/ui/components/uiradiobutton_sun.tga" } }, index = "beamPower" },

            },
        },

        -- keyed settings

        playtime = 5,
        gameLaunch = 0,
        beamPower = 3,

		-- no team

        numberOfTeams = 0,
    }

    -- ?? CONFIG DATA SEND WITH RF 

    self.configData = {}

    -- details columms descriptor

	self.detailsDescriptor = {
		information = {
			{key = "score", icon = "base:texture/ui/Icons/32x/Score.tga", tip = l"tip072" },
			{key = "accuracy", icon = "base:texture/ui/Icons/32x/precision.tga", tip = l"tip073" }
		},
		details = {
			{key = "name", width = 175, style = UIGridLine.RowTitleCellStyle},
			{key = "hitByName", width = 75, style = UIGridLine.RowTitleCellStyle, icon = "base:texture/ui/Icons/32x/Hit.tga"},
		}
	}
	
	
	-- playground
    -- !! TABLE FORMAT : { [numberofplayer] = { ["ITEM_BITMAP"] = { category = "string", priority = number, size = number, positions = { { number, number }, ... }, title = "string", text = "string", condition = function() }, ... }

    self.playground = {

        [1] = { 

            Arrows = { category = "Position", size = 256, positions = { { 265, 150 }, }, title = l"goption002", text = string.format(l"psexp016"), },
       
        },
    }

    -- overriden states

    self.states["roundloop"] = UAFreeFrag.State.RoundLoop:New(self)
    
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

function UAFreeFrag:__dtor()
end

-- initialize entity baked data  --------------------------------------------------------------------

function UAFreeFrag:InitEntityBakedData(entity, ranking)

    UTActivity:InitEntityBakedData(entity, ranking)

	entity.data.baked.score = 0
	entity.data.baked.ranking = ranking

	entity.data.baked.accuracy = 0
	entity.data.baked.nbShot = 0
	entity.data.baked.hit = 0
	entity.data.baked.hitByName = {}

end

-- initialize entity heap data  --------------------------------------------------------------------

function UAFreeFrag:InitEntityHeapData(entity, ranking)

	UTActivity:InitEntityHeapData(entity, ranking)

	entity.data.heap.score = 0
	entity.data.heap.ranking = ranking

	-- statistics

	entity.data.heap.nbShot = 0
	entity.data.heap.hit = 0
	entity.data.heap.nbHit = 0
	entity.data.heap.accuracy = 0
	entity.data.heap.hitByName = {}
	
	-- gameMaster
	
	entity.data.heap.lastPlayerShooted = {}
	entity.data.heap.nbHitLastPlayerShooted = 0

end

-- update entity final data  ---------------------------------------------

function UAFreeFrag:UpdateEntityBakedData(entity, ranking)

	entity.data.baked.score = (entity.data.baked.score or 0) + entity.data.heap.score

	-- statistics

	entity.data.baked.nbShot = (entity.data.baked.nbShot or 0) + entity.data.heap.nbShot
	entity.data.baked.hit = (entity.data.baked.hit or 0) + entity.data.heap.hit
	if (entity.data.baked.nbShot > 0) then
		entity.data.baked.accuracy = (100 * entity.data.baked.hit / entity.data.baked.nbShot)
	else
		entity.data.baked.accuracy = 0
	end
	entity.data.baked.accuracy = string.format("%0.1f", entity.data.baked.accuracy) .. "%"
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