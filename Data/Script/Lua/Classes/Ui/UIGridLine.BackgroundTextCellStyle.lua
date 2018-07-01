
--[[--------------------------------------------------------------------------
--
-- File:            UIGridLine.BackgroundTextCellStyle.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            Septembre 10, 2010
--
------------------------------------------------------------------------------
--
-- Description:     Draw a text with the specified background
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UIGridLine.BackgroundTextCellStyle = UTClass(UIGridLine.DefaultCellStyle)

-- default

UIGridLine.BackgroundTextCellStyle.color = UIComponent.colors.white
UIGridLine.BackgroundTextCellStyle.fontColor = UIComponent.colors.orange
UIGridLine.BackgroundTextCellStyle.font = UIComponent.colors.default

UIGridLine.cellStyles.icon = UIGridLine.BackgroundTextCellStyle

-- __ctor -------------------------------------------------------------------

function UIGridLine.BackgroundTextCellStyle:__ctor(width, height, background)

    self.size = { width, height }
    self.background = background

end

-- Draw ---------------------------------------------------------------------

function UIGridLine.BackgroundTextCellStyle:Draw(content, cellRectangle)

    -- justify the cell's position

    local rectangle = {}
    local heightRow = cellRectangle[4] - cellRectangle[2]

    if (self.size[2]) then

        local positionY = ((heightRow - self.size[2]) / 2) + cellRectangle[2]
        rectangle = { cellRectangle[1], positionY , cellRectangle[3], positionY + self.size[2] }
        
    else

        rectangle = cellRectangle

    end
    
    local widthRow = rectangle[3] - rectangle[1]
        
    if (self.size[1]) then

        local positionX = ((widthRow - self.size[1]) / 2) + rectangle[1]
        rectangle = { positionX, rectangle[2], positionX + self.size[1], rectangle[4] }
    
    end

    -- the real draw begin here..

    if (self.background) then

        local color = self.color or UIComponent.colors.white
        quartz.system.drawing.loadcolor3f(unpack(color))
        quartz.system.drawing.loadtexture(self.background)
        quartz.system.drawing.drawtexture(unpack(rectangle))

    end
 
    if (content) then

        local fontColor = self.fontColor or UIComponent.colors.white
        local font = self.font or UIComponent.fonts.default
        local fontJustification = quartz.system.drawing.justification.center + quartz.system.drawing.justification.singlelineverticalcenter

        quartz.system.drawing.loadcolor3f(unpack(fontColor))
        quartz.system.drawing.loadfont(font)
        quartz.system.drawing.drawtextjustified(content, fontJustification, unpack(rectangle))

    end

end