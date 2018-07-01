
--[[--------------------------------------------------------------------------
--
-- File:            UIGridLine.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 5, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIPanel"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIGridLine(UIMultiComponent)

require "Ui/UIGridLine.DefaultCellStyle"
require "Ui/UIGridLine.ImageCellStyle"
require "Ui/UIGridLine.RowTitleCellStyle"
require "Ui/UIGridLine.RightCellStyle"
require "Ui/UIGridLine.IconCellStyle"
require "Ui/UIGridLine.BackgroundTextCellStyle"

-- defaults

UIGridLine.rectangle = { 0, 0, 0, 0 }
UIGridLine.height = 25

-- __ctor ------------------------------------------------------------------

function UIGridLine:__ctor(grid, content, height)

    self.grid = grid
    self.content = content
    self.rectangle = { 0, 0, 0, 0 }
    self.cellsOffset = {}
    self.height = height

    -- update gridline's rectangle

    table.foreachi(self.grid.columns, function(_, column) 

        self.rectangle[3] = self.rectangle[3] + column.width

    end )

    self.rectangle[4] = self.height

end

-- __dtor ------------------------------------------------------------------

function UIGridLine:__dtor()
end

-- Draw --------------------------------------------------------------------

function UIGridLine:Draw()

    if (self.visible) then

        if (self.content) then

            if (self.rectangle) then

                if (self.background or self.grid.lineBackground) then

                    local color = self.color or UIComponent.colors.white

                    quartz.system.drawing.loadcolor3f(unpack(color))
                    quartz.system.drawing.loadtexture(self.background or self.grid.lineBackground)
                    
                    local backgroundRectangle = { self.rectangle[1] - 10, self.rectangle[2], self.rectangle[3] + 10, self.rectangle[4] }
                    quartz.system.drawing.drawwindow(unpack(backgroundRectangle))

                end

                quartz.system.drawing.pushcontext()
                quartz.system.drawing.loadtranslation(self.rectangle[1], self.rectangle[2])
                
                table.foreachi(self.grid.columns, function(index, column)
                    
                    local cellRectangle = { column.offset, 0, column.width + column.offset, self.height or UIGridLine.height }
                    local cellStyle = column.style or UIGridLine.cellStyles.default
                    cellStyle:Draw(self.content[column.key], cellRectangle, column.preferredHeight, column.preferredWidth)

                end )
                
                quartz.system.drawing.pop()

            end
        end
    end

end