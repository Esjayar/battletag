
--[[--------------------------------------------------------------------------
--
-- File:            UIMoreButton.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            October 6, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UI/UIComponent"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIMoreButton(UIButton)

-- defaults

UIMoreButton.states = {

    [ST_DISABLED] = { texture = "base:texture/ui/components/UIButton_More_disabled.tga" },
    [ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/UIButton_More_disabled.tga" },

    [ST_ENABLED] = { texture = "base:texture/ui/components/UIButton_More_disabled.tga" },
    [ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/UIButton_More_focused.tga" },
    [ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/UIButton_More_focused.tga" },
    [ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/UIButton_More_entered.tga" },

}

UIMoreButton.rectangle = { 0, 0, 30, 30}

UIMoreButton.opaque = true
UIMoreButton.sensitive = true
