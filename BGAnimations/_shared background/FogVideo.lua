local shared_alpha = 0.6
return Def.Sprite{
	Name="Video",
	Texture=THEME:GetPathG("", "_VisualStyles/SRPG6/Fog.mp4"),
	InitCommand=function(self)
		self:rotationx(180):blend("BlendMode_Add"):diffusealpha(shared_alpha)
	end
}