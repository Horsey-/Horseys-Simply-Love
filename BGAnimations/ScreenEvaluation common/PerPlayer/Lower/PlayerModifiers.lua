if SL.Global.GameMode == "Casual" then return end

local player = ...
local pn = ToEnumShortString(player)

local font_zoom = 0.7
local width = THEME:GetMetric("GraphDisplay", "BodyWidth")

local optionslist = GetPlayerOptionsString(player)
local my_peak = GAMESTATE:Env()[pn.."PeakNPS"]
local streamMeasures, breakMeasures = GetTotalStreamAndBreakMeasures(pn)
local totalMeasures = streamMeasures + breakMeasures
local GraphWidth  = THEME:GetMetric("GraphDisplay", "BodyWidth")

return Def.ActorFrame{
	OnCommand=function(self) self:y(_screen.cy+200.5) end,

	Def.Quad{
		InitCommand=function(self)
			self:diffuse(color("#1E282F")):zoomto(width, 26)
			if #GAMESTATE:GetHumanPlayers()==1 then
				-- not quite an even 0.25 because we need to accomodate the extra 10px
				-- that would normally be between the left and right panes
				self:addx(width*0.2541)
			end
			if ThemePrefs.Get("VisualStyle") == "Technique" then
				self:diffusealpha(0.75)
			end
		end
	},

	LoadFont("Common Normal")..{
		Text=optionslist,
		InitCommand=function(self)
			if #GAMESTATE:GetHumanPlayers()==1 then
				self:addx(GraphWidth * 0.2541)
			else
				self:addx(GraphWidth * 0.2541 / 256):maxwidth(GraphWidth+120)
			end
			self:zoom(font_zoom):align(0.5,0.5):vertspacing(-2):_wrapwidthpixels((width-10) / font_zoom):maxheight(25)
			if not GAMESTATE:IsCourseMode() then self:queuecommand("Animate") end
		end,
		AnimateCommand=function(self)
			if not GAMESTATE:GetCurrentSteps(pn):IsAutogen() then
				self:sleep(2):linear(0.2):diffusealpha(0)
			end
		end,
	},

	-- Breakdown
	LoadFont("Common Normal")..{
		Text="",
		Condition=not GAMESTATE:IsCourseMode() and not GAMESTATE:GetCurrentSteps(player):IsAutogen(),
		InitCommand=function(self)
			if #GAMESTATE:GetHumanPlayers()==1 then
				self:addx(GraphWidth * 0.2541):maxwidth(GraphWidth+250)
			else
				self:addx(GraphWidth * 0.2541 / 256):maxwidth(GraphWidth+120)
			end
			if GenerateBreakdownText(pn, 0) == "No Streams!" then
				self:settext("")
			else
				self:addy(-6):zoom(font_zoom - 0.1)
				self:settext("Breakdown: ".. GenerateBreakdownText(pn, 0))
			end
			self:horizalign(center):diffusealpha(0):sleep(2):linear(0.2):diffusealpha(1)
		end,
	},

	-- Density Info
	LoadFont("Common Normal")..{
		Text="",
		Condition=not GAMESTATE:IsCourseMode() and not GAMESTATE:GetCurrentSteps(player):IsAutogen(),
		InitCommand=function(self)
			if #GAMESTATE:GetHumanPlayers()==1 then
				self:addx(GraphWidth * 0.2541):maxwidth(GraphWidth+250)
			else
				self:addx(GraphWidth * 0.2541 / 256):maxwidth(GraphWidth+120)
			end
			if GenerateBreakdownText(pn, 0) == "No Streams!" then
				self:zoom(font_zoom)
				self:settext(("%s: %g    "):format(THEME:GetString("ScreenGameplay", "PeakNPS"), round(my_peak * SL.Global.ActiveModifiers.MusicRate,2)) .. ("Peak eBPM: %.0f"):format(round(my_peak * 15 * SL.Global.ActiveModifiers.MusicRate,2)))
			else
				self:addy(6):zoom(font_zoom - 0.1)
				self:settext("Total Stream:  ".. string.format("%d/%d (%0.1f%%)", streamMeasures, totalMeasures, streamMeasures/totalMeasures*100) .. ("    %s: %g    "):format(THEME:GetString("ScreenGameplay", "PeakNPS"), round(my_peak * SL.Global.ActiveModifiers.MusicRate,2)) .. ("Peak eBPM: %.0f"):format(round(my_peak * 15 * SL.Global.ActiveModifiers.MusicRate,2)))
			end
			self:horizalign(center):diffusealpha(0):sleep(2):linear(0.2):diffusealpha(1)
		end,
	},

}