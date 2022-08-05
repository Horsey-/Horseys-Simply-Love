local static_alpha = 1
local faction = SL.SRPG6.GetFactionName(SL.Global.ActiveColorIndex)

local StaticBackgroundVideos = {
	["Unaffiliated"] = THEME:GetPathG("", "_VisualStyles/SRPG6/Fog.mp4"),
	["Democratic People's Republic of Timing"] = THEME:GetPathG("", "_VisualStyles/SRPG6/Ranni.mp4"),
	["Footspeed Empire"] = THEME:GetPathG("", "_VisualStyles/SRPG6/Malenia.mp4"),
	["Stamina Nation"] = THEME:GetPathG("", "_VisualStyles/SRPG6/Melina.mp4"),
}

return Def.Sprite{
	Name="Video",
	Texture=StaticBackgroundVideos[faction],
	InitCommand=function(self)
		self:rotationx(0):blend("BlendMode_Normal"):diffusealpha(static_alpha):diffuse(GetCurrentColor(true))
	end
}