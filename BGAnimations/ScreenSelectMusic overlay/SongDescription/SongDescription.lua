local MusicWheel, SelectedType
local group_durations = LoadActor("../../ScreenSelectMusic overlay/SongDescription/GroupDurations.lua")

-- width of background quad
local _w = 320

local af = Def.ActorFrame{
	OnCommand=function(self)
		self:xy(_screen.cx, SCREEN_TOP+192)
	end,

	CurrentSongChangedMessageCommand=function(self)    self:playcommand("Set") end,
	CurrentCourseChangedMessageCommand=function(self)  self:playcommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(self) self:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(self) self:playcommand("Set") end,
}

-- background Quad for Artist, BPM, and Song Length
af[#af+1] = Def.Quad{
	InitCommand=function(self)
		self:setsize( _w, 70 )
		self:diffuse(color("#1e282f"))

		if ThemePrefs.Get("RainbowMode") then self:diffusealpha(0.9) end
		if ThemePrefs.Get("VisualStyle") == "Technique" then
			self:diffusealpha(0.5)
		end
	end
}

-- ActorFrame for Folder/Group, Artist, BPM, and Song length
af[#af+1] = Def.ActorFrame{
	InitCommand=function(self) self:xy(-110,-16) end,

	-- ----------------------------------------
	-- Song Folder Label
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:zoom(0.9)
			self:horizalign(right)
			self:y(-10)
			if ThemePrefs.Get("VerboseSongFolder") then
				self:settext(THEME:GetString("SongDescription", "Folder"))
			else
				self:settext(THEME:GetString("SongDescription", "Group"))
			end
		end,
		OnCommand=cmd(diffuse,color("0.5,0.5,0.5,1"))
	},

	-- ----------------------------------------
	-- Song Folder
 	LoadFont("Common Normal")..{
 		InitCommand=function(self)
			-- no need to hide this in CourseMode because this will instead settext to nothing and not show up
			self:horizalign(left):xy(6,-10):maxwidth(285):zoom(0.9)
		end,
 		SetCommand=function( actor )
 			local song = GAMESTATE:GetCurrentSong()
 			local text = ""
 				if ThemePrefs.Get("VerboseSongFolder") then
 					if song then
 							--I would like to find a better method to trim up GetSongDir, but this will work for now, because I highly doubt people will name their packs "Songs" or "AdditionalSongs"
 						local fulldir = song:GetSongDir();
 							--removes the "/ " suffix placed by GetSongDir() (will not impact
 						local remove_end = string.sub(fulldir, 0, -2);
 							--removes "/Songs/" prefix, but if a songs folder is called "Songs" you'll get weird formatting
 						local trimmed_dir = string.gsub(remove_end, "/Songs/", "", 1)
 							--removes "/AdditionalSongs/" from the directory string, and will cause formatting weirdness if there is a song folder with that name
 						local SongDir = string.gsub(trimmed_dir, "/AdditionalSongs/", "", 1)
 						text = SongDir
 					end
 				 actor:settext( text )
 			 else
 			--  This is a cleaner way to call the group name of a selected song, but I prefer the above method because it shows the actual songfolder directory, which sometimes has information in it. You can set your preference in Simply Love Options for which method you prefer.
 				 if song then
 					 actor:settext(song:GetGroupName());
 				 else
 					 actor:settext("")
 				 end
 			 end
 		end
 	},

	-- ----------------------------------------
	-- Artist Label
	LoadFont("Common Normal")..{
		Text=THEME:GetString("SongDescription", "Artist"):upper(),
		InitCommand=function(self)
			self:align(1,0)
			self:maxwidth(44)
			self:diffuse(0.5,0.5,0.5,1)
			self:y(0):zoom(0.9)
		end,
	},

	-- Song Artist (or number of Songs in this Course, if CourseMode)
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:align(0,0)
			self:x(5)
			self:y(0):zoom(0.9)
		end,
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			self:settext( song and song:GetDisplayArtist() or "" )

			if not GAMESTATE:IsEventMode() and song and (song:IsLong() or song:IsMarathon()) then
				-- make room for the "COUNTS AS 2/3 ROUNDS" bubble
				self:maxwidth(152)
			else
				self:maxwidth(287)
			end

			self:maxwidth(maxwidth)
		end
	},

	-- ----------------------------------------
	-- BPM Label
	LoadFont("Common Normal")..{
		Text=THEME:GetString("SongDescription", "BPM"):upper(),
		InitCommand=function(self)
			self:horizalign(center)
			self:diffuse(0.5,0.5,0.5,1)
			self:xy(-12,24)
 			self:zoom(0.8)
		end
	},

	-- BPM value
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			-- vertical align has to be middle for BPM value in case of split BPMs having a line break
			self:horizalign(center):diffuse(1,1,1,1):vertspacing(-8):x(5):maxwidth(78)
			self:xy(-12,40)
		end,
		SetCommand=function(self)

			if MusicWheel then SelectedType = MusicWheel:GetSelectedType() end

			-- we only want to try to show BPM values for Songs and Courses
			-- not Section, Roulette, Random, Portal, Sort, or Custom
			-- (aside: what is "WheelItemDataType_Custom"?  I need to look into that.)
			if not (SelectedType=="WheelItemDataType_Song" or SelectedType=="WheelItemDataType_Course") then
				self:settext("")
				return
			end

			-- if only one player is joined, stringify the DisplayBPMs and return early
			if #GAMESTATE:GetHumanPlayers() == 1 then
				-- StringifyDisplayBPMs() is defined in ./Scipts/SL-BPMDisplayHelpers.lua
				self:settext(StringifyDisplayBPMs() or ""):zoom(0.8)
				return
			end

			-- otherwise there is more than one player joined and the possibility of split BPMs
			local p1bpm = StringifyDisplayBPMs(PLAYER_1)
			local p2bpm = StringifyDisplayBPMs(PLAYER_2)

			-- it's likely that BPM range is the same for both charts
			-- no need to show BPM ranges for both players if so
			if p1bpm == p2bpm then
				self:settext(p1bpm):zoom(0.8)

			-- different BPM ranges for the two players
			else
				-- show the range for both P1 and P2 split by a newline character, shrunk slightly to fit the space
				self:settext( "P1 ".. p1bpm .. "\n" .. "P2 " .. p2bpm ):zoom(0.5)
				-- the "P1 " and "P2 " segments of the string should be grey
				self:AddAttribute(0,             {Length=3, Diffuse={0.60,0.60,0.60,1}})
				self:AddAttribute(3+p1bpm:len(), {Length=3, Diffuse={0.60,0.60,0.60,1}})

				if GAMESTATE:IsCourseMode() then
					-- P1 and P2's BPM text in CourseMode is white until I have time to figure CourseMode out
					self:AddAttribute(3,             {Length=p1bpm:len(), Diffuse={1,1,1,1}})
					self:AddAttribute(7+p1bpm:len(), {Length=p2bpm:len(), Diffuse={1,1,1,1}})

				else
					-- P1 and P2's BPM text is the color of their difficulty
					if GAMESTATE:GetCurrentSteps(PLAYER_1) then
						self:AddAttribute(3,             {Length=p1bpm:len(), Diffuse=DifficultyColor(GAMESTATE:GetCurrentSteps(PLAYER_1):GetDifficulty())})
					end
					if GAMESTATE:GetCurrentSteps(PLAYER_2) then
						self:AddAttribute(7+p1bpm:len(), {Length=p2bpm:len(), Diffuse=DifficultyColor(GAMESTATE:GetCurrentSteps(PLAYER_2):GetDifficulty())})
					end
				end
			end
		end
	},

	-- ----------------------------------------
	-- Song Duration Label
	LoadFont("Common Normal")..{
		Text=THEME:GetString("SongDescription", "Length"):upper(),
		InitCommand=function(self)
			self:horizalign(center):diffuse(0.5,0.5,0.5,1):xy(233,24):zoom(0.8)
		end
	},

	-- Song Duration Value
	LoadFont("Common Normal")..{
		InitCommand=function(self)
			self:horizalign(center):xy(233,40):zoom(0.8)
		end,
		SetCommand=function(self)
			if MusicWheel == nil then MusicWheel = SCREENMAN:GetTopScreen():GetMusicWheel() end

			SelectedType = MusicWheel:GetSelectedType()
			local seconds

			if SelectedType == "WheelItemDataType_Song" then
				-- GAMESTATE:GetCurrentSong() can return nil here if we're in pay mode on round 2 (or later)
				-- and we're returning to SSM to find that the song we'd just played is no longer available
				-- because it exceeds the 2-round or 3-round time limit cutoff.
				local song = GAMESTATE:GetCurrentSong()
				if song then
					seconds = song:MusicLengthSeconds()
				end

			elseif SelectedType == "WheelItemDataType_Section" then
				-- MusicWheel:GetSelectedSection() will return a string for the text of the currently active WheelItem
				-- use it here to look up the overall duration of this group from our precalculated table of group durations
				seconds = group_durations[MusicWheel:GetSelectedSection()]

			elseif SelectedType == "WheelItemDataType_Course" then
				-- is it possible for 2 Trails within the same Course to have differing durations?
				-- I can't think of a scenario where that would happen, but hey, this is StepMania.
				-- In any case, I'm opting to display the duration of the MPN's current trail.
				local trail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
				if trail then
					seconds = TrailUtil.GetTotalSeconds(trail)
				end
			end

			-- r21 lol
			if seconds == 105.0 then self:settext(THEME:GetString("SongDescription", "r21")); return end

			if seconds then
				seconds = seconds / SL.Global.ActiveModifiers.MusicRate

				-- longer than 1 hour in length
				if seconds > 3600 then
					-- format to display as H:MM:SS
					self:settext(math.floor(seconds/3600) .. ":" .. SecondsToMMSS(seconds%3600))
				else
					-- format to display as M:SS
					self:settext(SecondsToMSS(seconds))
				end
			else
				self:settext("")
			end
		end
	}
}

