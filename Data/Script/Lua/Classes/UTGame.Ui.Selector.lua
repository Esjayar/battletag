
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.Ui.Selector.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 9, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTLocale"

require "UI/UISelector"

--[[ Class -----------------------------------------------------------------]]

UTGame.Ui = UTGame.Ui or {}
UTGame.Ui.Selector = UTClass(UISelector)

-- !! TODO CHANGE FILENAME

UTGame.Ui.Selector.Materials = {

	[0x03000040] = "rf01.tga",
	[0x03000041] = "rf02.tga",
	[0x03000050] = "rf03.tga",
	[0x03000051] = "rf04.tga",
	[0x03000052] = "rf05.tga",
	[0x03000053] = "rf06.tga",
	[0x03000030] = "rf07.tga",
	[0x03000031] = "rf08.tga",

}

-- __ctor --------------------------------------------------------------------

function UTGame.Ui.Selector:__ctor(...)

	-- window settings

	self.uiWindow.title = l "titlemen001"
    self.uiSelector.title = l "titlemen019"

    -- contents,

    self:Reserve(8, --[[ --?? SCROLLBAR ]] false)

    -- activity description on the right side,

    self.uiDetails = self.uiWindows:AddComponent(UITitledPanel:New(), "uiDetails")
    self.uiDetails.rectangle = self.uiWindows.clientRectangle
    self.uiDetails.title = "-"

    self.uiDetails.visible = false

    -- buttons,

    -- uiButton1: back

    self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
    self.uiButton1.rectangle = UIMenuWindow.buttonRectangles[1]
    self.uiButton1.text = l"but003"
	self.uiButton1.tip = l"tip006"

    self.uiButton1.OnAction = function (self) 
		quartz.framework.audio.loadsound("base:audio/ui/back.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()
		game:PostStateChange("title") 
    end

    -- uiButton3: select, play

    self.uiButton3 = self:AddComponent(UIButton:New(), "uiButton3")
    self.uiButton3.rectangle = UIMenuWindow.buttonRectangles[3]
    self.uiButton3.text = l"but023"
	self.uiButton3.tip = l"tip015"

    self.uiButton3.OnAction = function ()
    
        assert(self.nfo)
        assert(self.nfo.class)

		quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()
        game:PostStateChange("session", self.nfo, "playersmanagement")
    
    end

    -- uiButton4: select, play

    self.uiButton4 = self:AddComponent(UIButton:New(), "uiButton4")
    self.uiButton4.rectangle = UIMenuWindow.buttonRectangles[4]
    self.uiButton4.text = l"but024"
	self.uiButton4.tip = l"tip014"

    self.uiButton4.OnAction = function ()
    
        assert(self.nfo)
        assert(self.nfo.class)

		quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
		quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
		quartz.framework.audio.playsound()
        game:PostStateChange("session", self.nfo)
    
    end

    self.uiButton4.enabled = false

end

-- DisplaySelectedNfo --------------------------------------------------------

function UTGame.Ui.Selector:DisplaySelectedNfo(nfo)

    assert(nfo)

    self.uiButton4.enabled = true
    self.nfo = nfo

    self.uiDetails.visible = true
    self.uiDetails.title = nfo.name or nfo.__directory

end

-- Draw ----------------------------------------------------------------------

function UTGame.Ui.Selector:Draw()

    UIPage.Draw(self)

    --

    if (self.nfo) then

        quartz.system.drawing.pushcontext()

        quartz.system.drawing.loadtranslation(unpack(self.uiWindows.rectangle))
        quartz.system.drawing.loadtranslation(unpack(self.uiWindow.rectangle))
        quartz.system.drawing.loadtranslation(unpack(self.clientRectangle))
        
        -- pictogram

        local rectangle = { 20, 25 + 10}--, 20 + 96, 25 + 10 + 96 }

        quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
        quartz.system.drawing.loadtexture("base:texture/ui/pictograms/96x/" .. self.nfo.pictogram)
        quartz.system.drawing.drawtexture(unpack(rectangle))

        -- flags

        if (self.nfo.flags) then

            local offset = { rectangle[1] + 120, rectangle[2] }

            quartz.system.drawing.loadfont(UIComponent.fonts.default)
            quartz.system.drawing.loadtexture("base:texture/ui/icons/16x/bullet.tga")

            for index, flag in pairs(self.nfo.flags) do

                quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.orange))
                quartz.system.drawing.drawtexture(offset[1], offset[2] + 1)

                quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
                quartz.system.drawing.drawtext(flag, offset[1] + 24, offset[2])

                offset[2] = offset[2] + 18

            end
        end

        -- description

        quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.orange))
        quartz.system.drawing.loadfont(UIComponent.fonts.header)
        quartz.system.drawing.drawtext(l "oth026" .. " :", rectangle[1], rectangle[2] + 110)

        local text = self.nfo.description or l "oth038"
        local fontJustification = quartz.system.drawing.justification.topleft + quartz.system.drawing.justification.wordbreak

        rectangle = { rectangle[1], rectangle[2] + 120 + 24, 355, rectangle[2] + 120 + 24 + 96 }

        quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.darkgray))
        quartz.system.drawing.loadfont(UIComponent.fonts.default)
        quartz.system.drawing.drawtextjustified(text, fontJustification, unpack(rectangle))
        --quartz.system.drawing.loadtexture("base:texture/ui/components/uipanel07.tga")
        --quartz.system.drawing.drawtexture(unpack(rectangle))

        -- material

		if (self.nfo.materials) then
	
			quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.orange))
			quartz.system.drawing.loadfont(UIComponent.fonts.header)
			quartz.system.drawing.drawtext(l "titlemen008" .. ":", rectangle[1], rectangle[4] - 26)
		
			for index = 1, 12 do
			
				local rectMaterial = {12 + (index % 6) * 60, 285 + math.floor((index - 1) / 6) * 70, 62 + (index%6) * 60, 335 + math.floor((index - 1) / 6) * 70}
				
				quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
				quartz.system.drawing.loadtexture("base:texture/ui/components/UIPanel11.tga")
				quartz.system.drawing.drawtexture(unpack(rectMaterial))	
				
			end
            
            local position = 1
            
            for index, material in ipairs(self.nfo.materials) do
            
				local vectMaterial = {rectangle[1] + ((position - 1) % 6) * 60 - 15, rectangle[2] + 99 + math.floor((position - 1) / 6) * 70}
				
				if (UTGame.Ui.Selector.Materials[material] and (game.settings.addons.medkitPack == 1 or (material ~= 0x03000030 and material ~= 0x03000031 and material ~= 0x03000052 and material ~= 0x03000053))) then
				
					quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
					quartz.system.drawing.loadtexture("base:texture/ui/pictograms/64x/" .. UTGame.Ui.Selector.Materials[material])
					quartz.system.drawing.drawtexture(unpack(vectMaterial))	
					
					position = position + 1	
					
				end
            
			end
		end

        quartz.system.drawing.pop()

    end

