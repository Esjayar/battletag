
--[[--------------------------------------------------------------------------
--
-- File:            UIGridLine.DefaultCellStyle.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 10, 2010
--
------------------------------------------------------------------------------
--
-- Description:     draw a centered text
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UIGridLine.DefaultCellStyle = UTClass()

-- default

UIGridLine.DefaultCellStyle.font = UIComponent.fonts.default
UIGridLine.DefaultCellStyle.fontColor = UIComponent.colors.gray
UIGridLine.DefaultCellStyle.fontJustification = quartz.system.drawing.justification.center + quartz.system.drawing.justification.singlelineverticalcenter

UIGridLine.cellStyles = {

    default = UIGridLine.DefaultCellStyle

}

-- __ctor --------------------------------------------------------------------

function UIGridLine.DefaultCellStyle:__ctor(width, height)
end

-- __dtor --------------------------------------------------------------------

function UIGridLine.DefaultCellStyle:__dtor()
end

-- Draw ----------------------------------------------------------------------

function UIGridLine.DefaultCellStyle:Draw(content, cellRectangle)

    local font = self.font or UIGridLine.DefaultCellStyle.font
    local fontColor = self.fontColor or UIGridLine.DefaultCellStyle.fontColor
    local fontJustification = self.fontJustification or UIGridLine.DefaultCellStyle.fontJustification

    quartz.system.drawing.loadcolor3f(unpack(fontColor))
    quartz.system.drawing.loadfont(font)
    quartz.system.drawing.drawtextjustified(content or "nil", fontJustification, unpack(cellRectangle))


end
