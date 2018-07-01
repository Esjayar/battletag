
--[[--------------------------------------------------------------------------
--
-- File:            UIArrowLeft.lua
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

UTClass.UIArrowLeft(UIButton)

-- defaults

UIArrowLeft.states = {

    [ST_DISABLED] = { texture = "base:texture/ui/components/uibutton_arrowleft_disabled.tga" },
    [ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_arrowleft_disabled.tga" },

    [ST_ENABLED] = { texture = "base:texture/ui/components/uibutton_arrowleft.tga" },
    [ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_arrowleft_focused.tga" },
    [ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_arrowleft_focused.tga" },
    [ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_arrowleft_entered.tga" },

}

UIArrowLeft.rectangle = { 0, 0, 34, 35}

UIArrowLeft.opaque = true
UIArrowLeft.sensitive = true

-- __ctor -------------------------------------------------------------------

function UIArrowLeft:__ctor()

	self.tip = l"tip110"

end
