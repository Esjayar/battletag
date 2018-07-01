
--[[--------------------------------------------------------------------------
--
-- File:            UIGrid.lua
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

require "Ui/UIGridLine"
require "Ui/UIPanel"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIGrid(UIMultiComponent)

-- defaults

UIGrid.padding = 10
UIGrid.rectangle = { 0, 0, 0, 0 }

-- ?? CONSTRUCTION DU COLUMN DESCRIPTOR

--COLUMNSDESCRIPTOR = {
--
	    --[X] = { [STYLE = UIGRIDLINE.CELLSTYLE], WIDTH = NUMBER, KEY = STRING, [PREFERREDHEIGHT = NUMBER], },
--
	--}

-- __ctor ------------------------------------------------------------------

function UIGrid:__ctor(columnsDescriptor, headerDescriptor)

    self.rectangle = { 0, 0, 0, 0 }

    self.columns = {}
    self.rows = {}
    self.header = headerDescriptor
    table.foreachi(columnsDescriptor, function(index, column) 

        --if (self.header) then self.header[index].offset = self.rectangle[3] end

        table.insert(self.columns, column)
        column.offset = self.rectangle[3]
        self.rectangle[3] = self.rectangle[3] + column.width
        
    end )
    
    ---- parse the header table to know the original height of the grid
    --
    --if (self.header) then
    --
       --table.foreachi(self.header, function(_, headerCell)
        --
            --self.rectangle[4] = math.max(self.rectangle[4], headerCell.size and headerCell.size[2] or 0)            
--
        --end )        
        --
        --self.header.height = self.rectangle[4]
        --print(self.rectangle[4])
        --
    --end
    
end

-- __dtor ------------------------------------------------------------------

function UIGrid:__dtor()
end

-- AddColumn ---------------------------------------------------------------

function UIGrid:AddColumn(columnDescriptor)

    -- add a new column according to its descriptor

    table.insert(self.columns, columnDescriptor)
    columnDescriptor.offset = self.rectangle[3]
    self.rectangle[3] = self.rectangle[3] + columnDescriptor.width

end

-- AddColumnAt -------------------------------------------------------------

function UIGrid:AddColumnAt(columnDescriptor, index)

    -- add a new column at the specified index
    
    index = (index > #self.columns + 1 and #self.columns + 1) or index

    table.insert(self.columns, index, columnDescriptor)

    -- change the offset of the following columns

    for i = index, #self.columns do

        local previousColumn = self.columns[i-1]
        self.columns[i].offset = (previousColumn and previousColumn.offset + previousColumn.width or 0)
        print(i, self.columns[i].offset)

    end
    
    self.rectangle[3] = self.rectangle[3] + columnDescriptor.width

end

-- AddLine -----------------------------------------------------------------

function UIGrid:AddLine(lineContent, lineHeight, background)

    self.rows = self.rows or {}
    local row = self:AddComponent(UIGridLine:New(self, lineContent, lineHeight or self.height), "uiGridLine" .. #self.rows + 1)

	row.background = background	
	
    -- move the row at the end of the grid

    row:MoveTo(0, self.rectangle[4] - self.rectangle[2])

    -- and then update the grid's rectangle

    self.rectangle[4] = self.rectangle[4] + self.padding + row.height

    table.insert(self.rows, row)

end

-- Draw --------------------------------------------------------------------

function UIGrid:Draw()

     if (self.visible) then
     
        if (self.rectangle) then
            
            --if (self.header) then
--
                --quartz.system.drawing.pushcontext()
                --quartz.system.drawing.loadtranslation(self.rectangle[1], self.rectangle[2])
--
                --table.foreachi(self.header, function(index, headerCell)
--
                    --local cellRectangle = { headerCell.offset, 0, (headerCell.size and headerCell.size[1] or self.columns[index].width) + headerCell.offset, (headerCell.size and headerCell.size[2] or self.header.height) }                    
--
                    --local cellStyle = headerCell.style or UIGridLine.cellStyles.default
                    --cellStyle:Draw(headerCell.content or "", cellRectangle)
--
                --end )
                 --
                --quartz.system.drawing.pop()
                --
            --end
        end    
    end

    UIMultiComponent.Draw(self)

end

-- RemoveColumnAt -------------------------------------------------------------

function UIGrid:RemoveColumnAt(index)

    --if (self.rows and 0 < #self.rows) then print("You cannot remove columns if the grid is not empty") return end
    
    index = (index > #self.columns + 1 and #self.columns + 1) or index

    table.remove(self.columns, index)

end

-- SetColumnDescriptor -----------------------------------------------------

function UIGrid:SetColumnDescriptor(columnsDescriptor)

    self.columns = {}
    table.foreachi(columnsDescriptor, function(index, column) 

        table.insert(self.columns, column)
        column.offset = self.rectangle[3]
        self.rectangle[3] = self.rectangle[3] + column.width
        
    end )

end

-- SetRowsHeight -----------------------------------------------------------

function UIGrid:SetRowsPadding(newPadding)

    self.rectangle[4] = self.rectangle[2]
    self.padding = newPadding

    -- move the rows according to the new padding

    table.foreachi(self.rows, function(_,row) 

        row:MoveTo(0, (self.rectangle[4]) - self.rectangle[2])        
        self.rectangle[4] = self.rectangle[4] + self.padding + row.height
        
    end)
    
    -- do not consider the padding at the end of the last row

    self.rectangle[4] = self.rectangle[4] - self.padding
        
end