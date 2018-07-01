
--[[--------------------------------------------------------------------------
--
-- File:            UTBasics.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 2, 2010
--
------------------------------------------------------------------------------
--
-- Description:     Generic player.
--                  May be part of a team (UTTeam) of players.
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTClass"

--[[ Class -----------------------------------------------------------------]]

UTBasics = UTClass()

UTBasics.slides = nil

-- Initialize --------------------------------------------------------------------

function UTBasics:Initialize()

	if (UTBasics.slides == nil) then

		UTBasics.slides = {
		[1] = 
		{
			title = l"bas121",
			bitmaps = {"base:texture/ui/basics12.tga",},
			texts = {l"bas122"},
		},
		[2] = 
		{
			title = l"bas001",
			bitmaps = {"base:texture/ui/basics00.tga",},
			texts = {l"bas002",},
		},
		[3] = 
		{
			title = l"bas011",
			bitmaps = {"base:texture/ui/basics01.tga",},
			texts = {l"bas012",},
		},
		[4] = 
		{
			title = l"bas031",
			bitmaps = {"base:texture/ui/basics03A.tga","base:texture/ui/basics03B.tga","base:texture/ui/basics03C.tga","base:texture/ui/basics03D.tga","base:texture/ui/basics03E.tga","base:texture/ui/basics03F.tga","base:texture/ui/basics03G.tga","base:texture/ui/basics03H.tga",},
			texts = {l"bas032",l"bas033",l"bas034",l"bas035",l"bas036",l"bas037",l"bas038",l"bas039"},
		},
		[5] = 
		{
			title = l"bas041",
			bitmaps = {"base:texture/ui/basics04_1.tga","base:texture/ui/basics04_2.tga","base:texture/ui/basics04_3.tga","base:texture/ui/basics04_4.tga","base:texture/ui/basics04_5.tga","base:texture/ui/basics04_6.tga","base:texture/ui/basics04_7.tga",},
			texts = {l"bas042",l"bas043",l"bas044",l"bas045",l"bas046",l"bas047",l"bas048",},
		},
		[6] = 
		{
			title = l"bas021",
			bitmaps = {"base:texture/ui/basics02.tga",},
			texts = {l"bas022",},
		},
		[7] = 
		{
			title = l"bas151",
			bitmaps = {"base:texture/ui/basics15.tga",},
			texts = {l"bas152",},
		},
		[8] = 
		{
			title = l"bas051",
			bitmaps = {"base:texture/ui/basics05.tga",},
			texts = {l"bas052",},
		},
		[9] = 
		{
			title = l"bas131",
			bitmaps = {"base:texture/ui/basics13.tga",},
			texts = {l"bas132"},
		},
		[10] = 
		{
			title = l"bas111",
			bitmaps = {"base:texture/ui/basics11.tga",},
			texts = {l"bas112"},
		},
		[11] = 
		{
			title = l"bas101",
			bitmaps = {"base:texture/ui/basics10.tga",},
			texts = {l"bas102",},
		},
		[12] = 
		{
			title = l"bas061",
			bitmaps = {"base:texture/ui/basics06_1.tga","base:texture/ui/basics06_2.tga","base:texture/ui/basics06_3.tga","base:texture/ui/basics06_4.tga"},
			texts = {l"bas062",l"bas063",l"bas064",l"bas065",},
		},
		[13] = 
		{
			title = l"bas081",
			bitmaps = {"base:texture/ui/basics08.tga",},
			texts = {l"bas082",},
		},
		[14] = 
		{
			title = l"bas071",
			bitmaps = {"base:texture/ui/basics07.tga",},
			texts = {l"bas072",},
		},
		[15] = 
		{
			title = l"bas091",
			bitmaps = {"base:texture/ui/basics09.tga",},
			texts = {l"bas092",},
		},
		[16] = 
		{
			title = l"bas141",
			bitmaps = {"base:texture/ui/basics14_1.tga","base:texture/ui/basics14_2.tga","base:texture/ui/basics14_3.tga","base:texture/ui/basics14_4.tga","base:texture/ui/basics14_5.tga","base:texture/ui/basics14_6.tga","base:texture/ui/basics14_7.tga","base:texture/ui/basics14_8.tga","base:texture/ui/basics14_9.tga","base:texture/ui/basics14_10.tga","base:texture/ui/basics14_11.tga",},
			texts = {l"bas148",l"bas144",l"bas146",l"bas143",l"bas149",l"bas142",l"bas1412",l"bas1410",l"bas1411",l"bas145",l"bas147",},
		},
		}
	end
end