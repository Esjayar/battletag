
--[[--------------------------------------------------------------------------
--
-- File:            UIBitmap.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 16, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UIBitmap(UIComponent)

-- default

UIBitmap.bitmap = nil

-- __ctor ------------------------------------------------------------------

function UIBitmap:__ctor(bitmap, rectangle)

    self.bitmap = bitmap
    self.rectangle = rectangle

    if (bitmap and not rectangle) then

        quartz.system.drawing.loadtexture(bitmap)
        local width, height = quartz.system.drawing.gettexturedimensions()

        self.rectangle = { 0, 0, width, height }

    end

end

-- Draw --------------------------------------------------------------------

function UIBitmap:Draw()

    if (self.rectangle and self.bitmap) then

	    quartz.system.drawing.loadcolor3f(unpack(self.color or UIComponent.colors.white))
        quartz.system.drawing.loadtexture(self.bitmap)
        quartz.system.drawing.drawtexture(unpack(self.rectangle))

    end

end