end

-- OnOpen --------------------------------------------------------------------

function UTGame.Ui.Selector:Open()

    if (not game.nfos or (0 == #game.nfos)) then

        -- !! PUSH ERROR MESSAGE, CANNOT LOCATE ACTIVITIES,
        -- !! BACK TO TITLE

        for i, uiItem in pairs(self.uiSelector.uiItems) do
            uiItem.enabled = false
        end

    else

        -- sort nfos by difficulty

        local sortByDifficulty = function (left, right)

            if (left.difficulty  and right.difficulty) then
                if (left.difficulty  == right.difficulty) then return left.name < right.name
                else return left.difficulty < right.difficulty
                end
            elseif (left.difficulty) then
                return true
            elseif (right.difficulty) then
                return false
            else
                return left.name < right.name
            end

        end

        table.sort(game.nfos, sortByDifficulty)

        for _, nfo in ipairs(game.nfos) do

            local properties = { color = UIComponent.colors.red, headerIcon = "base:texture/ui/pictograms/32x/" .. nfo.pictogram, text = nfo.name or nfo.__directory, userData = nfo }
            local item = self:AddItem(properties)

            item.Action = function ()

                if (item.userData) then
                    self:DisplaySelectedNfo(item.userData)
                end
            end

        end

        self.index = 1
        self:Scroll(0)

        self:DisplaySelectedNfo(game.nfos[1])

    end

end