
--[[--------------------------------------------------------------------------
--
-- File:            UIMultiComponent.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 7, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UIMultiComponent(UIComponent)

-- defaults

UIMultiComponent.opaque = true
UIMultiComponent.sensitive = true

-- __ctor --------------------------------------------------------------------

function UIMultiComponent:__ctor(...)
end

-- __dtor --------------------------------------------------------------------

function UIMultiComponent:__dtor()
end

-- RegisterPickRegions -------------------------------------------------------

function UIMultiComponent:RegisterPickRegions(regions, left, top)

	if (self.components and (0 < #self.components)) then

        -- relative transformation,
        -- does not take the scale into account, yet...

        left = left + ((self.rectangle and self.rectangle[1]) or 0)
        top = top + ((self.rectangle and self.rectangle[2]) or 0)

		for _, component in ipairs(self.components) do

            if (component.visible and component.sensitive) then
			    component:RegisterPickRegions(regions, left, top)
			end
		end
	end

	return self.opaque

end
