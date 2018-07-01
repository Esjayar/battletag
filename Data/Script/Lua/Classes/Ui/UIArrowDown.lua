
--[[--------------------------------------------------------------------------
--
-- File:            UIArrowDown.lua
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

UTClass.UIArrowDown(UIButton)

-- defaults

UIArrowDown.states = {

    [ST_DISABLED] = { texture = "base:texture/ui/components/uibutton_arrowdown_disabled.tga" },
    [ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_arrowdown_disabled.tga" },

    [ST_ENABLED] = { texture = "base:texture/ui/components/uibutton_arrowdown.tga" },
    [ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_arrowdown_focused.tga" },
    [ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_arrowdown_focused.tga" },
    [ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_arrowdown_entered.tga" },

}

UIArrowDown.rectangle = { 0, 0, 35, 34 }

UIArrowDown.opaque = true
UIArrowDown.sensitive = true
