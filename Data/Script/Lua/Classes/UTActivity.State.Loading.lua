
--[[--------------------------------------------------------------------------
--
-- File:            UTActivity.Ui.Loading.lua
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

require "UTActivity.Ui.Loading"

--[[ Class -----------------------------------------------------------------]]

UTActivity.State.Loading = UTClass(UTGame.State.Loading)

-- __ctor --------------------------------------------------------------------

function UTActivity.State.Loading:__ctor ()
end

-- Begin ---------------------------------------------------------------------

function UTActivity.State.Loading:Begin(args)

    print("UTActivity.State.Loading:Begin()", unpack(args))

    self.nextState = args[1]    -- first argument is the next state.
    self.resources = args[2]    -- second argument are the resources to load.
                                -- the table format is { type1 = { path1, path2, ... }, type2 = { path1, path2, ... }, ... }

    self.resourcesTotal = 0
    self.resourcesLoaded = 0

    if (self.resources and type(self.resources) == "table") then

        table.foreach(self.resources, function(t, resourcesByType)

            if (resourcesByType and type(resourcesByType) == "table") then

                table.foreachi(resourcesByType, function(index, resource) self.resourcesTotal = self.resourcesTotal + 1 end )

            end
 
        end ) 
    end

    if (0 < self.resourcesTotal) then

        UIMenuManager.stack:Push(UTActivity.Ui.Loading)
        
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

function UTActivity.State.Loading:End()

    print("UTActivity.State.Loading:End()")
    UIMenuManager.stack:Pop()

end