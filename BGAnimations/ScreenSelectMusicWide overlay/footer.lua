if not GAMESTATE:GetNumPlayersEnabled() == 2 then return end

-- tables of rgba values
local dark  = {0,0,0,1}
local light = {0.65,0.65,0.65,1}

return Def.Quad{
	Name="SSMWFooter",
	InitCommand=function(self)
		self:draworder(90):zoomto(_screen.cx/1.335, 32):vertalign(bottom):xy(_screen.cx,SCREEN_BOTTOM)
		if ThemePrefs.Get("VisualStyle") == "SRPG6" then
			self:diffuse(GetCurrentColor(true))
		elseif DarkUI() then
			self:diffuse(dark)
		else
			self:diffuse(light)
		end
	end,
}
