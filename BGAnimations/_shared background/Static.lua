-- --------------------------------------------------------
-- static background image

local file = ...

-- We want the Shared BG to be used on the following screens.
local SharedBackground = {
	["ScreenInit"] = true,
	["ScreenLogo"] = true,
	["ScreenTitleMenu"] = true,
	["ScreenTitleJoin"] = true,
	["ScreenSelectProfile"] = true,
	["ScreenAfterSelectProfile"] = true, -- hidden screen
	["ScreenSelectColor"] = true,
	["ScreenSelectStyle"] = true,
	["ScreenSelectPlayMode"] = true,
	["ScreenSelectPlayMode2"] = true,
	["ScreenProfileLoad"] = true, -- hidden screen

	-- Operator Menu screens and sub screens.
	["ScreenOptionsService"] = true,
	["ScreenSystemOptions"] = true,
	["ScreenMapControllers"] = true,
	["ScreenTestInput"] = true,
	["ScreenInputOptions"] = true,
	["ScreenGraphicsSoundOptions"] = true,
	["ScreenVisualOptions"] = true,
	["ScreenAppearanceOptions"] = true,
	["ScreenSetBGFit"] = true,
	["ScreenOverscanConfig"] = true,
	["ScreenArcadeOptions"] = true,
	["ScreenAdvancedOptions"] = true,
	["ScreenMenuTimerOptions"] = true,
	["ScreenUSBProfileOptions"] = true,
	["ScreenOptionsManageProfiles"] = true,
	["ScreenThemeOptions"] = true,
}

local shared_alpha = 0.6
local static_alpha = 1

local af = Def.ActorFrame {
	InitCommand=function(self)
		self:diffusealpha(0)
		local style = ThemePrefs.Get("VisualStyle")
		self:visible(style == "SRPG6")
		self.IsShared = true
	end,
	OnCommand=function(self)
		self:accelerate(0.8):diffusealpha(1)
	end,
	ScreenChangedMessageCommand=function(self)
		local screen = SCREENMAN:GetTopScreen()
		local style = ThemePrefs.Get("VisualStyle")
		if screen and style == "SRPG6" then
			local static = self:GetChild("Static")
			local video = self:GetChild("Video")
			if SharedBackground[screen:GetName()] and not self.IsShared then
				self:RemoveChild("Video")
				static:visible(true)
				self:AddChildFromPath( THEME:GetPathB("_shared","background/FogVideo.lua" ) )
				-- video:Load(THEME:GetPathG("", "_VisualStyles/SRPG6/Fog.mp4"))
				-- video:rotationx(180):blend("BlendMode_Add"):diffusealpha(shared_alpha):diffuse(color("#ffffff"))
				self.IsShared = true
			end
			if not SharedBackground[screen:GetName()] and self.IsShared then
				-- No need to change anything for Unaffiliated.
				-- We want to keep using the SharedBackground.
				static:visible(false)
				if faction ~= "Unaffiliated" then
					self:RemoveChild("Video")
					-- Load the new faction video to memory.
					self:AddChildFromPath( THEME:GetPathB("_shared","background/FactionVideo.lua" ) )
					self.IsShared = false
				end
			end
		end
	end,
	VisualStyleSelectedMessageCommand=function(self)
		local style = ThemePrefs.Get("VisualStyle")
		if style ~= "SRPG6" then
			-- Clean up the actorframe's video children from memory.
			self:RemoveChild("Video")
		else
			self:AddChildFromPath( THEME:GetPathB("_shared","background/FogVideo.lua" ) )
		end
	end,
	Def.Sprite {
		Name="Static",
		Texture=THEME:GetPathG("", "_VisualStyles/SRPG6/SharedBackground.png"),
		InitCommand=function(self)
			self:xy(_screen.cx, _screen.cy):zoomto(_screen.w, _screen.h):diffusealpha(shared_alpha)
		end,
	},
	Def.Sprite {
		Name="Video",
		Texture=THEME:GetPathG("", "_VisualStyles/SRPG6/Fog.mp4"),
		InitCommand= function(self)
			self:xy(_screen.cx, _screen.cy):zoomto(_screen.w, _screen.h):rotationx(180):blend("BlendMode_Add"):diffusealpha(shared_alpha)
		end,
	},
}

return af
