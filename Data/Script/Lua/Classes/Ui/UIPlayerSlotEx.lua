
--[[--------------------------------------------------------------------------
--
-- File:            UIPlayerSlotEx.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            September 10, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[Dependencies ----------------------------------------------------------]]

require "Ui/UIPlayerSlot"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIPlayerSlotEx(UIPlayerSlot)

-- default

UIPlayerSlotEx.rectangle = { 0, 0, 190, 20 }

--UIPlayerSlot.states = {
--
    --[ST_DISABLED] = { background = "base:texture/ui/components/uiplayerslot_background_disabled.tga" },
    --[ST_DISABLED + ST_FOCUSED] = { background = "base:texture/ui/components/uiplayerslot_background_disabled.tga" },
--
    --[ST_ENABLED] = { background = "base:texture/ui/components/uiplayerslot_background.tga", fontColor = UIComponent.colors.gray },
    --[ST_ENABLED + ST_FOCUSED] = { background = "base:texture/ui/components/uiplayerslot_background.tga", fontColor = UIComponent.colors.gray },
    --[ST_ENABLED + ST_CLICKED] = { background = "base:texture/ui/components/uiplayerslot_background.tga", fontColor = UIComponent.colors.gray },
    --[ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { background = "base:texture/ui/components/uiplayerslot_background_entered.tga", fontColor = UIComponent.colors.white },
--
--}

UIPlayerSlotEx.tickBox = {

    tickedTexture = "base:texture/ui/icons/32x/tickbox_ticked.tga",
    untickedTexture = "base:texture/ui/icons/32x/tickbox_unticked.tga",

}

UIPlayerSlotEx.tickBoxRectangle = { 170, 10 - 16, 170 + 32, 10 + 16 }


-- __ctor -------------------------------------------------------------------

function UIPlayerSlotEx:__ctor(player)

    self.player = player
    self.tick = true

end

-- __dtor -------------------------------------------------------------------

function UIPlayerSlotEx:__dtor()
end

-- Draw ---------------------------------------------------------------------

function UIPlayerSlotEx:Draw()

    UIPlayerSlot.Draw(self)
    
    if (self.visible) then
	
	    if (self.rectangle) then
            
		    if (self.player) then
		    
		        quartz.system.drawing.pushcontext()
		        quartz.system.drawing.loadtranslation(self.rectangle[1], self.rectangle[2])
    		    
		        -- 
    		    
    	        if (self.tickBox.tickedTexture and self.tickBox.untickedTexture) then

                    local color = UIComponent.colors.white

                    quartz.system.drawing.loadcolor3f(unpack(color))
                    quartz.system.drawing.loadtexture(self.tick and self.tickBox.tickedTexture or self.tickBox.untickedTexture)
                    quartz.system.drawing.drawtexture(unpack(self.tickBoxRectangle))

                end
                
                                
                quartz.system.drawing.pop()
                
            end            
        end
	end

end