if not GAMESTATE:IsEventMode() then

	-- long/marathon version bubble graphic and text
	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self)
			self:x(98)
			self:y(-8)
		end,
		SetCommand=function(self)
			local song = GAMESTATE:GetCurrentSong()
			self:visible( song and (song:IsLong() or song:IsMarathon()) or false )
		end,


		Def.ActorMultiVertex{
			InitCommand=function(self)
				-- these coordinates aren't neat and tidy, but they do create three triangles
				-- that fit together to approximate hurtpiggypig's original png asset
				local verts = {
					--   x   y  z    r,g,b,a
					{{-113, -15, 0}, {1,1,1,1}},
					{{ 113, -15, 0}, {1,1,1,1}},
					{{ 113, 16, 0}, {1,1,1,1}},

					{{ 113, 16, 0}, {1,1,1,1}},
					{{-113, 16, 0}, {1,1,1,1}},
					{{-113, -15, 0}, {1,1,1,1}},

					{{ -98+134, 16-5, 0}, {1,1,1,1}},
					{{ -78+134, 16-5, 0}, {1,1,1,1}},
					{{ -88+134, 29-5, 0}, {1,1,1,1}},
				}
				self:SetDrawState({Mode="DrawMode_Triangles"}):SetVertices(verts)
				self:diffuse(GetCurrentColor())
				self:xy(0,0):zoom(0.5)
			end
		},

		LoadFont("Common Normal")..{
			InitCommand=function(self) self:diffuse(Color.Black):zoom(0.8) end,
			SetCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				if not song then self:settext(""); return end

				if song:IsMarathon() then
					self:settext(THEME:GetString("SongDescription", "IsMarathon"))
				elseif song:IsLong() then
					self:settext(THEME:GetString("SongDescription", "IsLong"))
				else
					self:settext("")
				end
			end
		}
	}
end

return af
