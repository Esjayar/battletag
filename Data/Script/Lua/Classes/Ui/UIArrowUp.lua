
--[[--------------------------------------------------------------------------
--
-- File:            UIArrowUp.lua
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

UTClass.UIArrowUp(UIButton)

-- defaults

UIArrowUp.states = {

    [ST_DISABLED] = { texture = "base:texture/ui/components/uibutton_arrowup_disabled.tga" },
    [ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_arrowup_disabled.tga" },

    [ST_ENABLED] = { texture = "base:texture/ui/components/uibutton_arrowup.tga" },
    [ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_arrowup_focused.tga" },
    [ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_arrowup_focused.tga" },
    [ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_arrowup_entered.tga" },

}

UIArrowUp.rectangle = { 0, 0, 35, 34 }

UIArrowUp.opaque = true
UIArrowUp.sensitive = true
