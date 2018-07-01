
--[[--------------------------------------------------------------------------
--
-- File:			UAThewolf.lua
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

UTClass.UATheWolf(UTActivity)

-- state dependencies

UATheWolf.State = {}

	require "UATheWolf.State.RoundLoop"

-- default

UATheWolf.bytecodePath = "game:../packages/thewolf/data/script/bytecode/UATheWolf.ByteCode.lua"
UATheWolf.bitmap = "base:texture/ui/loading_thewolf.tga"

UATheWolf.maxNumberOfPlayer = 8
UATheWolf.minNumberOfPlayer = 3

-- __ctor --------------------------------------------------------------------

function UATheWolf:__ctor(...)

	-- activity name

    self.name = l"title015"
    self.category = UTActivity.categories.closed

    self.textScoring = l"score009"
    self.Ui.Title.textScoring.rectangle = { 20, 50, 640, 210 }
    self.textRules = l"rules011"
    self.iconBanner = "base:texture/ui/Ranking_Bg_TheWolf.tga"
    
	-- scoringField
	
    self.scoringField = {
		{"score", nil, nil, 280, quartz.system.drawing.justification.right, UIComponent.fonts.header, UIComponent.colors.orange},
	}
	
    -- settings

    self.settings = {

        [1] = { title = l"titlemen006", options = {

            [1] = { displayMode = nil, label = l"goption001", tip = l"tip027", choices = { { value = 5 }, { value = 10 }, }, index = "playtime", },
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
    
	-- playground
    -- !! TABLE FORMAT : { [numberofplayer] = { ["ITEM_BITMAP"] = { category = "string", priority = number, size = number, positions = { { number, number }, ... }, title = "string", text = "string", condition = function() }, ... }

    self.playground = {

        [1] = { 

            RF03 = { priority = 1, title = l"oth056" ..  " (" .. l"oth027" .. ")", text = string.format(l"psexp034"), positions = { { 50, 150 }, }, },
            RF04 = { priority = 2, title = l"oth057" ..  " (" .. l"oth028" .. ")", text = string.format(l"psexp034"), positions = { { 480, 150 }, }, },
            RF05 = { priority = 3, title = l"oth058" ..  " (" .. l"oth029" .. ")", text = string.format(l"psexp034"), positions = { { 265, 30 }, }, },
            RF06 = { priority = 4, title = l"oth059" ..  " (" .. l"oth030" .. ")", text = string.format(l"psexp034"), positions = { { 265, 270 }, }, },           
            RF09 = { priority = 4, title = l"oth055", text = string.format(l"psexp033"), positions = { { 265, 150 }, }, },           
       
        },
    }

    -- ?? CONFIG DATA SEND WITH RF 

    self.configData = {
		"id",
    }  
    
	-- details columms descriptor

	self.detailsDescriptor = nil

    -- overriden states

    self.states["roundloop"] = UATheWolf.State.RoundLoop:New(self)
    
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

function UATheWolf:__dtor()
end

-- InitEntityBakedData  ------------------------------------------------------

function UATheWolf:InitEntityBakedData(entity, ranking)

	entity.data.baked.score = 0
	entity.data.baked.ranking = ranking

	UTActivity:InitEntityBakedData(entity, ranking)

end

-- InitEntityHeapData  -----------------------------------------------------

function UATheWolf:InitEntityHeapData(entity, ranking)

    -- !! INITIALIZE ALL HEAP DATA (RELEVANT DURING ONE MATCH ONLY)

	entity.data.heap.score = 0
	entity.data.heap.ranking = ranking
	entity.data.heap.nbHit = 0
	entity.data.heap.nbShot = 0
	if (entity.rfGunDevice) then
		entity.data.heap.id = entity.rfGunDevice.classId
	else
		entity.data.heap.id = ranking
	end
	entity.data.heap.last_rfid = 0

    UTActivity:InitEntityHeapData(entity, ranking)

end

-- UpdateEntityBakedData  ---------------------------------------------

function UATheWolf:UpdateEntityBakedData(entity, ranking)

	entity.data.baked.score = entity.data.baked.score + entity.data.heap.score

end
