local player = ...
local info

-- in CourseMode, GetStepsCredit() will return a table of info that
-- has as many entries as there are stepcharts in the course
-- (i.e. potentially a lot) so just show course Scripter or Description
if GAMESTATE:IsCourseMode() then
	local course = GAMESTATE:GetCurrentCourse()
	local scripter = course:GetScripter()
	local descript = course:GetDescription()
	-- prefer scripter, use description if scripter is empty
	info = (scripter ~= "" and scripter) or (descript ~= "" and descript) or ""

else
	info = GetStepsCredit(player)
end

local marquee_index = 0

return Def.ActorFrame{
  -- coloured box behind Stepartist text
  Def.Quad{
  	InitCommand=function(self)
			if SL.Global.GameMode == "Casual" then
	 			self:zoomto(131,30)
		 		self:x(51)
			else
				self:zoomto(140.5,30)
				self:x(40.5)
			end
			self:y( _screen.cy-71)
			if player == PLAYER_1 then
				self:x( self:GetX() * -1 )
			end
			--hide this colored box element if there is no credit data to display
			if #info == 0 then
				self:visible(false)
			end
			local currentSteps = GAMESTATE:GetCurrentSteps(player)
			if currentSteps then
				local currentDifficulty = currentSteps:GetDifficulty()
					if ThemePrefs.Get("RainbowMode") then
						self:diffuse(ColorLightTone(DifficultyColor(currentDifficulty)), true )
					else
						self:diffuse(ColorDarkTone(DifficultyColor(currentDifficulty)), true )
					end
			end
  	end,
  },

  LoadFont("Common Normal")..{
 	InitCommand=function(self)
 		self:zoom(0.75)
 		self:y(_screen.cy-71)
		self:horizalign(center)
		if ThemePrefs.Get("RainbowMode") then self:diffuse(Color.Black) end
 		if SL.Global.GameMode == "Casual" then
 			self:x(51)
 			self:maxwidth(155)
 		elseif GAMESTATE:IsCourseMode() then
 			self:x(55.5)
 			self:maxwidth(165)
 		else
 			self:x(40)
 			self:maxwidth(180)
 		end
 	end,
	OnCommand=function(self)
		if player == PLAYER_1 then
			self:x( self:GetX() * -1 )
		end

		if type(info)=="table" and #info > 0 then
			self:playcommand("Marquee")
		elseif type(info)=="string" then
			self:settext(info)
		end
	end,
	MarqueeCommand=function(self)
		-- increment the marquee_index, and keep it in bounds
		marquee_index = (marquee_index % #info) + 1
		-- retrieve the text we want to display
		local text = info[marquee_index]

		-- set this BitmapText actor to display that text
		self:settext( text )
		DiffuseEmojis(self, text)

		-- sleep 2 seconds before queueing the next Marquee command to do this again
		if #info > 1 then
			self:sleep(2):queuecommand("Marquee")
		end
	end,
	OffCommand=function(self) self:stoptweening() end
}
}
