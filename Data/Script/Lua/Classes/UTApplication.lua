
--[[--------------------------------------------------------------------------
--
-- File:            utApplication.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            Mai 25, 2010
--
------------------------------------------------------------------------------
--
-- Description:     Entry point to our framework application.
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTGame"

--[[ Class -----------------------------------------------------------------]]

-- application is defined within the framework,
-- global game instance

game = nil

-- global activity instance

activity = nil

-- keydown -----------------------------------------------------------

function application.char(char)

     game:Char(char)

end

-- keyspecialdown -----------------------------------------------------------

function application.keydown(virtualKeyCode, scanCode)

     game:KeyDown(virtualKeyCode, scanCode)

end

-- mousebuttondown -----------------------------------------------------------

function application.mousebuttondown(button, control, x, y)

    game:MouseButtonDown(button, control, x, y)

end

-- mousebuttonup -------------------------------------------------------------

function application.mousebuttonup(button, control, x, y)

    game:MouseButtonUp(button, control, x, y)

end

-- mousemove -----------------------------------------------------------------

function application.mousemove(control, x, y)

    game:MouseMove(control, x, y)

end

-- pause ---------------------------------------------------------------------

function application.pause(paused)

    game:Pause(paused)

end

-- render --------------------------------------------------------------------

function application.render()

    game:Render()

end

-- start ---------------------------------------------------------------------

function application.start()

    assert(not game); game = UTGame:New()

end

-- shutdown ------------------------------------------------------------------

function application.shutdown()

    game = game:Delete()

end

-- update --------------------------------------------------------------------

function application.update()

    game:Update()

end
