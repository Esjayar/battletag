
--[[--------------------------------------------------------------------------
--
-- File:            UIRegion.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 9, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UI/UIComponent"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIRegion(UIComponent)

-- defaults

ST_DISABLED, ST_ENABLED, ST_FOCUSED, ST_CLICKED = 0, 1, 2, 4

UIRegion.states = {

    [ST_DISABLED] = { texture = "base:texture/ui/components/uibutton_menu_disabled.tga" },
    [ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_menu_disabled.tga" },

    [ST_ENABLED] = { texture = "base:texture/ui/components/uibutton_menu.tga" },
    [ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_menu_focused.tga" },
    [ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_menu_focused.tga" },
    [ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_menu_entered.tga" },

}

UIRegion.rectangle = { 0, 0, 10, 10 }
UIRegion.text = "uiRegion"

UIRegion.opaque = true
UIRegion.sensitive = true

-- __ctor -------------------------------------------------------------------

function UIRegion:__ctor()
end

-- __dtor -------------------------------------------------------------------

function UIRegion:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UIRegion:Draw()

    --[[
	if (self.visible) then
	
	    if (self.rectangle) then

            local index = ((self.enabled and ST_ENABLED) or ST_DISABLED) + ((self.focused and ST_FOCUSED) or 0) + ((self.clicked and ST_CLICKED) or 0)
            local state = self.states[index]

            if (not state) then print(index) end
            if (state.texture) then

                local color = (state and state.color) or self.color or UIComponent.colors.white
                
	            quartz.system.drawing.loadcolor3f(unpack(color))
	            quartz.system.drawing.loadtexture(self.states[index].texture)
		        quartz.system.drawing.drawtexture(unpack(self.rectangle))

		    end

    	    if (self.text) then

    	   	    local font = (state and state.font) or self.font
    	   	    local fontColor = (state and state.fontColor) or self.fontColor
    	   	    local fontJustification = (state and state.fontJustification) or self.fontJustification

                quartz.system.drawing.loadcolor3f(unpack(fontColor))
    	        quartz.system.drawing.loadfont(font)
                quartz.system.drawing.drawtextjustified(self.text, fontJustification, unpack(self.rectangle)) 

            end
        end
	end
	--]]

end

-- OnAction ------------------------------------------------------------------

function UIRegion:OnAction()
end

-- RegisterPickRegions -------------------------------------------------------

function UIRegion:RegisterPickRegions(regions, left, top)

	if (self.sensitive and self.rectangle) then

		local region = {
			component = self,
			rectangle = { self.rectangle[1] + left, self.rectangle[2] + top, self.rectangle[3] + left, self.rectangle[4] + top }
		}

		table.insert(regions, region)

	end

end
