
--[[--------------------------------------------------------------------------
--
-- File:            UIStack.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            July 7, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

--[[ Class -----------------------------------------------------------------]]

UTClass.UIStack()

-- defaults

-- __ctor --------------------------------------------------------------------

function UIStack:__ctor(...)

    -- focused element

    self.focused = nil

    -- list of pages in the lifo stack,
    -- last element in table is also the topmost one

    self.pages = {}
    self.anchors = {}

    -- shortcut to topmost element,
    -- the one inserted last in the lifo stack

    self.top = nil
    
    -- mouse cursor
    
    self.mouse = {
    
        buttons = {},
        cursor = {},
        focused = nil, -- focused component, while left button down

    }

end

-- __dtor --------------------------------------------------------------------

function UIStack:__dtor()
end

-- Clear ---------------------------------------------------------------------

function UIStack:Clear()

    self:Flush()

end

-- Draw ----------------------------------------------------------------------

function UIStack:Draw()

    table.foreachi(self.pages, function (_, page) if (page.visible) then page:Draw() end end)

end

-- Flush ---------------------------------------------------------------------

function UIStack:Flush()

    -- remove all pages from the lifo stack
    
    while (self.top) do

        local top = table.remove(self.pages)
        assert(top == self.top)

        self.top:Close()
        self.top = (0 < #self.pages) and self.pages[#self.pages] or nil

    end

    self.pages = {}

end

-- Invoke --------------------------------------------------------------------

function UIStack:Invoke(action)

    -- invoke (forward) given action on top page,
    -- action should be of type 'string'

    if (self.top) then
        self.top:Invoke(action)
    end

end

-- MouseButtonDown -----------------------------------------------------------

function UIStack:MouseButtonDown(button, control, x, y)

    self.mouse.buttons[button] = true

    if (button == application.mousebutton.left) then

        self.mouse.focused = self:Pick()
        if (self.mouse.focused and self.mouse.focused.enabled) then

            self.mouse.focused.clicked = true

        end
    end

end

-- MouseButtonUp -------------------------------------------------------------

function UIStack:MouseButtonUp(button, control, x, y)

    self.mouse.buttons[button] = false

    if ((button == application.mousebutton.left) and self.mouse.focused) then

        local focused = self:Pick()
        if (focused == self.mouse.focused) then

            if (focused.clicked and focused.OnAction) then -- ie. focused.enabled
                focused:OnAction()
            end

        elseif (focused) then

            self.focused = focused
            self.focused:Focus(true)

        end

        self.mouse.focused.clicked = false
        self.mouse.focused = nil

    end

end

-- MouseMove -----------------------------------------------------------------

function UIStack:MouseMove(control, x, y)

    self.mouse.cursor = { x = x, y = y, control = control }

    local focused = self:Pick()

    if (focused) then

        if (focused ~= self.focused) then

            if (self.focused) then
                self.focused:Focus(false)
            end            

            self.focused = focused
            
            if ((not self.mouse.focused) or (self.mouse.focused == focused)) then
                self.focused:Focus(true)
            end
            
        end

    elseif (self.focused) then

        self.focused:Focus(false)
        self.focused = nil
    
    end

end

function UIStack:Pick()

    self.regions = {}

    if (0 < #self.pages) then

        -- front to back traversal

		for index = #self.pages, 1, -1 do

			local page, regions = self.pages[index], {}
			local opaque = page.sensitive and page:RegisterPickRegions(regions, 0, 0)
			
			table.insert(self.regions, 1, regions)

			if (opaque) then break -- break traversal
			end

		end

        -- browse through regions

        local focused = nil
        local x, y = self.mouse.cursor.x or -1, self.mouse.cursor.y or -1

        for _, regions in ipairs(self.regions) do
            for _, region in ipairs(regions) do

                assert(region.rectangle)

                local rectangle = region.rectangle
                if ((rectangle[1] <= x) and (rectangle[2] <= y) and (rectangle[3] >= x) and (rectangle[4] >= y)) then
                    focused = region.component
                end

            end
        end

        return focused

    end

end

-- Pop -----------------------------------------------------------------------

function UIStack:Pop(count)

    UIManager.tip = nil

    -- remove 'count' pages from the lifo stack

    local count = (type(count) == "number") and count or 1

	if (-1 >= count) then

		local index = #self.pages + count	
		if (index > 0) then

			local page = table.remove(self.pages, index)
			page:Close()

		end

	else

		while (self.top and (0 < count)) do

			count = count - 1

			local top = table.remove(self.pages)
			assert(top == self.top)

			self.top:Close()
			self.top = (0 < #self.pages) and self.pages[#self.pages] or nil

		end

		if (self.top) then
			self.top:Open()
		end

	end

end

-- Popa ----------------------------------------------------------------------

function UIStack:Popa()

    if (0 < #self.anchors) then

        local anchor = table.remove(self.anchors)
        print("UIStack:Pop", #self.pages - anchor)

        self:Pop(#self.pages - anchor)

    end

end

-- Push ----------------------------------------------------------------------

function UIStack:Push(page)

    UIManager.tip = nil

    if (page) then

        -- check whether the input page is a string

        if (type(page) == "string") then

            local class = rawget(_G, page)
            assert(class, "[UIStack] Push(string): cannot allocate new page component from class '" .. page .. "'");

            page = class and class:New()
            if (page) then

                table.insert(self.pages, page)

                if (self.top) then
                    self.top:Focus(false)
                    --self.top:Close()
                end

                self.top = page
                self.top:Open()

            end

        elseif (type(page) == "table") then

            if (page.__type == "instance") then

                assert(page:IsKindOf(UIPage), "[UIStack] Push(instance): cannot push an instance that is not of type 'UIPage'");

            else

                local class = (page.__type == "class") and page
                assert(class, "[UIStack] Push(table): cannot allocate new page component from table '" .. tostring(page) .. "'");

                page = class and class:New()

            end

            if (page) then

                table.insert(self.pages, page)

                if (self.top) then
                    --self.top:Close()
                    self.top:Focus(false)
                    self.top.visible = page.transparent
                end

                self.top = page
                self.top:Open()

            end

        else

            error("[UIStack] Push(page): page argument must be of type 'string'")

        end
    end

    return self.top

end

-- Pusha ---------------------------------------------------------------------

function UIStack:Pusha()

    table.insert(self.anchors, #self.pages)

end

-- Replace -------------------------------------------------------------------

function UIStack:Replace(page, count)

    local count = (type(count) == "count") and count or 1

    while (self.top and (0 < count)) do

        count = count - 1

        local top = table.remove(self.pages)
        assert(top == self.top)

        self.top:Close()
        self.top = (0 < #self.pages) and self.pages[#self.pages] or nil

    end

    self:Push(page)

end

-- Reset ---------------------------------------------------------------------

function UIStack:Reset(page)

    self:Replace(page, #self.pages)

end

-- Update --------------------------------------------------------------------

function UIStack:Update()

    if (self.top) then
        self.top:Update()
    end

end
