
--[[--------------------------------------------------------------------------
--
-- File:            UIArrowRight.lua
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

UTClass.UIArrowRight(UIButton)

-- defaults

UIArrowRight.states = {

    [ST_DISABLED] = { texture = "base:texture/ui/components/uibutton_arrowright_disabled.tga" },
    [ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_arrowright_disabled.tga" },

    [ST_ENABLED] = { texture = "base:texture/ui/components/uibutton_arrowright.tga" },
    [ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_arrowright_focused.tga" },
    [ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_arrowright_focused.tga" },
    [ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_arrowright_entered.tga" },

}

UIArrowRight.rectangle = { 0, 0, 34, 35}

UIArrowRight.opaque = true
UIArrowRight.sensitive = true

-- __ctor -------------------------------------------------------------------

function UIArrowRight:__ctor()

	self.tip = l"tip111"

end