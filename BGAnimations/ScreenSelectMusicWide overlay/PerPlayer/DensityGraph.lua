-- Currently the Density Graph in SSM doesn't work for Courses.
-- Disable the functionality.
if GAMESTATE:IsCourseMode() then return end

local player = ...
local pn = ToEnumShortString(player)

-- Height and width of the density graph.
local height = 64
local width = 267

local af = Def.ActorFrame{
	InitCommand=function(self)
		self:visible( GAMESTATE:IsHumanPlayer(player) )
		self:xy(_screen.cx-293.5, _screen.cy+56)

		if player == PLAYER_2 then
			self:x(_screen.cx+293.5)
		end
	end,
	PlayerJoinedMessageCommand=function(self, params)
		if params.Player == player then
			self:visible(true)
		end
	end,
	PlayerUnjoinedMessageCommand=function(self, params)
		if params.Player == player then
			self:visible(false)
		end
	end,
}

-- Background quad for the density graph
af[#af+1] = Def.Quad{
	InitCommand=function(self)
		self:diffuse(color("#1e282f")):zoomto(width, height)
		if ThemePrefs.Get("RainbowMode") then
			self:diffusealpha(0.9)
		end
	end
}

af[#af+1] = Def.ActorFrame{
	Name="ChartParser",
	-- Hide when scrolling through the wheel. This also handles the case of
	-- going from song -> folder. It will get unhidden after a chart is parsed
	-- below.
	CurrentSongChangedMessageCommand=function(self)
		self:queuecommand("Hide")
	end,
	["CurrentSteps"..pn.."ChangedMessageCommand"]=function(self)
		self:queuecommand("Hide")
		self:stoptweening()
		self:sleep(0.4)
		self:queuecommand("ParseChart")
	end,
	ParseChartCommand=function(self)
		local steps = GAMESTATE:GetCurrentSteps(player)
		if steps then
			MESSAGEMAN:Broadcast(pn.."ChartParsing")
			ParseChartInfo(steps, pn)
			self:queuecommand("Show")
		end
	end,
	ShowCommand=function(self)
		if GAMESTATE:GetCurrentSong() and
				GAMESTATE:GetCurrentSteps(player) then
			MESSAGEMAN:Broadcast(pn.."ChartParsed")
			self:queuecommand("Redraw")
		else
			self:queuecommand("Hide")
		end
	end
}

local af2 = af[#af]

-- The Density Graph itself. It already has a "RedrawCommand".
af2[#af2+1] = NPS_Histogram(player, width, height)..{
	Name="DensityGraph",
	OnCommand=function(self)
		self:addx(-width/2):addy(height/2)
	end,
	HideCommand=function(self)
		self:visible(false)
	end,
	RedrawCommand=function(self)
		self:visible(true)
	end
}
-- Don't let the density graph parse the chart.
-- We do this in parent actorframe because we want to "stall" before we parse.
af2[#af2]["CurrentSteps"..pn.."ChangedMessageCommand"] = nil

-- Breakdown
af2[#af2+1] = Def.ActorFrame{
	Name="Breakdown",
	InitCommand=function(self)
		local actorHeight = 17
		self:addy(height/2 - actorHeight/2 + 22)
	end,

	Def.Quad{
		InitCommand=function(self)
			local bgHeight = 27
			self:diffuse(color("#000000")):zoomto(width, bgHeight):diffusealpha(0.5)
		end
	},

	LoadFont("Common Normal")..{
		Text="",
		Name="BreakdownText",
		InitCommand=function(self)
			local textHeight = 17
			local textZoom = 0.65
			self:maxwidth(width/textZoom):zoom(textZoom)
			self:addy(-6)
		end,
		HideCommand=function(self)
			self:settext("")
		end,

		RedrawCommand=function(self)
			local textZoom = 0.7
			self:settext("Breakdown: " .. GenerateBreakdownText(pn, 0))
			local minimization_level = 1
			while self:GetWidth() > (width/textZoom) and minimization_level < 4 do
				self:settext("Breakdown: " .. GenerateBreakdownText(pn, minimization_level))
				minimization_level = minimization_level + 1
			end
		end,
	}
}

af2[#af2+1] = Def.ActorFrame{
	Name="PatternInfo",
	InitCommand=function(self)
		self:addy(90)
	end,
}

local af3 = af2[#af2]

local layout = {
	{"Crossovers"},
 	{"Sideswitches"},
 	{"Footswitches"},
 	{"Jacks"},
 	{"Brackets"}
}

af3[#af3+1] = LoadFont("Common normal")..{
	Text="",
	Name="Total Stream",
	InitCommand=function(self)
		local textHeight = 17
		local textZoom = 0.65
		self:zoom(textZoom):horizalign(center)
		self:maxwidth(width/textZoom)
		self:y(-height/2 - 6)
		-- self:diffuse(Color.Black)
	end,
	HideCommand=function(self)
		self:settext("")
	end,
	RedrawCommand=function(self)
		local streamMeasures, breakMeasures = GetTotalStreamAndBreakMeasures(pn)
		local totalMeasures = streamMeasures + breakMeasures
		if streamMeasures == 0 then
			self:settext(("   Peak NPS: %.1f   "):format(SL[pn].Streams.PeakNPS * SL.Global.ActiveModifiers.MusicRate))
		else
			self:settext("Total Stream: " .. string.format("%d/%d (%0.1f%%)", streamMeasures, totalMeasures, streamMeasures/totalMeasures*100) .. ("   Peak NPS: %.1f   "):format(SL[pn].Streams.PeakNPS * SL.Global.ActiveModifiers.MusicRate))
		end
	end
}

local colSpacing = 150
local rowSpacing = 15
--value

for i, row in ipairs(layout) do
	for j, col in pairs(row) do
		af3[#af3+1] = LoadFont("Common normal")..{
			Text=col ~= "Total Stream" and "0" or "None (0.0%)",
			Name=col .. "Value",
			InitCommand=function(self)
				local textHeight = 17
				local textZoom = 0.7
				self:zoom(textZoom):horizalign(right)
				if col == "Total Stream" then
					self:maxwidth(300)
				end
				self:xy(-width/2 + 105, -height/2 + 10)
				self:addx((j-1)*colSpacing)
				self:addy((i-1)*rowSpacing)
				self:diffuse(Color.Black)
			end,
			HideCommand=function(self)
				if col ~= "Total Stream" then
					self:settext("0")
				else
					self:settext("None (0.0%)")
				end
			end,
			RedrawCommand=function(self)
				if col ~= "Total Stream" then
					self:settext(SL[pn].Streams[col])
				else
					local streamMeasures, breakMeasures = GetTotalStreamAndBreakMeasures(pn)
					local totalMeasures = streamMeasures + breakMeasures
					if streamMeasures == 0 then
						self:settext("None (0.0%)")
					else
						self:settext(string.format("%d/%d (%0.1f%%)", streamMeasures, totalMeasures, streamMeasures/totalMeasures*100))
					end
				end
			end
		}
-- label
		af3[#af3+1] = LoadFont("Common Normal")..{
			Text=col,
			Name=col,
			InitCommand=function(self)
				local textHeight = 17
				local textZoom = 0.7
				self:maxwidth(width/textZoom):zoom(textZoom):horizalign(left)
				self:xy(-width/2 + 108, -height/2 + 10)
				self:addx((j-1)*colSpacing)
				self:addy((i-1)*rowSpacing)
				self:diffuse(Color.Black)
			end,
		}

	end
end

return af
