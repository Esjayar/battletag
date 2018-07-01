
--[[--------------------------------------------------------------------------
--
-- File:            UIGridLine.ImageCellStyle.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            Septembre 10, 2010
--
------------------------------------------------------------------------------
--
-- Description:     draw an icon with the specified size
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UIGridLine.IconCellStyle = UTClass(UIGridLine.DefaultCellStyle)

-- default

UIGridLine.IconCellStyle.color = UIComponent.colors.white

UIGridLine.cellStyles.icon = UIGridLine.IconCellStyle

-- __ctor -------------------------------------------------------------------

function UIGridLine.IconCellStyle:__ctor(width, height)

    self.size = { width, height }

end

-- Draw ---------------------------------------------------------------------

function UIGridLine.IconCellStyle:Draw(content, cellRectangle)

    if (not content) then return
    end

    -- justify the cell if the row's height is different from the preferred size of the cell
    --print("draw", unpack(self.size))
    local rectangle = {}
    local heightRow = cellRectangle[4] - cellRectangle[2]
    --print(content, preferredHeight)
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

    local color = self.color or UIComponent.colors.white
    quartz.system.drawing.loadcolor3f(unpack(color))
    quartz.system.drawing.loadtexture("base:/texture/avatars/" .. self.size[1] .. "x/" .. content)
    quartz.system.drawing.drawtexture(unpack(rectangle))

end