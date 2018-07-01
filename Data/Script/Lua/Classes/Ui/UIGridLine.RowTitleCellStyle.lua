
--[[--------------------------------------------------------------------------
--
-- File:            UIGridLine.RowTitleCellStyle.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 16, 2010
--
------------------------------------------------------------------------------
--
-- Description:     Draw a text on the left
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UIGridLine.RowTitleCellStyle = UTClass(UIGridLine.DefaultCellStyle)

-- default

UIGridLine.RowTitleCellStyle.font = UIComponent.fonts.default
UIGridLine.RowTitleCellStyle.fontColor = UIComponent.colors.gray
UIGridLine.RowTitleCellStyle.fontJustification = quartz.system.drawing.justification.left + quartz.system.drawing.justification.singlelineverticalcenter

UIGridLine.cellStyles.rowLabel = UIGridLine.RowTitleCellStyle

-- __dtor --------------------------------------------------------------------

function UIGridLine.RowTitleCellStyle:__dtor()
end