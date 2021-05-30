local path = "/"..THEME:GetCurrentThemeDirectory().."Graphics/_FallbackBanners/"..ThemePrefs.Get("VisualStyle")
local SongOrCourse = GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse() or GAMESTATE:GetCurrentSong()

local banner = {
	directory = (FILEMAN:DoesFileExist(path) and path or THEME:GetPathG("","_FallbackBanners/Arrows")),
	width = 418,
	zoom = 0.7,
}

-- the Quad containing the bpm and music rate doesn't appear in Casual mode
-- so nudge the song title and banner down a bit when in Casual
local y_offset = SL.Global.GameMode=="Casual" and 60.5 or 46


local af = Def.ActorFrame{ InitCommand=function(self) self:xy(_screen.cx, y_offset):draworder(1) end }

if SongOrCourse and SongOrCourse:HasBanner() then
	--song or course banner, if there is one
	af[#af+1] = Def.Banner{
		Name="Banner",
		InitCommand=function(self)
			if GAMESTATE:IsCourseMode() then
				self:LoadFromCourse( GAMESTATE:GetCurrentCourse() )
			else
				self:LoadFromSong( GAMESTATE:GetCurrentSong() )
			end
			self:setsize(banner.width, 164)
			if SL.Global.GameMode=="Casual" or GAMESTATE:IsCourseMode() then
				self:zoom(0.7)
				self:y(66)
			else
				self:zoom(0.6)
				self:y(41)
			end
		end,
	}
else
	if HasGroupBanner() then
		--group banner, if toggled on in settings
 		af[#af+1] = Def.Banner{
 			Name="GroupBanner",
 			InitCommand=function(self)
 				self:Load(GetGroupBanner());
 			end,
 			OnCommand=function(self)
 				self:setsize(banner.width, 164)
 				if SL.Global.GameMode=="Casual" or GAMESTATE:IsCourseMode() then
 					self:zoom(0.7)
 					self:y(66)
 				else
 					self:zoom(0.6)
 					self:y(41)
 				end
 			end,
 		};
 	else
 		--fallback banner
 		af[#af+1] = LoadActor(banner.directory .. "/banner" .. SL.Global.ActiveColorIndex .. " (doubleres).png")..{
 			InitCommand=function(self)
 				self:setsize(banner.width, 164)
 				if SL.Global.GameMode=="Casual" or GAMESTATE:IsCourseMode() then
 					self:zoom(0.7)
 					self:y(66)
 				else
 					self:zoom(0.6)
 					self:y(41)
 				end
 			end
 		}
	end
end

-- quad behind the song/course title text
af[#af+1] = Def.Quad{
	InitCommand=function(self)
		self:diffuse(color("#1E282F"))
		if SL.Global.GameMode=="Casual" or GAMESTATE:IsCourseMode() then
			self:zoom(0.7)
			self:setsize(banner.width,25)
		else
			self:y(y_offset+68)
			self:zoom(0.6)
			self:setsize(banner.width,80)
		end
	end,
}

