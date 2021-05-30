local player = ...
local pn = PlayerNumber:Reverse()[player]

return Def.ActorFrame{
	-- colored square as the background for the difficulty meter
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(40,30)
			self:y( _screen.cy-71 )
			self:x(130 * (player==PLAYER_1 and -1 or 1))

			local currentSteps = GAMESTATE:GetCurrentSteps(player)
			if currentSteps then
				local currentDifficulty = currentSteps:GetDifficulty()
				self:diffuse( DifficultyColor(currentDifficulty), true )
			end
		end
	},

	-- difficulty text ("beginner" or "expert" or etc.)
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:y(_screen.cy-64)
			self:halign(pn):zoom(0.7)

			if player==PLAYER_1 then
 				if SL.Global.GameMode == "Casual" then self:x(-130.5) else self:x(-130) end
 			elseif player==PLAYER_2 then
 				if SL.Global.GameMode == "Casual" then self:x(129.5) else self:x(130) end
 			end
 			self:horizalign(center):zoom(0.7)
 			self:diffuse(Color.Black)
 			self:maxwidth(52)

			local style = GAMESTATE:GetCurrentStyle():GetName()
			if style == "versus" then style = "single" end
			style =  THEME:GetString("ScreenSelectMusic", style:gsub("^%l", string.upper))

			local steps = GAMESTATE:GetCurrentSteps(player)
			-- GetDifficulty() returns a value from the Difficulty Enum such as "Difficulty_Hard"
			-- ToEnumShortString() removes the characters up to and including the
			-- underscore, transforming a string like "Difficulty_Hard" into "Hard"
			local difficulty = ToEnumShortString( steps:GetDifficulty() )
			difficulty = THEME:GetString("Difficulty", difficulty)

			--there is no reason to print the style because it is shown graphically in the top right of the screen
			self:settext( difficulty )
		end
	},

	-- numerical difficulty meter
	LoadFont("Common Bold")..{
		InitCommand=function(self)
			self:diffuse(Color.Black):zoom( 0.3 )
  			self:y( _screen.cy-78 )
 			if SL.Global.GameMode == "Casual" then
 				self:x(130 * (player==PLAYER_1 and -1 or 1))
 			else
 				self:x(130 * (player==PLAYER_1 and -1 or 1))
 			end
			self:maxwidth(70)

			local meter
			if GAMESTATE:IsCourseMode() then
				local trail = GAMESTATE:GetCurrentTrail(player)
				if trail then meter = trail:GetMeter() end
			else
				local steps = GAMESTATE:GetCurrentSteps(player)
				if steps then meter = steps:GetMeter() end
			end

			if meter then self:settext(meter) end
		end
	}
}
