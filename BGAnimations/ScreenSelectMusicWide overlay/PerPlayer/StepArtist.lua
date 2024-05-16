local player = ...
local pn = ToEnumShortString(player)
local p = PlayerNumber:Reverse()[player]

local text_table, marquee_index

return Def.ActorFrame{
	Name="StepArtistAF_" .. pn,

	-- song and course changes
	OnCommand=function(self) self:queuecommand("Reset") end,
	["CurrentSteps"..pn.."ChangedMessageCommand"]=function(self) self:queuecommand("Reset") end,
	CurrentSongChangedMessageCommand=function(self) self:queuecommand("Reset") end,
	CurrentCourseChangedMessageCommand=function(self) self:queuecommand("Reset") end,

	--since we're now resetting ScreenSelectMusicWide when a new player joins, we don't want this animation to play
	-- PlayerJoinedMessageCommand=function(self, params)
	-- 	if params.Player == player then
	-- 		self:queuecommand("Appear" .. pn)
	-- 	end
	-- end,

	-- Simply Love doesn't support player unjoining (that I'm aware of!) but this
	-- animation is left here as a reminder to a future me to maybe look into it.
	PlayerUnjoinedMessageCommand=function(self, params)
		if params.Player == player then
			self:accelerate(0.1):zoomy(0.6):decelerate(0.2):zoomy(1):accelerate(0.2):sleep(0.2):zoomy(0):visible(false)
		end
	end,

	-- depending on the value of pn, this will either become
	-- an AppearP1Command or an AppearP2Command when the screen initializes
	["Appear"..pn.."Command"]=function(self) self:visible(true):zoomy(0):sleep(0.2):accelerate(0.2):zoomy(1):decelerate(0.2):zoomy(0.6):accelerate(0.1):zoomy(1) end,

	InitCommand=function(self)
		self:visible( false ):halign( p )
		if GAMESTATE:GetNumPlayersEnabled() == 2 then
			self:y(_screen.cy + 77.5)
		else
			self:y(_screen.cy + 12.5)
		end

		if player == PLAYER_1 then
			self:x( _screen.cx - 427.5)
		elseif player == PLAYER_2 then
			self:x( _screen.cx + 254.5)
		end

		if GAMESTATE:IsHumanPlayer(player) then
			self:queuecommand("Appear" .. pn)
		end
	end,


 	-- colored background
 	Def.ActorFrame{
		InitCommand=function(self)
			if GAMESTATE:GetNumPlayersEnabled() == 2 then
				self:y(0)
			else
				self:y(4)
			end
			if player == PLAYER_1 then
				self:x(107)
			elseif player == PLAYER_2 then
				self:x(66)
				self:rotationy(180)
			end
			if ThemePrefs.Get("VisualStyle") == "Technique" then
				self:diffusealpha(0.5)
			end
		end,

		Def.ActorMultiVertex{
			InitCommand=function(self)
				-- these coordinates aren't neat and tidy, but they do create three triangles
				-- that fit together to approximate hurtpiggypig's original png asset
				--change 422 for length, -17 changes the height, and +18 moves the "carrot" to under "STEPS"
				local verts = {
					--   x   y  z    r,g,b,a
					{{-113, GAMESTATE:GetNumPlayersEnabled() == 2 and -15 or -32, 0}, {1,1,1,1}},
					{{ _screen.w/2.0285, GAMESTATE:GetNumPlayersEnabled() == 2 and -15 or -32, 0}, {1,1,1,1}},
					{{ _screen.w/2.0285, 16, 0}, {1,1,1,1}},

					{{ _screen.w/2.0285, 16, 0}, {1,1,1,1}},
					{{-113, 16, 0}, {1,1,1,1}},
					{{-113, GAMESTATE:GetNumPlayersEnabled() == 2 and -15 or -32, 0}, {1,1,1,1}},

					{{ -80, 16, 0}, {1,1,1,1}},
					{{ -60, 16, 0}, {1,1,1,1}},
					{{ -70, 29, 0}, {1,1,1,1}},
				}
				self:SetDrawState({Mode="DrawMode_Triangles"}):SetVertices(verts)
				self:diffuse(GetCurrentColor())
				self:xy(-50,0):zoom(0.5)
			end,
			ResetCommand=function(self)
				local StepsOrTrail = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player) or GAMESTATE:GetCurrentSteps(player)

				if StepsOrTrail then
					local difficulty = StepsOrTrail:GetDifficulty()
					self:diffuse( DifficultyColor(difficulty) )
				else
					self:diffuse( PlayerColor(player) )
				end
			end
		},

	},

	--STEPS label
	LoadFont("Common Normal")..{
		Text=GAMESTATE:IsCourseMode() and Screen.String("SongNumber"):format(1) or Screen.String("STEPS"),
		OnCommand=function(self)
			self:diffuse(0,0,0,1)
			self:maxwidth(40)
			if ThemePrefs.Get("VisualStyle") == "Technique" then
				self:diffuse(Color.White)
			end
			if GAMESTATE:GetNumPlayersEnabled() == 2 then
				self:zoom(0.65)
			else end
			if player == PLAYER_1 then
				self:horizalign(left)
				self:x(3)
			elseif player == PLAYER_2 then
				self:horizalign(right)
				self:x(170)
			end
		end
	},

	--stepartist text
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:diffuse(color("#1e282f"))
			if ThemePrefs.Get("VisualStyle") == "Technique" then
				self:diffuse(Color.White)
			end
			if GAMESTATE:GetNumPlayersEnabled() == 2 then
				self:zoom(0.65)
				self:maxwidth(359)
			else
 				self:maxwidth(217)
			end
 				if player == PLAYER_1 then
					if GAMESTATE:GetNumPlayersEnabled() == 2 then
						self:x(31)
					else
						self:x(46)
					end
 					self:horizalign(left)
				elseif player == PLAYER_2 then
					if GAMESTATE:GetNumPlayersEnabled() == 2 then
						self:x(141)
					else
						self:x(126)
					end
 					self:horizalign(right)
 				end
		end,
		ResetCommand=function(self)

			local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()
			local StepsOrTrail = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentTrail(player) or GAMESTATE:GetCurrentSteps(player)

			-- always stop tweening when steps change in case a MarqueeCommand is queued
			self:stoptweening()

			if SongOrCourse and StepsOrTrail then

				text_table = GetStepsCredit(player)
				marquee_index = 0

				-- don't queue a Marquee in CourseMode
				-- each TrailEntry text change will be broadcast from CourseContentsList.lua
				-- to ensure it stays synced with the scrolling list of songs
				if not GAMESTATE:IsCourseMode() then
					-- only queue a Marquee if there are things in the text_table to display
					if #text_table > 0 then
						self:queuecommand("Marquee")
					else
						-- no credit information was specified in the simfile for this stepchart, so just set to an empty string
						self:settext("")
					end
				end
			else
				-- there wasn't a song/course or a steps object, so the MusicWheel is probably hovering
				-- on a group title, which means we want to set the stepartist text to an empty string for now
				self:settext("")
			end
		end,
		MarqueeCommand=function(self)
			-- increment the marquee_index, and keep it in bounds
			marquee_index = (marquee_index % #text_table) + 1
			-- retrieve the text we want to display
			-- alternatively, display that steps are autogenerated
			local text = GAMESTATE:GetCurrentSteps(player):IsAutogen() and THEME:GetString("ScreenSelectMusic", "AUTOGEN") or text_table[marquee_index]

			-- set this BitmapText actor to display that text
			self:settext( text )

			-- check for emojis; they shouldn't be diffused to Color.Black
			DiffuseEmojis(self, text)

			if not GAMESTATE:IsCourseMode() then
				-- sleep 2 seconds before queueing the next Marquee command to do this again
				if #text_table > 1 then
					self:sleep(2):queuecommand("Marquee")
				end
			else
				self:sleep(0.5):queuecommand("m")
			end
		end,
		UpdateTrailTextMessageCommand=function(self, params)
			if text_table then
				self:settext( text_table[params.index] or "" )
			end
		end,
		OffCommand=function(self) self:stoptweening() end
	}
}
