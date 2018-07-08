
--[[--------------------------------------------------------------------------
--
-- File:			UATeamTagThenShoot.lua
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

UTClass.UATeamTagThenShoot(UTActivity)

-- state dependencies

UATeamTagThenShoot.State = {}

    require "UATeamTagThenShoot.State.RoundLoop"
	--require "UATeamTagThenShoot.State.PlayersSetup"

-- default

--UATeamTagThenShoot.minNumberOfPlayer = 2

UATeamTagThenShoot.bitmap = "base:texture/ui/loading_tagnshoot.tga"

UATeamTagThenShoot.countdownDuration = 3

--UATeamTagThenShoot.horizontalPadding = 36

--UATeamTagThenShoot.slots = 9

--UATeamTagThenShoot.playeroffset = 17

-- SD07 snd
UATeamTagThenShoot.gameoverSnd = { 0x53, 0x44, 0x30, 0x37 }

-- __ctor --------------------------------------------------------------------

function UATeamTagThenShoot:__ctor(...)

	-- properties

    self.name = l"title026"
    self.category = UTActivity.categories.single
	self.teamdefaults = true
	self.nodual = true

    self.textScoring = l"score019"
    self.textRules = l"rules021"
    self.iconBanner = "base:texture/ui/Ranking_Bg_TagNShoot.tga"

	-- scoringField
	
    self.scoringField = {}
    
    -- settings

    self.settings = {

        [1] = { title = l"titlemen006", options = {

            [1] = { displayMode = nil, label = l"goption008", tip = l"tip160", choices = { { value = 2 }, { value = 3 }, { value = 4 }, { value = 5 }, { value = 6 } }, index = "numberOfTeams", },
			[2] = { displayMode = nil, label = l"goption001", tip = l"tip027", choices = { { value = 1 }, { value = 2 }, { value = 3 }, { value = 4 }, { value = 5 }, { value = 6 } }, index = "playtime", },
            [3] = { label = l"goption015", tip = l "tip029", choices = { { value = 2 }, { value = 4, conditional = true } }, index = "numberOfBase", condition = function (self) return (1 == game.settings.addons.medkitPack) end },

            },
     --   },
        
      --  [2] = { title = "Players settings", options = {
		--	},
        },

        -- keyed settings

        playtime = 3,
        numberOfBase = 2 + 2 * game.settings.addons.medkitPack,
        numberOfTeams = 2,
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
    }

    -- details columms descriptor

	self.detailsDescriptor = nil

    -- overriden states

    self.states["roundloop"] = UATeamTagThenShoot.State.RoundLoop:New(self)
	--self.states["playerssetup"] = UATeamTagThenShoot.State.PlayersSetup:New(self)

    -- ?? LES SETTINGS SONT RENSEIGN�S DANS LE CONSTRUCTEUR DE L'ACTIVIT�
    -- ?? LES PARAM�TRES (DISPLAYMODE, TEXTE, ICONE...) DES COLONES DE GRID SONT RENSEIGN�S DANS LE COMPOSANT D�DI� DU LEADERBOARD
    -- ?? LES ATTRIBUTS - HEAP, BAKED - DES ENTIT�S SONT RENSEIGN�S PAR 2 APPELS DE FONCTION D�DI�S DANS L'ACTIVIT� (� SURCHARGER)
    -- ?? POUR LES DONN�ES DE CONFIGURATION DE BYTECODE, CE SERA SUREMENT PAREIL QUE POUR LES ATTRIBUTS = FONCTION D�DI� (� SURCHARGER)
    -- ?? POUR LE LEADERBOARD:
    -- ??       - SURCHARGER LA PAGE QUI UTILISE LE LEADERBOARD STANDARD,
    -- ??       - RAJOUTER DES PARAM�TRES (DISPLAYMODE, TEXTE, ICONE...) DES COLONES DE GRID SI N�CESSAIRE EN + DE CEUX PAR D�FAUT (LIFE, HIT, AMMO...)
    -- ??       - RENSEIGNER QUELS ATTRIBUTS ON SOUHAITE REPR�SENTER PARMIS CEUX EXISTANT EN HEAP


    -- gameplay data send

	-- May need to add variables for player id!!!!!!!!!!!!!

    self.gameplayData = { 0x00, 0x00 }

end

-- __dtor --------------------------------------------------------------------

function UATeamTagThenShoot:__dtor()
end

-- InitEntityBakedData  ------------------------------------------------------

function UATeamTagThenShoot:InitEntityBakedData(entity, ranking)

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

		entity.data.baked.nbHit = 0
		entity.data.baked.accuracy = 0
		entity.data.baked.nbShot = 0

	end

end

-- InitEntityHeapData  -------------------------------------------------------

function UATeamTagThenShoot:InitEntityHeapData(entity, ranking)

	--entity.gameplayData = { 0x00, 0x00 }
	
	if (not game.gameMaster.ingame) then
		entity.data.heap.score = 0
		entity.data.heap.ranking = ranking
	end
	
	if (entity:IsKindOf(UTTeam)) then

			-- team
		
		for i, player in ipairs(entity.players) do
			self:InitEntityHeapData(player, i)
		end

	else

		UTActivity:InitEntityHeapData(entity, ranking)

		if (not game.gameMaster.ingame) then
	
			-- init entity specific data

			entity.data.heap.nbHit = 0
			entity.data.heap.accuracy = 0
			entity.data.heap.nbShot = 0
			entity.data.heap.state = 0
			entity.data.heap.tagging = 1
			entity.data.heap.numberOfBase = activity.settings.numberOfBase
		end
	end
end

-- OnDeviceRemoved -----------------------------------------------------------

--function UATeamTagThenShoot:OnDeviceRemoved(device)

 --   if (device.owner) then

   --     local playerEntity = device.owner
    --    playerEntity:BindDevice()
	--	playerEntity.data.heap.classId = nil
	--	playerEntity.data.heap.disconnected = true

	--end

--end

-- UpdateEntityBakedData  -------------------------------------------------

function UATeamTagThenShoot:UpdateEntityBakedData(entity, ranking)

	entity.data.baked.score = (entity.data.baked.score or 0) + entity.data.heap.score

	if (entity:IsKindOf(UTTeam)) then

		-- team

		for i, player in pairs(entity.players) do
			self:UpdateEntityBakedData(player, i)
		end

	else

		-- statistics

		entity.data.baked.nbHit = (entity.data.baked.nbHit or 0) + entity.data.heap.nbHit
		entity.data.baked.nbShot = (entity.data.baked.nbShot or 0) + entity.data.heap.nbShot
		if (entity.data.baked.nbShot > 0) then
			entity.data.baked.accuracy = (100 * (entity.data.baked.hit + entity.data.baked.death) / entity.data.baked.nbShot)
		else
			entity.data.baked.accuracy = 0
		end
		entity.data.baked.detailAccuracy = string.format("%0.1f", entity.data.baked.accuracy) .. "%"
		entity.data.baked.detailsScore = entity.data.baked.score .. " " .. l"oth068"

	end

end