-- song/course title text
af[#af+1] = LoadFont("Common Normal")..{
	InitCommand=function(self)
		local songtitle = (GAMESTATE:IsCourseMode() and GAMESTATE:GetCurrentCourse():GetDisplayFullTitle()) or GAMESTATE:GetCurrentSong():GetDisplayFullTitle()
		if songtitle then
			self:settext(songtitle)
			if SL.Global.GameMode=="Casual" or GAMESTATE:IsCourseMode() then
				self:maxwidth(banner.width*0.7)
			else
				self:maxwidth(banner.width*0.6)
				self:y(y_offset+52)
				self:zoom(0.8)
			end
		end
	end
	--when using af[#af+1] = ... you must use a semicolon for this code to continue to the following actorframe, using a comma here will just cause the rest of the code not to work
 	};

 -- the song information in this ActorFrame is too advanced for Casual
	af[#af+1] = Def.ActorFrame{
		InitCommand=function(self)
			if GAMESTATE:IsCourseMode() or SL.Global.GameMode=="Casual" then
				self:visible(false)
			end
		end,
		-- song group - "Hey, what pack is that from?"
		--We're using song group here, rather than folder, because I don't think it's necessary to know the folder that a song is in like it is on the music select screen (especially since the song folder will generally have the name of the song in it, and it'd just be redundant information). If I were to add the option for song folder, I'd make it yet another simply love preference. More freedom, more better.

 		-- Song Group Label
		LoadFont("Common Normal")..{
			InitCommand=function(self)
					self:zoom(.7)
					self:horizalign(right)
					self:xy(-96,y_offset+68)
					self:maxwidth(40)
					self:settext(THEME:GetString("SongDescription", "Group"))
				end,
			OnCommand=cmd(diffuse,color("0.5,0.5,0.5,1"))
		},

 		-- Song Group
		LoadFont("Common Normal")..{
			InitCommand=function(self) self:maxwidth(banner.width*banner.zoom):xy(-91,y_offset+68):zoom(.7):horizalign(left) end,
			OnCommand=function(self)
				local song = GAMESTATE:GetCurrentSong()
				local text = ""
				if song then
					self:settext(song:GetGroupName())
				else
					self:settext("")
				end
			end
		},

 		-- BPM Label
		LoadFont("Common Normal")..{
			InitCommand=function(self)
					self:xy(-96,y_offset+84)
					self:zoom(0.7)
					self:horizalign(right)
					self:settext(THEME:GetString("SongDescription", "BPM"))
				end,
			OnCommand=cmd(diffuse,color("0.5,0.5,0.5,1"))
		},

 		-- text for BPM (and maybe music rate if ~= 1.0)
		LoadFont("Common Normal")..{
			InitCommand=function(self)
				self:zoom(0.7)
				self:horizalign(left)
				self:xy(-92,y_offset+84)
				self:maxwidth(189)
			end,
			OnCommand=function(self)
					-- FIXME: the current layout of ScreenEvaluation doesn't accommodate split BPMs
					--        so this currently uses the MasterPlayer's BPM values
					local bpms = StringifyDisplayBPMs()
					local MusicRate = SL.Global.ActiveModifiers.MusicRate
					if  MusicRate ~= 1 then
						-- format a string like "150 - 300 bpm (1.5x Music Rate)"
						self:settext( ("%s (%gx %s)"):format(bpms, MusicRate, THEME:GetString("OptionTitles", "MusicRate")) )
					else
						-- format a string like "100 - 200 bpm"
						self:settext( ("%s"):format(bpms))
					end

			end
		},

 		-- Song Length label
		LoadFont("Common Normal")..{
			InitCommand=function(self)
					if SL.Global.ActiveModifiers.MusicRate ~= 1 then
							self:maxwidth(50)
							self:x(77)
						else
							self:x(47)
					end
					self:y(y_offset+84)
					self:zoom(.7)
					self:horizalign(right)
					self:settext(THEME:GetString("SongDescription", "Length"):upper())
				end,
			OnCommand=cmd(diffuse,color("0.5,0.5,0.5,1"))
		},

 		-- song Length
		LoadFont("Common Normal")..{
			InitCommand=function(self)
					if SL.Global.ActiveModifiers.MusicRate ~= 1 then
							self:x(81)
						else
							self:x(51)
					end
					self:y(y_offset+84)
					self:zoom(.7)
					self:horizalign(left)
				end,
			OnCommand=function(self)
				local duration

 				if GAMESTATE:IsCourseMode() then
					local Players = GAMESTATE:GetHumanPlayers()
					local player = Players[1]
					local trail = GAMESTATE:GetCurrentTrail(player)

 					if trail then
						duration = TrailUtil.GetTotalSeconds(trail)
					end
				else
					local song = GAMESTATE:GetCurrentSong()
					if song then
						duration = song:MusicLengthSeconds()
					else
						local group_name = SCREENMAN:GetTopScreen():GetMusicWheel():GetSelectedSection()
						if group_name then
							duration = group_durations[group_name]
						end
					end
				end


 				if duration then
					duration = duration / SL.Global.ActiveModifiers.MusicRate
					if duration == 105.0 then
						-- r21 lol
						self:settext( THEME:GetString("SongDescription", "r21") )
					else
						local hours = 0
						if duration > 3600 then
							hours = math.floor(duration / 3600)
							duration = duration % 3600
						end

 						local finalText
						if hours > 0 then
							-- where's HMMSS when you need it?
							finalText = hours .. ":" .. SecondsToMMSS(duration)
						else
							finalText = SecondsToMSS(duration)
						end

 						self:settext( finalText )
					end
				else
					self:settext("")
				end
			end
		}
	}

return af
