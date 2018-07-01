
--[[--------------------------------------------------------------------------
--
-- File:            UTState.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            Mai 26, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UTState"

--[[ Class -----------------------------------------------------------------]]

UTClass.UTStateMachine()

-- __ctor --------------------------------------------------------------------

function UTStateMachine:__ctor(...)

    self.states = {}

    self.current = nil
    self.transition = nil

end

-- __dtor --------------------------------------------------------------------

function UTStateMachine:__dtor()

    if (self.current) then

        local state = self.states[self.current]

        if (state and (state.state == UTState.Update)) then
            state:End(true)
        end

        self.current = nil

    end

end

-- PostStateChange -----------------------------------------------------------

function UTStateMachine:PostStateChange(transition, ...)

    self.transition = { transition, { ... }}

end

-- Restart -------------------------------------------------------------------

function UTStateMachine:Restart(state)

    local __state = self.current and self.states[self.current]
    if (__state) then
        __state:End(true); __state.state = UTState.Ended
    end

    self.current = nil
    self.transition = nil

    if (state and self.states[state]) then

        self:PostStateChange(state)

    elseif (self.default and self.states[self.default]) then

        self:PostStateChange(self.default)

    elseif (self.states[1]) then

        self:PostStateChange(1)

    else

        for index, state in pairs(self.states) do

            self:PostStateChange(index)
            break

        end
    end

end

-- Update --------------------------------------------------------------------

function UTStateMachine:Update()

    -- exit conditions:

    -- 1) current state is null
    -- 2) current state was just begun
    -- 3) current state was updated, current state did not post a state change

    while (true) do

        local state = self.states[self.current]
        if (state) then

            assert(state.state == UTState.Update)

            if (state.transition) then
                self.transition, state.transition = state.transition, nil
            end

            if (self.transition) then

                -- transition, end current state and exit loop

                state:End(); state.state = UTState.Ended
                self.current = nil

            else

                -- standard execution, update state ...

                state:Update()

                -- ... and exit loop unless a transition was called

                if (not state.transition) then
                    break
                end

            end

        else

            if (self.transition) then

                local transition = self.transition
                self.transition, self.transitionArguments = nil, nil
                
                self.current = transition[1]

                state = self.states[self.current]
                if (state) then

                    assert(state.state == UTState.Begin)
                    state:Begin(transition[2]); state.state = UTState.Update

                else

                    -- invalid state
                    self.current = nil

                end

                break

            else

                -- idle state machine, waiting for state change
                break

            end
        end
    end

end