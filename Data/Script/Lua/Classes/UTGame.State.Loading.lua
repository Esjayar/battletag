
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.State.Loading.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            Septembre 20, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTGame.Ui.Loading"

--[[ Class -----------------------------------------------------------------]]

UTGame.State.Loading = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTGame.State.Loading:__ctor (game, ...)

    assert(game)

end

-- Begin ---------------------------------------------------------------------

function UTGame.State.Loading:Begin(args)

    print("UTGame.State.Loading:Begin()", unpack(args))

    self.nextState = args[1]    -- first argument is the next state.
    self.resources = args[2]    -- second argument are the resources to load.
                                -- the table format is { type1 = { path1, path2, ... }, type2 = { path1, path2, ... }, ... }

    self.resourcesTotal = 0
    self.resourcesLoaded = 0
    self.currentKey = nil

    if (self.resources and type(self.resources) == "table") then

        table.foreach(self.resources, function (_, resourcesByType)

            if (resourcesByType and type(resourcesByType) == "table") then
                table.foreachi(resourcesByType, function(index, resource) self.resourcesTotal = self.resourcesTotal + 1 end )
            end
 
        end ) 
    end

    if (0 < self.resourcesTotal) then

        UIMenuManager.stack:Push(UTGame.Ui.Loading)

        self.ui = UIMenuManager.stack.top

        self.ui.uiProgress.minimum = 0
        self.ui.uiProgress.maximum = self.resourcesTotal
    else

        self.PostStateChange(self, self.nextState)

    end

    -- backup current time

    self.time = quartz.system.time.gettimemicroseconds()

end

-- End -----------------------------------------------------------------------

function UTGame.State.Loading:End()

    print("UTGame.State.Loading:End()")
    UIMenuManager.stack:Pop()

end

-- Update --------------------------------------------------------------------

function UTGame.State.Loading:Update()

    -- while there are some unloaded resources remaining

    if (self.resourcesLoaded < self.resourcesTotal) then 

        if (self.resources[self.currentKey] and #self.resources[self.currentKey] >= self.currentSubTableIndex) then

            self.currentSubTableIndex = self.currentSubTableIndex + 1

        else

            self.currentSubTableIndex = 1
            self.currentKey = next(self.resources, self.currentKey)

        end

        assert(self.currentKey, "error in loading process (" .. self.resourcesLoaded .. " / " .. self.resourcesTotal .. " resources loaded)")

        local resource = self.resources[self.currentKey][self.currentSubTableIndex]

        if (resource) then --self.resources and type(self.resources) == "table") then

            if (self.currentKey == "video") then quartz.system.drawing.loadvideo(resource) 
            elseif (self.currentKey == "texture") then quartz.system.drawing.loadtexture(resource)
            elseif (self.currentKey == "font") then quartz.system.drawing.loadfont(resource) 
            elseif (self.currentKey == "sound") then quartz.framework.audio.loadsound(resource)
            elseif (self.currentKey == "music") then quartz.framework.audio.loadmusic(resource) end  

            self.resourcesLoaded = self.resourcesLoaded + 1
            self.ui.uiProgress:SetValue(self.resourcesLoaded)

        end    

		self.time = quartz.system.time.gettimemicroseconds()
		
    else

        -- wait a few secconds to let the user read the basics ^_^

        --if (3000000 <= (quartz.system.time.gettimemicroseconds() - self.time)) then
        if (500000 <= (quartz.system.time.gettimemicroseconds() - self.time)) then
            self.PostStateChange(self, self.nextState)
        end

    end

end