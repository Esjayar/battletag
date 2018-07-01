
--[[--------------------------------------------------------------------------
--
-- File:            UIRadioButton.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 30, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIButton"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIRadioButton(UIButton)

-- defaults

ST_CONTROLED = 2

UIRadioButton.states = {

    [ST_DISABLED] = { texture = "base:texture/ui/components/uiradiobutton_off.tga" },
    [ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uiradiobutton_off.tga" },

    [ST_ENABLED] = { texture = "base:texture/ui/components/uiradiobutton_off.tga" },
    [ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uiradiobutton_on.tga" },
    [ST_ENABLED + ST_CONTROLED] = { texture = "base:texture/ui/components/uiradiobutton_on.tga" },
    [ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/uiradiobutton_off.tga" },
    [ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/uiradiobutton_on.tga" },
    [ST_ENABLED + ST_CONTROLED + ST_CLICKED] = { texture = "base:texture/ui/components/uiradiobutton_on.tga" },

}

UIRadioButton.rectangle = { 0, 0, 24, 24 }
UIRadioButton.text = "UIRadioButton"

-- __ctor -------------------------------------------------------------------

function UIRadioButton:__ctor()


    -- events 
    
    self._Controled = UTEvent:New()

end

-- __dtor -------------------------------------------------------------------

function UIRadioButton:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UIRadioButton:Draw()
	
	if (self.visible) then
	
	    if (self.rectangle) then

            local index = ((self.enabled and ST_ENABLED) or ST_DISABLED) + ((self.controled and ST_CONTROLED) or 0) + ((self.clicked and ST_CLICKED) or 0)
            local state = self.states[index]

            if (not state) then print(index) end
            
            if (state.texture) then

                local color = (state and state.color) or self.color or UIComponent.colors.white
                
	            quartz.system.drawing.loadcolor3f(unpack(color))
	            quartz.system.drawing.loadtexture(self.states[index].texture)
		        quartz.system.drawing.drawtexture(unpack(self.rectangle))

		    end

            if (self.icon) then

                local color = self.color or UIComponent.colors.white

	            quartz.system.drawing.loadcolor3f(unpack(color))
	            quartz.system.drawing.loadtexture(self.icon)
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
	
end

-- OnAction ------------------------------------------------------------------

function UIRadioButton:OnAction()

    self:OnControled()

end


-- OnFocus -------------------------------------------------------------------

function UIRadioButton:OnFocus()
end

--

function UIRadioButton:OnControled()

    if (self.controled) then 
        return
    end
    
    table.foreach(self.parent.components, function (_,component) component.controled = component.controled and false end)
    
    self.controled = true
    
	quartz.framework.audio.loadsound("base:audio/ui/changevalue.wav")
	quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
	quartz.framework.audio.playsound()
	
    self._Controled:Invoke(self)

end
