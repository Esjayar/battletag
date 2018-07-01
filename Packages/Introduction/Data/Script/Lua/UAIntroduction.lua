
--[[--------------------------------------------------------------------------
--
-- File:			UAIntroduction.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 16, 2010
--
------------------------------------------------------------------------------
--
-- Description:     introduction sequence, tutorial.
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTActivity"

--[[ Class -----------------------------------------------------------------]]

UTClass.UAIntroduction(UTActivity)

-- ui

UAIntroduction.Ui = {}

    require "UAIntroduction.Ui.Seq_Batteries"
    require "UAIntroduction.Ui.Seq_Pairing"
    require "UAIntroduction.Ui.Seq_Stage1"
    require "UAIntroduction.Ui.Seq_Stage2"
    require "UAIntroduction.Ui.Seq_Stage3"
    require "UAIntroduction.Ui.Seq_Stage4"
    require "UAIntroduction.Ui.Seq_Stage5"
    require "UAIntroduction.Ui.Seq_Stage6"
    require "UAIntroduction.Ui.Seq_Ready"
	require "UAIntroduction.Ui.Seq_Quit"

-- state dependencies

UAIntroduction.State = {}

    require "UAIntroduction.State.Title"
    require "UAIntroduction.State.Ui"
    require "UAIntroduction.State.PlayersManagement"
    require "UAIntroduction.State.PlayersSetup"
    require "UAIntroduction.State.RoundLoop"

-- default

UAIntroduction.bytecodePath = "game:../packages/introduction/data/script/bytecode/UAIntroduction.ByteCode.lua"
UAIntroduction.bitmap = "base:texture/ui/loading_introduction.tga"

-- __ctor --------------------------------------------------------------------

function UAIntroduction:__ctor(...)

	-- activity name

    self.name = "Introduction ..."
    self.category = UTActivity.categories.closed
    self.iconBanner = "base:texture/ui/Ranking_Bg_Introduction.tga"

    -- settings

    self.settings = {

        -- global settings

        numberOfTeams = 0,
    }

    -- overriden states

    self.states["title"] = UAIntroduction.State.Title:New(self)
    self.states["ui"] = UAIntroduction.State.Ui:New(self)
    self.states["playersmanagement"] = UAIntroduction.State.PlayersManagement:New(self)
    self.states["playerssetup"] = UAIntroduction.State.PlayersSetup:New(self)
    self.states["roundloop"] = UAIntroduction.State.RoundLoop:New(self)

    -- ?? LES SETTINGS SONT RENSEIGNÉS DANS LE CONSTRUCTEUR DE L'ACTIVITÉ
    -- ?? LES PARAMÈTRES (DISPLAYMODE, TEXTE, ICONE...) DES COLONES DE GRID SONT RENSEIGNÉS DANS LE COMPOSANT DÉDIÉ DU LEADERBOARD
    -- ?? LES ATTRIBUTS - HEAP, BAKED - DES ENTITÉS SONT RENSEIGNÉS PAR 2 APPELS DE FONCTION DÉDIÉS DANS L'ACTIVITÉ (À SURCHARGER)
    -- ?? POUR LES DONNÉES DE CONFIGURATION DE BYTECODE, CE SERA SUREMENT PAREIL QUE POUR LES ATTRIBUTS = FONCTION DÉDIÉ (À SURCHARGER)
    -- ?? POUR LE LEADERBOARD:
    -- ??       - SURCHARGER LA PAGE QUI UTILISE LE LEADERBOARD STANDARD,
    -- ??       - RAJOUTER DES PARAMÈTRES (DISPLAYMODE, TEXTE, ICONE...) DES COLONES DE GRID SI NÉCESSAIRE EN + DE CEUX PAR DÉFAUT (LIFE, HIT, AMMO...)
    -- ??       - RENSEIGNER QUELS ATTRIBUTS ON SOUHAITE REPRÉSENTER PARMIS CEUX EXISTANT EN HEAP

    UAIntroduction.Ui.PlayersManagement.seqPairing = false

	-- max player is 4

	self.maxNumberOfPlayer = 4

end

-- __dtor --------------------------------------------------------------------

function UAIntroduction:__dtor()
end

-- initialize entity baked data  --------------------------------------------------------------------

function UAIntroduction:InitEntityFinalData(entity, ranking)

    UTActivity:InitEntityHeapData(entity, ranking)

	entity.data.baked.score = 0
	entity.data.baked.ranking = ranking
	entity.data.baked.gameover = false

end

-- initialize entity heap data  --------------------------------------------------------------------

function UAIntroduction:InitEntityHeapData(entity, ranking)

	UTActivity:InitEntityHeapData(entity, ranking)

	entity.data.heap.score = 0
	entity.data.heap.ranking = ranking

	entity.data.heap.hits = 0
	entity.data.heap.shots = 0
	entity.data.heap.gameover = false

end
