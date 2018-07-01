
--[[--------------------------------------------------------------------------
--
-- File:            UIAFP.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 13, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIPanel"
require "Ui/UITitledPanel"
require "UTActivity.Ui.Menu"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIAFP(UIMultiComponent)

-- default

UIAFP.maxHeight = 630
UIAFP.width = 380
UIAFP.background = "base:texture/ui/afp_background01.tga"
UIAFP.titleRectangle =  { 15, 23, 380, 60 }

--UIAFP.buttonMenuRectangle =  { 65, 572, 202, 606 }
UIAFP.buttonMenuRectangle =  { 15, 582, 152, 616 }

-- timer box

UIAFP.timer = {

    backgroundRectangle = { 15, 65, 365, 175 },
    titleRectangle = { 45, 65, 335, 100 },
    textMinutePosition1 = { 43, 100},
    textMinutePosition2 = { 100, 100},
    textSecondPosition1 = { 188, 100},
    textSecondPosition2 = { 245, 100},
    textSecondRectangle = { 200, 100, 300, 175 },
    textMinuteRectangle = { 45, 100, 200, 175 },
    textSecondRectangle = { 200, 100, 300, 175 },
    reflectionRectangle = { 15, 100, 365, 175 },

    background = "base:texture/ui/afp_timerbackground.tga",
    reflection = "base:texture/ui/afp_timerreflection.tga",
    title = "Timer",

}

-- event box

UIAFP.eventsBox = {

    rectangleWithoutTimer = { 15, 75, 365, 565 },
    rectangleWithTimer = { 15, 195, 365, 565 },
    headerRectangle = { 15, 0, 365, 30 },
    textHeaderRectangle = { 55, 0, 325, 30 },
    footerRectangle = { 15, 545, 365, 565 },
    rowRectangle = { 15, 0, 365, 18 },
    rowPadding = 1,
    rowInitPosition = 526,
    arrowRectangle = { 345, 527, 363, 543 },
    iconRectangle = { 25, 9, 25 + 16, 9 + 16 },
    textRectangle = { 55, 0, 325, 18 },

    headerBackground = "base:texture/ui/afp_eventheader.tga",
    footerBackground = "base:texture/ui/afp_eventfooter.tga",
    rowBackground = "base:texture/ui/afp_eventline.tga",
    arrow = "base:texture/ui/afp_eventarrow.tga",
    textHeader = "Events",

}

-- __ctor ------------------------------------------------------------------

function UIAFP:__ctor(noTimer)

	UIAFP.eventsBox.textHeader = l"titlemen018"
	UIAFP.timer.title = l"titlemen017"
    self.rectangle = { 0, 0, self.width, self.maxHeight }
    self.rows = {}

    self.uiPanel = self:AddComponent(UIPicture:New(), "uiPanel")
    self.uiPanel.rectangle = self.rectangle
    self.uiPanel.texture = UIAFP.background    

    -- !! CHECK IF IT'S A TIMEBASED GAME
    self.timeBased = not noTimer
    self.eventsBox.rectangle = (self.timeBased and self.eventsBox.rectangleWithTimer) or self.eventsBox.rectangleWithoutTimer

    -- compute the space available for the rows and the number of rows allowed

    local spaceAvailable = (self.eventsBox.rectangle[4] - self.eventsBox.rectangle[2]) - self.eventsBox.headerRectangle[4] - (self.eventsBox.footerRectangle[4] - self.eventsBox.footerRectangle[2])
    self.maxRows =  spaceAvailable / (self.eventsBox.rowRectangle[4] + self.eventsBox.rowPadding * 2)

    for i = 1, self.maxRows do

        local row = { background = self.eventsBox.rowBackground, rectangle = { 0, 0, 0, 0 }, }
        table.insert(self.rows, row)

        local offset = (i-1) * (self.eventsBox.rowRectangle[4] + self.eventsBox.rowPadding * 2)
        row.rectangle = { self.eventsBox.rowRectangle[1], self.eventsBox.rowInitPosition - offset, self.eventsBox.rowRectangle[3], self.eventsBox.rowInitPosition - offset + self.eventsBox.rowRectangle[4] }

    end

    -- finally, compute the right rectangle of the event header

    self.headerRectangle = { self.eventsBox.headerRectangle[1], self.eventsBox.rectangle[2], self.eventsBox.headerRectangle[3], self.eventsBox.rectangle[2] + self.eventsBox.headerRectangle[4] }
    self.textHeaderRectangle = { self.eventsBox.textHeaderRectangle[1], self.eventsBox.rectangle[2], self.eventsBox.textHeaderRectangle[3], self.eventsBox.rectangle[2] + self.eventsBox.textHeaderRectangle[4] }

    -- menu button
    
    self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
    self.uiButton1.rectangle = UIAFP.buttonMenuRectangle
	self.uiButton1.text = l"but016"
	self.uiButton1.tip = l"tip066"

	self.uiButton1.OnAction = function (self) UIManager.stack:Push(UTActivity.Ui.Menu) end

end

-- __dtor ------------------------------------------------------------------

function UIAFP:__dtor()
end

-- Draw --------------------------------------------------------------------

function UIAFP:Draw()

    UIMultiComponent.Draw(self)

    if (self.rectangle) then

        quartz.system.drawing.pushcontext()
        quartz.system.drawing.loadtranslation(self.rectangle[1], self.rectangle[2])

        -- activity name

        local color = UIComponent.colors.orange
        local font = UIComponent.fonts.title
        local fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter

        quartz.system.drawing.loadcolor3f(unpack(color))
        quartz.system.drawing.loadfont(font)
        quartz.system.drawing.drawtextjustified(activity.name, fontJustification, unpack(self.titleRectangle))

        -- timer

        if (self.timeBased) then

            color = UIComponent.colors.white
            quartz.system.drawing.loadcolor3f(unpack(color))
            quartz.system.drawing.loadtexture(self.timer.background)
            quartz.system.drawing.drawtexture(unpack(self.timer.backgroundRectangle))

            font = UIComponent.fonts.header
            color = UIComponent.colors.gray
            fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter

            quartz.system.drawing.loadcolor3f(unpack(color))
            quartz.system.drawing.loadfont(font)
            quartz.system.drawing.drawtextjustified(self.timer.title, fontJustification, unpack(self.timer.titleRectangle))

            color = UIComponent.colors.darkgray

            local time = math.ceil(activity.timer / 1000000)
            local timerMinute = math.floor(time / 60)
            local timerSecond = math.mod(time, 60)
            
            quartz.system.drawing.loadcolor3f(unpack(color))
            
            
			quartz.system.drawing.loadtexture("base:texture/ui/afp_number_" .. math.floor(timerMinute/10) .. ".tga")
			quartz.system.drawing.drawtexture(unpack(self.timer.textMinutePosition1))
            
            quartz.system.drawing.loadtexture("base:texture/ui/afp_number_" .. (timerMinute%10) .. ".tga")
            quartz.system.drawing.drawtexture(unpack(self.timer.textMinutePosition2))
            
            quartz.system.drawing.loadtexture("base:texture/ui/afp_number_" .. math.floor(timerSecond/10) .. ".tga")
            quartz.system.drawing.drawtexture(unpack(self.timer.textSecondPosition1))
            
            quartz.system.drawing.loadtexture("base:texture/ui/afp_number_" .. (timerSecond%10) .. ".tga")
            quartz.system.drawing.drawtexture(unpack(self.timer.textSecondPosition2))
            
            color = UIComponent.colors.white            

            quartz.system.drawing.loadcolor3f(unpack(color))
            quartz.system.drawing.loadtexture(self.timer.reflection)
            quartz.system.drawing.drawtexture(unpack(self.timer.reflectionRectangle))

        end

        -- event box header & footer

        color = UIComponent.colors.white

        quartz.system.drawing.loadcolor3f(unpack(color))
        quartz.system.drawing.loadtexture(self.eventsBox.footerBackground)
        quartz.system.drawing.drawtexture(unpack(self.eventsBox.footerRectangle))

        quartz.system.drawing.loadtexture(self.eventsBox.headerBackground)
        quartz.system.drawing.drawtexture(unpack(self.headerRectangle))

        color = UIComponent.colors.gray
        font = UIComponent.fonts.default
        fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter

        quartz.system.drawing.loadcolor3f(unpack(color))
        quartz.system.drawing.loadfont(font)
        quartz.system.drawing.drawtextjustified(self.eventsBox.textHeader, fontJustification, unpack(self.textHeaderRectangle))

        -- event box rows

        fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter
        font = UIComponent.fonts.default

        if (self.rows and 0 < #self.rows) then

            table.foreachi(self.rows, function(_, row)

                if (row.background) then

                    color = UIComponent.colors.white

                    quartz.system.drawing.loadcolor3f(unpack(color))
                    quartz.system.drawing.loadtexture(row.background)
                    quartz.system.drawing.drawtexture(unpack(row.rectangle))

                end

                if (row.icon) then

                    color = UIComponent.colors.white

                    local iconRectangle = self.eventsBox.iconRectangle
                    iconRectangle[2] = row.rectangle[2]
                    iconRectangle[4] = row.rectangle[4]

                    quartz.system.drawing.loadcolor3f(unpack(color))
                    quartz.system.drawing.loadtexture(row.icon)
                    quartz.system.drawing.drawtexture(unpack(iconRectangle))

                end

                if (row.text) then

                    color = row.color or UIComponent.colors.gray

                    local textRectangle = self.eventsBox.textRectangle
                    textRectangle[2] = row.rectangle[2]
                    textRectangle[4] = row.rectangle[4]

                    quartz.system.drawing.loadcolor3f(unpack(color))
                    quartz.system.drawing.loadfont(font)
                    quartz.system.drawing.drawtextjustified(row.text, fontJustification, unpack(textRectangle))

                end

                color = UIComponent.colors.white

                quartz.system.drawing.loadcolor3f(unpack(color))
                quartz.system.drawing.loadtexture(self.eventsBox.arrow)
                quartz.system.drawing.drawtexture(unpack(self.eventsBox.arrowRectangle))

            end )

        end

        quartz.system.drawing.pop()

    end

end

-- PushLine -----------------------------------------------------------------

function UIAFP:PushLine(theText, theColor, theIcon)

    self.rows = self.rows or {}

    -- create the new row with the specified text, color and icon

    local newRow = { icon = theIcon, text = theText, color = theColor, rectangle = { 0, 0, 0, 0 }, background = self.eventsBox.rowBackground }
    table.insert(self.rows, 1, newRow)

    -- compute the new position of the rows

    table.foreachi(self.rows, function(index, row) 

        row.rectangle = self.rows[index+1] and self.rows[index+1].rectangle or {}

    end )

    -- pop the last row if there is more than maxRows rows

    if (self.maxRows < #self.rows) then table.remove(self.rows) end

end
