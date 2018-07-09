
--[[--------------------------------------------------------------------------
--
-- File:            UIScrollBar.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            Novermber 09, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require	"UI/UIMultiComponent"

	require "UI/UIButton"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIScrollBar(UIMultiComponent)

-- default

UIScrollBar.defaultScrollPerIndex = 24  --default movement of scrollbar per slot

-- __ctor -------------------------------------------------------------------
--location: x,y pair
--height: height of the element
function UIScrollBar:__ctor(location, height)

	self.location = location or { 0, 0 }
	self.height = height or 100
	self.width = 24
	self.arrowHeight = 24
	self.minBarHeight = 48

	-- up button

	self.uiButtonUp = self:AddComponent(UIButton:New(), "uiButtonUp")
    self.uiButtonUp.OnAction = function ()

		if (self.OnActionUp) then 

			quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
			quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
			quartz.framework.audio.playsound()

			--update the scrollbar
			self.currentIndex = math.max(0, self.currentIndex - 1)
			self:SetLift(self.arrowHeight + self.currentIndex * self.scrollPerIndex)			

			if (self.OnActionUp) then self:OnActionUp()
			end

		end

    end

	self.uiButtonUp.states = {

		[ST_DISABLED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowUp_Disabled.tga" },
		[ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowUp_Disabled.tga" },

		[ST_ENABLED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowUp.tga" },
		[ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowUp_Focused.tga" },
		[ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowUp_Focused.tga" },
		[ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowUp__Entered.tga" },

	}

	self.uiButtonUp.rectangle = { self.location[1], self.location[2], self.location[1] + self.width, self.location[2] + self.arrowHeight }
	self.uiButtonUp.opaque = true
	self.uiButtonUp.sensitive = true

	-- down button

	self.uiButtonDown = self:AddComponent(UIButton:New(), "uiButtonDown")
    self.uiButtonDown.OnAction = function ()
		if (self.OnActionDown) then	

			quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
			quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
			quartz.framework.audio.playsound()

			-- lift

			self.currentIndex = math.min(self.maxIndex, self.currentIndex + 1)
			self:SetLift(self.arrowHeight + self.currentIndex * self.scrollPerIndex)			

			if (self.OnActionDown) then self:OnActionDown()
			end

		end
    end

	self.uiButtonDown.states = {

		[ST_DISABLED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowDown_Disabled.tga" },
		[ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowDown_Disabled.tga" },

		[ST_ENABLED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowDown.tga" },
		[ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowDown_Focused.tga" },
		[ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowDown_Focused.tga" },
		[ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/UIButton_ScrollArrowDown_Entered.tga" },

	}

	self.uiButtonDown.rectangle = { self.location[1], self.location[2] + self.height, self.location[1] + self.width, self.location[2] + self.height + self.arrowHeight }
	self.uiButtonDown.opaque = true
	self.uiButtonDown.sensitive = true

	-- lift button

	self.height = self.height - self.arrowHeight
	self.uiButtonLift = self:AddComponent(UIButton:New(), "uiButtonLift")
    self.uiButtonLift.OnAction = function ()

    end

	self.uiButtonLift.states = {

		[ST_DISABLED] = { texture = "base:texture/ui/components/UIButton_ScrollBar.tga" },
		[ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/UIButton_ScrollBar.tga" },
		[ST_ENABLED] = { texture = "base:texture/ui/components/UIButton_ScrollBar.tga" },
		[ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/UIButton_ScrollBar.tga" },
		[ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/UIButton_ScrollBar.tga" },
		[ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/UIButton_ScrollBar_Focused.tga" },

	}
	
	--placeholder values until the index is populated.
	self.refY = nil
	self.scrollPerIndex = self.defaultScrollPerIndex  --set movement of scrollbar per slot
	self.currentIndex = 0
	self.maxIndex = 0
	self.liftSize = 64
	self:SetLift(self.arrowHeight)
	self.uiButtonLift.opaque = true
	self.uiButtonLift.sensitive = true
	self.uiButtonLift.direction = DIR_VERTICAL
	
end

-- __dtor -------------------------------------------------------------------

function UIScrollBar:__dtor()
end

-- Draw ----------------------------------------------------------------------

function UIScrollBar:Draw()

	if (self.visible) then

		-- draw background

        quartz.system.drawing.loadcolor3f(unpack(UIComponent.colors.white))
        quartz.system.drawing.loadtexture("base:texture/ui/components/UIButton_ScrollBg.tga")
        quartz.system.drawing.drawtexture(self.location[1] + 3, self.location[2] + 12, self.location[1] + 3 + 18, self.location[2] + self.height  + 36)

		--quartz.system.drawing.pop()

	end

    -- base

    UIMultiComponent.Draw(self)

end

-- SetLift -------------------------------------------------------------------
--set the position of the lift bar and draw it.
--pos: new position of the lift bar
function UIScrollBar:SetLift(pos)
	self.uiButtonLift.posY = pos
	self.uiButtonLift.rectangle = { 
		self.location[1], 
		self.location[2] + self.uiButtonLift.posY, 
		self.location[1] + self.width, 
		self.location[2] + self.uiButtonLift.posY + self.liftSize 
	}

end

-- SetSize -------------------------------------------------------------------
--as the list is populated, this is called to update the size.
-- number: total number of slots
-- max: number of visible slots
function UIScrollBar:SetSize(number, max)
	--max index of scrolling
	self.maxIndex = math.max(1, number - max)
	
	--calculate the size of the lift button
	self.liftSize = math.max((max / number) * self.height, self.minBarHeight)
	
	--calculate movement of scrollbar per slot (bar movement / index movement)
	--self.scrollPerIndex = self.height * (1/(number - max + 6))
	self.scrollPerIndex = (self.height - self.liftSize) / (self.maxIndex)
	
	
	
	
	self.uiButtonLift.rectangle = { 
		self.location[1], 
		self.location[2] + self.uiButtonLift.posY, 
		self.location[1] + self.width, 
		self.location[2] + self.uiButtonLift.posY + self.liftSize
	}

	if (number <= max) then
		self.visible = false
		self.uiButtonUp.visible = false
		self.uiButtonDown.visible = false
		self.uiButtonLift.visible = false
	else
		self.visible = true
		self.uiButtonUp.visible = true
		self.uiButtonDown.visible = true
		self.uiButtonLift.visible = true
	end

end

-- update --------------------------------------------------------------------

function UIScrollBar:Update()

	--update position of the scrollbar based on mouse
	if (self.uiButtonLift and self.uiButtonLift.clicked) then
		--get the mouse location
		local mouse = UIManager.stack.mouse.cursor
		
		
		if (self.refY) then

			local pos = mouse.y - self.refY
			
			--top scroll limit
			pos = math.max(self.arrowHeight, pos)
				
			--bottom scroll limit
			pos = math.min((self.height + self.arrowHeight) - self.liftSize, pos)

			-- set new pos
			self:SetLift(pos)	

		else
			--get the position of the mouse on the button
			self.refY = mouse.y - self.uiButtonLift.posY
		end
	else
		self.refY = nil
	end
	
	--calculate index position based on scrollbar
	--local index = math.floor((self.uiButtonLift.posY - 24) / (self.scrollPerIndex - 0.5))
	--local index = math.min(self.maxIndex, math.floor( (self.uiButtonLift.posY - self.arrowHeight) / self.scrollPerIndex))
	local index = (self.uiButtonLift.posY - self.arrowHeight) / self.scrollPerIndex
	
	--round the index
	index = math.floor(index + 0.5)
	
	--make sure the index is valid
	index = math.min(self.maxIndex, index)
	
	--update list index position if needed
	if (self.currentIndex < index) then 
		--loop +1 movements until the current index is correct.
		for i = self.currentIndex + 1, index, 1 do
			if (self.OnActionDown) then 
				self:OnActionDown()
			end
		end
		
		--update the current index
		self.currentIndex = index
	elseif (self.currentIndex > index) then 
		--loop -1 movements until the current index is correct.
		for i = self.currentIndex - 1, index, -1 do
			if (self.OnActionUp) then 
				self:OnActionUp()
			end
		end
		
		--update the current index
		self.currentIndex = index
	end

end