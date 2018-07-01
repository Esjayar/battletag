
--[[--------------------------------------------------------------------------
--
-- File:            UIGridLine.RightCellStyle.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            August 16, 2010
--
------------------------------------------------------------------------------
--
-- Description:     Draw a text on the right
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UIGridLine.RightCellStyle = UTClass(UIGridLine.DefaultCellStyle)

-- default

UIGridLine.RightCellStyle.font = UIComponent.fonts.default
UIGridLine.RightCellStyle.fontColor = UIComponent.colors.orange
UIGridLine.RightCellStyle.fontJustification = quartz.system.drawing.justification.right + quartz.system.drawing.justification.singlelineverticalcenter

UIGridLine.cellStyles.right = UIGridLine.RightCellStyle

-- __dtor --------------------------------------------------------------------

function UIGridLine.RightCellStyle:__dtor()
end