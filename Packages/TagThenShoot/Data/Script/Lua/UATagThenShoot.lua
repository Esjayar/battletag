
--[[--------------------------------------------------------------------------
--
-- File:			UATagThenShoot.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 23, 2010
--
------------------------------------------------------------------------------
--
-- Description:     test activity
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity"

--[[ Class -----------------------------------------------------------------]]

UTClass.UATagThenShoot(UTActivity)

-- state dependencies

UATagThenShoot.Ui = {}
UATagThenShoot.State = {}

    require "UATagThenShoot.State.RoundLoop"
    require "UATagThenShoot.State.PlayersSetup"

-- default

UATagThenShoot.minNumberOfPlayer = 1

UATagThenShoot.bytecodePath = "game:../packages/tagthenshoot/data/script/bytecode/UATagThenShoot.ByteCode.lua"
UATagThenShoot.bitmap = "base:texture/ui/loading_tagnshoot.tga"

UATagThenShoot.countdownDuration = 3

-- SD07 snd
UATagThenShoot.gameoverSnd = { 0x53, 0x44, 0x30, 0x37 }

-- __ctor --------------------------------------------------------------------

function UATagThenShoot:__ctor(...)

	-- properties

    self.name = l"title001"
    self.category = UTActivity.categories.single

    self.textScoring = l"score001"
    self.textRules = l"rules006"
    self.iconBanner = "base:texture/ui/Ranking_Bg_TagNShoot.tga"
    
    -- settings

    self.settings = {

        [1] = { title = l"titlemen006", options = {

            [1] = { label = l"goption015", tip = l "tip029", choices = { { value = 2 }, { value = 4, conditional = true } }, index = "numberOfBase", condition = function (self) return (1 == game.settings.addons.medkitPack) end },
            [2] = { label = l"goption003", tip = l "tip026", choices = { { value = 1, icon = "base:texture/ui/components/uiradiobutton_house.tga" }, { value = 2 }, { value = 3}, { value = 4 }, { value = 5, icon = "base:texture/ui/components/uiradiobutton_sun.tga" } }, index = "beamPower" },
            [3] = { label = l"goption014", tip = l "tip004", choices = { { value = 0, displayMode = "large", text = l"oth076"}, { value = 1, displayMode = "large", text = l"oth075" } }, index = "assist" },

            },
     --   },
        
      --  [2] = { title = "Players settings", options = {
		--	},
        },

        -- keyed settings

        playtime = 1,
        numberOfBase = 2 + 2 * game.settings.addons.medkitPack,
        gameLaunch = 1,
        beamPower = 3,
        assist = 1,

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
		"numberOfBase",
		"assist",
    }

    -- details columms descriptor

	self.detailsDescriptor = nil

    -- overriden states

    self.states["roundloop"] = UATagThenShoot.State.RoundLoop:New(self)
    self.states["playerssetup"] = UATagThenShoot.State.PlayersSetup:New(self)

    -- ?? LES SETTINGS SONT RENSEIGNÉS DANS LE CONSTRUCTEUR DE L'ACTIVITÉ
    -- ?? LES PARAMÈTRES (DISPLAYMODE, TEXTE, ICONE...) DES COLONES DE GRID SONT RENSEIGNÉS DANS LE COMPOSANT DÉDIÉ DU LEADERBOARD
    -- ?? LES ATTRIBUTS - HEAP, BAKED - DES ENTITÉS SONT RENSEIGNÉS PAR 2 APPELS DE FONCTION DÉDIÉS DANS L'ACTIVITÉ (À SURCHARGER)
    -- ?? POUR LES DONNÉES DE CONFIGURATION DE BYTECODE, CE SERA SUREMENT PAREIL QUE POUR LES ATTRIBUTS = FONCTION DÉDIÉ (À SURCHARGER)
    -- ?? POUR LE LEADERBOARD:
    -- ??       - SURCHARGER LA PAGE QUI UTILISE LE LEADERBOARD STANDARD,
    -- ??       - RAJOUTER DES PARAMÈTRES (DISPLAYMODE, TEXTE, ICONE...) DES COLONES DE GRID SI NÉCESSAIRE EN + DE CEUX PAR DÉFAUT (LIFE, HIT, AMMO...)
    -- ??       - RENSEIGNER QUELS ATTRIBUTS ON SOUHAITE REPRÉSENTER PARMIS CEUX EXISTANT EN HEAP


    -- gameplay data send

    self.gameplayData = { 0x00, 0x00 }

end

-- __dtor --------------------------------------------------------------------

function UATagThenShoot:__dtor()
end

-- InitEntityBakedData  ------------------------------------------------------

function UATagThenShoot:InitEntityBakedData(entity, ranking)

	UTActivity:InitEntityBakedData(entity, ranking)

	entity.data.baked.score = 0
	entity.data.baked.ranking = ranking
	
	-- init entity specific data

	entity.data.baked.nbHit = 0

end

-- InitEntityHeapData  -------------------------------------------------------

function UATagThenShoot:InitEntityHeapData(entity, ranking)

    UTActivity:InitEntityHeapData(entity, ranking)

	entity.data.heap.score = 0
	entity.data.heap.ranking = ranking
	
	-- init entity specific data

	entity.data.heap.nbHit = 0
	entity.data.heap.state = 0
	entity.data.heap.tagging = 1
	entity.data.heap.numberOfBase = activity.settings.numberOfBase
	entity.data.heap.assist = activity.settings.assist

end

-- OnDeviceRemoved -----------------------------------------------------------

function UATagThenShoot:OnDeviceRemoved(device)

    if (device.owner) then

        local playerEntity = device.owner
        playerEntity:BindDevice()
		playerEntity.data.heap.classId = nil
		playerEntity.data.heap.disconnected = true

	end

end

-- UpdateEntityBakedData  -------------------------------------------------

function UATagThenShoot:UpdateEntityBakedData(entity, ranking)

	entity.data.baked.score = (entity.data.baked.score or 0) + entity.data.heap.score

end
