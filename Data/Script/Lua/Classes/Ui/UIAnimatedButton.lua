
--[[--------------------------------------------------------------------------
--
-- File:            UIAnimatedButton.lua
--                  Copyright (c) Ubisoft Entertainment. All rights reserved.
--
-- Project:         Ubitoys.Tag
-- Date:            Septembre 14, 2010
--
------------------------------------------------------------------------------
--
-- Description:     button with a video
--
----------------------------------------------------------------------------]]

--[[ Dependencies ----------------------------------------------------------]]

require "UI/UIButton"

--[[ Class -----------------------------------------------------------------]]

UTClass.UIAnimatedButton(UIButton)

-- defaults

UIAnimatedButton.states = {

    [ST_DISABLED] = { texture = "base:texture/ui/components/uibutton_mainmenu.tga" },
    [ST_DISABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_menu.tga" },

    [ST_ENABLED] = { texture = "base:texture/ui/components/uibutton_mainmenu.tga" },
    [ST_ENABLED + ST_FOCUSED] = { texture = "base:texture/ui/components/uibutton_mainmenu_focused.tga" },
    [ST_ENABLED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_mainmenu_focused.tga" },
    [ST_ENABLED + ST_FOCUSED + ST_CLICKED] = { texture = "base:texture/ui/components/uibutton_mainmenu_focused.tga" },

}

UIAnimatedButton.rectangle = { 0, 0, 68, 68 }
UIAnimatedButton.textRectangle = { -50, 78, 118, 92 }
UIAnimatedButton.font = UIComponent.fonts.default
UIAnimatedButton.fontColor = UIComponent.colors.white

-- __ctor -------------------------------------------------------------------

function UIAnimatedButton:__ctor(buttonSize, video, videoSize, videoTexture)

    self.video = video
    self.videoTexture = videoTexture
    self.rectangle = buttonSize and { 0, 0, buttonSize[1], buttonSize[2] } or self.rectangle
    self.videoRectangle = { 0, 0, videoSize[1] or buttonSize[1], videoSize[2] or buttonSize[2] }
    self.videoRectangle[1] = math.ceil((self.rectangle[3] - self.videoRectangle[3]) / 2.0)
    self.videoRectangle[2] = math.ceil((self.rectangle[4] - self.videoRectangle[4]) / 2.0)
    self.videoRectangle[3] = self.videoRectangle[3] + self.videoRectangle[1]
    self.videoRectangle[4] = self.videoRectangle[4] + self.videoRectangle[2]
    
    quartz.system.drawing.loadvideo(self.video)
    quartz.system.drawing.playvideo(true)

end

-- __dtor -------------------------------------------------------------------

function UIAnimatedButton:__dtor()
end

-- OnFocus -------------------------------------------------------------------

function UIAnimatedButton:OnFocus()

    if (self.enabled) then

	    quartz.framework.audio.loadsound("base:audio/ui/rollover.wav")
	    quartz.framework.audio.loadvolume(game.settings.audio["volume:sfx"])
	    quartz.framework.audio.playsound()

	    if (self.firstFocus) then 	
	        self.firstFocus = false    
        end

	    quartz.system.drawing.loadvideo(self.video)
	    quartz.system.drawing.pausevideo()

	    UIComponent.OnFocus(self)

    end

end

-- OnFocusLost ---------------------------------------------------------------

function UIAnimatedButton:OnFocusLost()

    if (self.enabled) then

        quartz.system.drawing.loadvideo(self.video)
	    quartz.system.drawing.playvideo(true)

    end

end

-- Draw ---------------------------------------------------------------------

function UIAnimatedButton:Draw()

	if (self.visible) then

	    if (self.rectangle) then

            local index = ((self.enabled and ST_ENABLED) or ST_DISABLED) + ((self.focused and ST_FOCUSED) or 0) + ((self.clicked and ST_CLICKED) or 0)
            local state = self.states[index]

            if (not state) then print(index) end
            if (state.texture) then

                local color = (state and state.color) or self.color or UIComponent.colors.white

	            quartz.system.drawing.loadcolor3f(unpack(color))
	            quartz.system.drawing.loadtexture(self.states[index].texture)
		        quartz.system.drawing.drawtexture(unpack(self.rectangle))

		    end
		    
		    quartz.system.drawing.pushcontext()
		    quartz.system.drawing.loadtranslation(self.rectangle[1], self.rectangle[2])

		    if (self.video) then

                local color = (state and state.color) or self.color or UIComponent.colors.white

		        quartz.system.drawing.loadcolor3f(unpack(color))
				if (self.videoTexture) then
					quartz.system.drawing.loadtexture(self.videoTexture)
					quartz.system.drawing.drawtexture(unpack(self.videoRectangle))
				end
	            quartz.system.drawing.loadvideo(self.video)
		        quartz.system.drawing.drawvideo(unpack(self.videoRectangle))

		    end

    	    if (self.text) then

    	   	    local font = (state and state.font) or self.font
    	   	    local fontColor = (state and state.fontColor) or self.fontColor
    	   	    local fontJustification = (state and state.fontJustification) or self.fontJustification

                quartz.system.drawing.loadcolor3f(unpack(fontColor))
    	        quartz.system.drawing.loadfont(font)
                quartz.system.drawing.drawtextjustified(self.text, fontJustification, unpack(self.textRectangle)) 

            end

            quartz.system.drawing.pop()

        end
	end
	
end

-- StopVideo ----------------------------------------------------------------

function UIAnimatedButton:StopVideo()

    if (self.video) then

        quartz.system.drawing.loadvideo(self.video)
        quartz.system.drawing.stopvideo()

    end

end