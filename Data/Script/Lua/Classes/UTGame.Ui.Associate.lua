
--[[--------------------------------------------------------------------------
--
-- File:            UTGame.Ui.Associate.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            October 01, 2010
--
------------------------------------------------------------------------------
--
-- Description:     ...
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "Ui/UIPopupLargeWindow"
require "Ui/UIEditBox"

	require "UI/UIProgress"

--[[ Class -----------------------------------------------------------------]]

UTGame.Ui = UTGame.Ui or {}
UTGame.Ui.Associate = UTClass(UIPopupLargeWindow)

-- default

UTGame.Ui.Associate.Avatars = 
{
	[1] = "bear.tga",
	[2] = "bird.tga",
	[3] = "bull.tga",
	[4] = "cat.tga",
	[5] = "dog.tga",
	[6] = "dragon.tga",
	[7] = "eagle.tga",
	[8] = "lion.tga",
	[9] = "panda.tga",
	[10] = "puma.tga",
	[11] = "shark.tga",
	[12] = "snake.tga",
}

-- __ctor -------------------------------------------------------------------

function UTGame.Ui.Associate:__ctor(player, ...)

	self.title = l"oth065"
	self.icon = "base:video/uianimatedbutton_profile.avi"
	self.player = player
	self.iconIndex = 1
	for i = 1, #UTGame.Ui.Associate.Avatars do

		if (UTGame.Ui.Associate.Avatars[i] == self.player.profile.icon) then
			self.iconIndex = i
			break
		end

	end
	
    --  editBox

			self.uiPanel1 = self:AddComponent(UIPanel:New(), "uiPanel1")
			self.uiPanel1.background = "base:texture/ui/Components/UIPanel02.tga"
			self.uiPanel1.rectangle = {
				self.clientRectangle[1] + 20,
				self.clientRectangle[2] + 20,
				self.clientRectangle[3] - 20,
				self.clientRectangle[2] + 20 + 50,
			}        
    
		    self.uiEditBox = self:AddComponent(UIEditBox:New(self.player.profile.name), "editBox")
		    self.uiEditBox:Activate()
		    self.uiEditBox.tip = l"tip061"
			self.uiEditBox:MoveTo(self.clientRectangle[1] + 130, self.clientRectangle[2] + 30)

			if (self.player.rfGunDevice) then

				self.uiHudPicture = self:AddComponent(UIPicture:New(), "uiHudPicture")
				self.uiHudPicture.texture = "base:texture/ui/pictograms/128x/Hud_" .. self.player.rfGunDevice.classId .. ".tga"
				self.uiHudPicture.rectangle = {
					self.clientRectangle[1] + 30,
					self.clientRectangle[2] + 20,
					self.clientRectangle[1] + 30 + 50,
					self.clientRectangle[2] + 20 + 50,
				}  

				self.playerHasDevice = true

			else
				self.playerHasDevice = false
			end

    --  progress bar

			self.uiPanel3 = self:AddComponent(UIPanel:New(), "uiPanel3")
			self.uiPanel3.background = "base:texture/ui/Components/UIPanel02.tga"
			self.uiPanel3.rectangle = {
				self.clientRectangle[1] + 20,
				self.clientRectangle[2] + 270,
				self.clientRectangle[3] - 20,
				self.clientRectangle[2] + 270 + 60,
			}        

			self.uiProgress = self:AddComponent(UIProgress:New(), "uiProgress")
			self.uiProgress.rectangle = {
				self.clientRectangle[1] + 40,
				self.clientRectangle[2] + 290,
				self.clientRectangle[3] - 40,
				self.clientRectangle[2] + 290 + 20,
			}
			self.uiProgress.minimum = 0
			self.uiProgress.maximum = 100
			self.uiProgress.progress = 0

    --  icon

			self.uiPanel2 = self:AddComponent(UIPanel:New(), "uiPanel2")
			self.uiPanel2.background = "base:texture/ui/Components/UIPanel02.tga"
			self.uiPanel2.rectangle = {
				self.clientRectangle[1] + 20,
				self.clientRectangle[2] + 80,
				self.clientRectangle[3] - 20,
				self.clientRectangle[2] + 80 + 180,
			}   

			self.uiPicture = self:AddComponent(UIPicture:New(), "uiPicture")
			self.uiPicture.texture = "base:texture/avatars/256x/" .. UTGame.Ui.Associate.Avatars[self.iconIndex]
			self.uiPicture.rectangle = {
				self.clientRectangle[1] + 110,
				self.clientRectangle[2] + 40,
				self.clientRectangle[1] + 110 + 240,
				self.clientRectangle[2] + 40 + 240,
			}   						
    
			--  uiButtonleft
		    
			self.uiButtonleft = self:AddComponent(UIArrowLeft:New(), "uiButtonleft")
			self.uiButtonleft:MoveTo(self.clientRectangle[1] + 40, self.clientRectangle[2] + 160)
		    self.uiButtonleft.tip = l"tip107"
			self.uiButtonleft.OnAction = function (_self) 
		    
				quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
				quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
				quartz.framework.audio.playsound()
				
				self.iconIndex = self.iconIndex - 1
				
				if (self.iconIndex < 1) then
					self.iconIndex = #UTGame.Ui.Associate.Avatars
				end
				self.uiPicture.texture = "base:texture/avatars/256x/" .. UTGame.Ui.Associate.Avatars[self.iconIndex]

			end
    
			--  uiButtonright

			self.uiButtonright = self:AddComponent(UIArrowRight:New(), "uiButtonright")
			self.uiButtonright:MoveTo(self.clientRectangle[3] - 40 - 32, self.clientRectangle[2] + 160)
		    self.uiButtonright.tip = l"tip107"


			self.uiButtonright.OnAction = function (_self) 
		    
				quartz.framework.audio.loadsound("base:audio/ui/validation.wav")
				quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
				quartz.framework.audio.playsound()
				
				self.iconIndex = self.iconIndex + 1
				
				if (self.iconIndex > #UTGame.Ui.Associate.Avatars) then
					self.iconIndex = 1
				end
				self.uiPicture.texture = "base:texture/avatars/256x/" .. UTGame.Ui.Associate.Avatars[self.iconIndex]

			end   			     

	-- uiButton1: back

		self.uiButton1 = self:AddComponent(UIButton:New(), "uiButton1")
		self.uiButton1.rectangle = self.buttonRectangles[1]
		self.uiButton1.text = l"but004"
		self.uiButton1.tip = l"tip006"

		self.uiButton1.OnAction = function (self) UIManager.stack:Pop() end
	
	-- uiButton2: confirm

		self.uiButton2 = self:AddComponent(UIButton:New(), "uiButton2")
		self.uiButton2.rectangle = self.buttonRectangles[2]
		self.uiButton2.text = l"but005"
		self.uiButton2.tip = l"tip108"
		self.uiButton2.enabled = false

		self.uiButton2.OnAction = function (_self) 

			-- save info

			self.player.profile.name = self.uiEditBox.editText
			self.player.profile.icon = UTGame.Ui.Associate.Avatars[self.iconIndex]

			if (self.player.rfGunDevice) then

				-- disable button

				self.uiButton1.enabled = false
				self.uiButton2.enabled = false

				-- create msg

				self:Initialize()
				self.processFinished = false
				self.message = {0x01, self.player.rfGunDevice.radioProtocolId, 0x86, 0x00}

			else

				-- no device 

				UIManager.stack:Pop()
				
			end

		end

	-- message

	self.message = nil

end

-- Initialize -------------------------------------------------------------------

function UTGame.Ui.Associate:Initialize()

	-- get profile info

	local length = 2 + string.len(self.player.profile.name) + string.len(self.player.profile.icon) - 4

	-- TOC for flash mem : header(4 o) number(1 o) revision (4 o) entry(4 o) offset(2 o) size(2 o)

	self.data = {
		0x50, 0x52, 0x46, 0x4C,  0x01, 0x00, 0x00, 0x00, 0x01, 0x44, 0x41, 0x54, 0x41, 0x10, 0x00, 
		quartz.system.bitwise.bitwiseand(length, 0x00ff), quartz.system.bitwise.bitwiseand(length, 0xff00) / 256
	}

	-- data

	local offset = 18
	self.data[offset] = string.len(self.player.profile.name)
	offset = offset + 1
	for i = 1, string.len(self.player.profile.name) do

		self.data[offset] = string.byte(self.player.profile.name, i)
		offset = offset + 1

	end
	self.data[offset] = string.len(self.player.profile.icon) - 4
	offset = offset + 1
	for i = 1, string.len(self.player.profile.icon) do

		self.data[offset] = string.byte(self.player.profile.icon, i)
		offset = offset + 1

	end

end

-- OnClose -------------------------------------------------------------------

function UTGame.Ui.Associate:OnClose()

	self.uiEditBox:Deactivate()

    if (engine.libraries.usb.proxy) then

		engine.libraries.usb.proxy._DispatchMessage:Remove(self, self.OnDispatchMessage)
		
	end

end

-- OnDispatchMessage --------------------------------------------------------------------

function UTGame.Ui.Associate:OnDispatchMessage(device, addressee, command, arg)

	if (self.player.rfGunDevice == device) then

		if (0x86 == command) then

			-- create erase page message

			if (self.processFinished) then
				self.message = nil
				self.uiProgress.progress = 100
				device.playerProfile = self.player.profile
				UIManager.stack:Pop()
			else
				self.uiProgress.progress = 20
				self.message = {0x04, self.player.rfGunDevice.radioProtocolId, 0x81, 0x00, 0x00, 0x00, 0x00}
			end

		elseif (0x81 == command) then

			-- create write init message

			self.uiProgress.progress = 40
			self.message = {0x06, self.player.rfGunDevice.radioProtocolId, 0x82, 0x00, 0x00, 0x00, 0x00, 0x00, #self.data}

		elseif (0x82 == command) then

			-- create write message

			self.uiProgress.progress = 60
			self.message = {3 + #self.data, self.player.rfGunDevice.radioProtocolId, 0x83, 0x00, 0x00, #self.data, unpack(self.data)}

		elseif (0x83 == command) then

			-- create lock memory message

			self.uiProgress.progress = 80
			self.processFinished = true
			self.message = {0x01, self.player.rfGunDevice.radioProtocolId, 0x86, 0x01}

		end

	end

end

-- OnOpen --------------------------------------------------------------------

function UTGame.Ui.Associate:OnOpen()

	-- father

	UIPopupLargeWindow:OnOpen()

	-- register	to proxy message received

	engine.libraries.usb.proxy._DispatchMessage:Add(self, self.OnDispatchMessage)	

end

-- Update --------------------------------------------------------------------

function UTGame.Ui.Associate:Update()

	local elapsedTime = quartz.system.time.gettimemicroseconds() - (self.timer or quartz.system.time.gettimemicroseconds())
	self.timer = quartz.system.time.gettimemicroseconds()

	if (self.message) then

		self.msgTimer = (self.msgTimer or 0) + elapsedTime
		if (self.msgTimer > 250000) then

			self.msgTimer = 0
			if (self.player.rfGunDevice) then
				quartz.system.usb.sendmessage(engine.libraries.usb.proxy.handle, self.message)
			end

		end

	end

	-- edit box

	self.uiEditBox:Update()
	if (not self.message and self.uiEditBox.editText and self.uiEditBox.editText ~= "") then
		self.uiButton2.enabled = true
	else
		self.uiButton2.enabled = false
	end

	-- check deconnection

	if (self.playerHasDevice and not self.player.rfGunDevice) then

		UIManager.stack:Pop()
		self.uiPopup = UIPopupWindow:New()
        self.uiPopup.title = l"con037"
        self.uiPopup.text = l"con047"

			-- buttons

            self.uiPopup.uiButton2 = self.uiPopup:AddComponent(UIButton:New(), "uiButton2")
            self.uiPopup.uiButton2.rectangle = UIPopupWindow.buttonRectangles[2]
            self.uiPopup.uiButton2.text = l "but019"

            self.uiPopup.uiButton2.OnAction = function ()

                UIManager.stack:Pop()

            end

		UIManager.stack:Push(self.uiPopup)			

	end

end
