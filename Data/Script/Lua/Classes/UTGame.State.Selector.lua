
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.State.Selector.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 27, 2010
--
------------------------------------------------------------------------------
--
-- Description:     Instanciates a new activity.
--                  Either launch the process upon success, or raise an error otherwise.
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTGame.Ui.Selector"

--[[ Class -----------------------------------------------------------------]]

UTGame.State.Selector = UTClass(UTState)

-- __ctor --------------------------------------------------------------------

function UTGame.State.Selector:__ctor (game, ...)

    assert(game)

end

-- Begin ---------------------------------------------------------------------

function UTGame.State.Selector:Begin()

    print("UTGame.State.Selector:Begin()")

    -- list all available activities,
    -- from all registered packages directories

    game.nfos = nil

    local packages = {}

    self:Merge(packages, "game:../packages")
    self:Merge(packages, REG_USERAPPFOLDER .. "/packages")

    if (0 < #packages) then

        game.nfos = {}

        for i, path in ipairs(packages) do

            local directory, nfo = self:LookupNfo(path)
            if (nfo) then

                nfo.__directory = directory
                nfo.__path = path

                table.insert(game.nfos, nfo)

                if (not nfo.difficulty) then nfo.difficulty = 40
                end

                --[[
                for i = 1,10 do
                    local nfo = { color = UIComponent.colors.green, pictogram = "empty.tga", name = "test"..i }
                    table.insert(game.nfos, nfo)
                end --]]

            end

        end

    else

        -- !! PUSH ERROR MESSAGE, CANNOT LOCATE ACTIVITIES,
        -- !! BACK TO TITLE

    end

    UIMenuManager.stack:Push(UTGame.Ui.Selector)

end

-- End -----------------------------------------------------------------------

function UTGame.State.Selector:End()

    print("UTGame.State.Selector:End()")
    UIMenuManager.stack:Pop()

end


-- LookupNfo -----------------------------------------------------------------

function UTGame.State.Selector:LookupNfo(path)

    local directory = string.lower(path)

    local offset = string.find(directory, '/', 1, true)
    while (offset) do
        directory = string.sub(directory, offset + 1)
        offset = string.find(directory, '/', 1, true)
    end

    -- lookup for activity descriptor

    local nfoFile = path .. "/system/locale/" .. (game.locale.locale or "en") .. "/" .. directory .. ".nfo"
    local chunk, message = loadfile(nfoFile)

    if (chunk) then

        local result, nfo = pcall(chunk)
        if (result) then

            return directory, nfo

        else

            print("[UTGame.State.Selector] LookupNfo : failed, " .. nfo)

        end

    elseif (message) then

        print("[UTGame.State.Selector] LUA_ERRRUN : runtime error.\r\n" .. message)

    else

        print("[UTGame.State.Selector] LookupNfo : file not found,")
        print("path = " .. nfoFile)

    end

end

-- Merge ---------------------------------------------------------------------

function UTGame.State.Selector:Merge(packages, path)

    local files = quartz.system.filesystem.directory(path , "*")
    if (files) then

        for _, file in pairs(files) do table.insert(packages, file)
        end

    end

end
