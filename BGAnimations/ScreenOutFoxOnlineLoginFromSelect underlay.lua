return Def.Quad {
	InitCommand=function(self) self:zoomto(50,50):diffuse(0,0,0,1) end,
	StartTransitioningCommand=function(self) self:linear(0.4):diffusealpha(0) end
}