
--[[--------------------------------------------------------------------------
--
-- File:            UIGridLine.ImageCellStyle.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 10, 2010
--
------------------------------------------------------------------------------
--
-- Description:     draw a bitmap
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UIGridLine.ImageCellStyle = UTClass(UIGridLine.DefaultCellStyle)

-- default

UIGridLine.ImageCellStyle.color = UIComponent.colors.white

UIGridLine.cellStyles.image = UIGridLine.ImageCellStyle

-- __ctor -------------------------------------------------------------------

--function UIGridLine.ImageCellStyle:__ctor()
--end

-- Draw ---------------------------------------------------------------------

function UIGridLine.ImageCellStyle:Draw(content, cellRectangle, preferredHeight, preferredWidth)

    -- justify the cell if the row's height is different from the preferred size of the cell

    local rectangle = {}
    local heightRow = cellRectangle[4] - cellRectangle[2]
    --print(content, preferredHeight)
    if (preferredHeight and heightRow > preferredHeight) then

        local positionY = ((heightRow - preferredHeight) / 2) + cellRectangle[2]
        rectangle = { cellRectangle[1], positionY , cellRectangle[3], positionY + preferredHeight }
        
    else

        rectangle = cellRectangle

    end
    
    local widthRow = rectangle[3] - rectangle[1]
        
    if (preferredWidth and widthRow > preferredWidth) then
    
        local positionX = ((widthRow - preferredWidth) / 2) + rectangle[1]
        rectangle = { positionX, rectangle[2], positionX + preferredWidth, rectangle[4] }
    
    end

    local color = self.color or UIGridLine.ImageCellStyle.color
    quartz.system.drawing.loadcolor3f(unpack(color))
    quartz.system.drawing.loadtexture(content)
    quartz.system.drawing.drawtexture(unpack(rectangle))

end