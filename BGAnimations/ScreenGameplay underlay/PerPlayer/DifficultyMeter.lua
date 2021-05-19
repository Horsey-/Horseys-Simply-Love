local player = ...

local _x = _screen.cx + (player==PLAYER_1 and -1 or 1) * SL_WideScale(292.5, 342.5)

return Def.ActorFrame{
	InitCommand=function(self)
		self:xy(_x, 56)
	end,

	-- difficulty text ("beginner" or "expert" or etc.)
 	LoadFont("Common Normal")..{
 		InitCommand=function(self)
 			self:y(6)
 			self:horizalign(center):zoom(0.7)
 			self:diffuse(Color.Black)
 			self:maxwidth(52)
			self:draworder(1)

			local currentSteps = GAMESTATE:GetCurrentSteps(player)

 			if currentSteps then
 				local difficulty = currentSteps:GetDifficulty()
 				-- GetDifficulty() returns a value from the Difficulty Enum
 				-- "Difficulty_Hard" for example.
 				-- Strip the characters up to and including the underscore.
 				difficulty = ToEnumShortString(difficulty)
 				self:settext( THEME:GetString("Difficulty", difficulty) )
 			end
 		end
 	},

	-- colored background for player's chart's difficulty meter
	Def.Quad{
		InitCommand=function(self)
			self:zoomto(40, 30)
		end,
		CurrentSongChangedMessageCommand=function(self) self:queuecommand("Begin") end,
		BeginCommand=function(self)
			local currentSteps = GAMESTATE:GetCurrentSteps(player)
			if currentSteps then
				local currentDifficulty = currentSteps:GetDifficulty()
				self:diffuse(DifficultyColor(currentDifficulty))
			end
		end
	},

	-- player's chart's difficulty meter
	LoadFont("Common Bold")..{
		InitCommand=function(self)
			self:diffuse( Color.Black )
			self:zoom( 0.3 )
			self:maxwidth(70)
			self:y(-7)
		end,
		CurrentSongChangedMessageCommand=function(self) self:queuecommand("Begin") end,
		BeginCommand=function(self)
			local steps = GAMESTATE:GetCurrentSteps(player)
			local meter = steps:GetMeter()

			if meter then
				self:settext(meter)
			end
		end
	}
}
