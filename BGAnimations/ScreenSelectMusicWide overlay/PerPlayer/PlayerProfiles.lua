local player = ...
local pn = ToEnumShortString(player)
local p = PlayerNumber:Reverse()[player]
local profile_name = PROFILEMAN:GetProfile(player):GetDisplayName(player)
local profile = PROFILEMAN:GetProfile(player)
local avatar = GetPlayerAvatarPath(player)

local quads = profile.GetTotalScoresWithGrade and profile:GetTotalScoresWithGrade('Grade_Tier01') or -1
local tristars = profile.GetTotalScoresWithGrade and profile:GetTotalScoresWithGrade('Grade_Tier02') or -1
local doublestars = profile.GetTotalScoresWithGrade and profile:GetTotalScoresWithGrade('Grade_Tier03') or -1
local singlestars = profile.GetTotalScoresWithGrade and profile:GetTotalScoresWithGrade('Grade_Tier04') or -1

local noGetTotalScoresWithGrade = "OutFox Alpha 0.4.15 or newer required to display star counts (missing GetTotalScoresWithGrade() function)"

local w = 267
local h = 209
local offset = 63

--used to calculate the scroll speed with respect to rate mod, speed mod type, BPM ranges all respective to each player
--this was copied from ScreenPlayerOptions overlay/default.lua
--this function will eventually need to be updated to accomodate the new speed mod types supported by OutFox

local CalculateScrollSpeed = function(player)
	player   = player or GAMESTATE:GetMasterPlayerNumber()
	local pn = ToEnumShortString(player)

	local Steps = GAMESTATE:GetCurrentSong()
	local MusicRate    = SL.Global.ActiveModifiers.MusicRate or 1

	local SpeedModType = SL[pn].ActiveModifiers.SpeedModType
	local SpeedMod     = SL[pn].ActiveModifiers.SpeedMod

	local bpms = GetDisplayBPMs(player, Steps, MusicRate)
	if not (bpms and bpms[1] and bpms[2]) then return "" end

	if SpeedModType=="X" then
		bpms[1] = bpms[1] * SpeedMod
		bpms[2] = bpms[2] * SpeedMod

	elseif SpeedModType=="M" then
		bpms[1] = bpms[1] * (SpeedMod/bpms[2])
		bpms[2] = SpeedMod

	elseif SpeedModType=="C" then
		bpms[1] = SpeedMod
		bpms[2] = SpeedMod
	end

	-- format as strings
	bpms[1] = ("%.0f"):format(bpms[1])
	bpms[2] = ("%.0f"):format(bpms[2])

	if bpms[1] == bpms[2] then
		return bpms[1]
	end

	return ("%s-%s"):format(bpms[1], bpms[2])
end


--this code was taken from ScreenGameOver overlay/PlayerStatsWithoutProfile.lua
--this code will calculate Steps Hit during the session and for how long a session lasted
local totalTime = 0
local songsPlayedThisGame = 0
local notesHitThisGame = 0

-- Use pairs here (instead of ipairs) because this player might have late-joined
-- which will result in nil entries in the the Stats table, which halts ipairs.
-- We're just summing total time anyway, so order doesn't matter.
for i,stats in pairs( SL[ToEnumShortString(player)].Stages.Stats ) do
	totalTime = totalTime + (stats and stats.duration or 0)
	songsPlayedThisGame = songsPlayedThisGame + (stats and 1 or 0)

	if stats and stats.column_judgments then
		-- increment notesHitThisGame by the total number of tapnotes hit in this particular stepchart by using the per-column data
		-- don't rely on the engine's non-Miss judgment counts here for two reasons:
		-- 1. we want jumps/hands to count as more than 1 here
		-- 2. stepcharts can have non-1 #COMBOS parameters set which would artbitraily inflate notesHitThisGame

		for column, judgments in ipairs(stats.column_judgments) do
			for judgment, judgment_count in pairs(judgments) do
				if judgment ~= "Miss" then
					notesHitThisGame = notesHitThisGame + judgment_count
				end
			end
		end
	end
end

local hours = math.floor(totalTime/3600)
local minutes = math.floor((totalTime-(hours*3600))/60)
local seconds = round(totalTime%60)

--These local fuctions are used for displaying a player's currently selected mods; this may be useful in the future
--Until there's a way to change these mods from ScreenSelectMusicWide I see no reason to display this information since SpeedMods are really the only mods that players change from song to song

-- local PlayerOptions = GAMESTATE:GetPlayerState(player):GetPlayerOptionsArray("ModsLevel_Preferred")
-- -- start with an empty string...
-- local optionslist = ""
--
-- -- if the player used an XMod of 1x, it won't be in PlayerOptions list
-- -- so check here, and add it in manually if necessary
-- if SL[pn].ActiveModifiers.SpeedModType == "X" and SL[pn].ActiveModifiers.SpeedMod == 1 then
-- 	optionslist = "1x, "
-- end
--
-- --  ...and append options to that string as needed
-- for i,option in ipairs(PlayerOptions) do
--
-- 	-- these don't need to show up in the mods list
-- 	if option ~= "FailAtEnd" and option ~= "FailImmediateContinue" and option ~= "FailImmediate" then
-- 		-- 100% Mini will be in the PlayerOptions as just "Mini" so use the value from the SL table instead
-- 		if option:match("Mini") then
-- 			option = SL[pn].ActiveModifiers.Mini .. " Mini"
-- 		end
--
-- 		if option:match("Cover") then
-- 			option = THEME:GetString("OptionNames", "Cover")
-- 		end
--
-- 		if i < #PlayerOptions then
-- 			optionslist = optionslist..option..", "
-- 		else
-- 			optionslist = optionslist..option
-- 		end
-- 	end
-- end


-- a string representing the NoteSkin the player was using

-- local noteskin = GAMESTATE:GetPlayerState(player):GetCurrentPlayerOptions():NoteSkin()

-- NOTESKIN:LoadActorForNoteSkin() expects the noteskin name to be all lowercase(?)
-- so transform the string to be lowercase

-- noteskin = noteskin:lower()
-----


return Def.ActorFrame{
	Name="PlayerProfile_" .. pn,

	PlayerJoinedMessageCommand=function(self, params)
		if params.Player == player then
			self:queuecommand("Appear" .. pn)
		end
	end,

	PlayerUnjoinedMessageCommand=function(self, params)
		if params.Player == player then
			self:queuecommand("Appear" .. pn)
		end
	end,

	-- depending on the value of pn, this will either become
	-- an AppearP1Command or an AppearP2Command when the screen initializes
	["Appear"..pn.."Command"]=function(self)
		--rather than deal with Guest profile tracking, let's just not show a profile card for players that didn't bother to set up a profile
		if PROFILEMAN:IsPersistentProfile(player) then
			self:visible(true)
		else
			self:visible(false)
		end
	end,

	InitCommand=function(self)
		self:visible( false ):halign( p )
		self:y(SCREEN_TOP + 73)

		if player == PLAYER_1 then
			self:x( _screen.cx - 293.5)

		elseif player == PLAYER_2 then
				self:x( _screen.cx + 294)
		end

		if GAMESTATE:IsHumanPlayer(player) then
			self:queuecommand("Appear" .. pn)
		end
	end,

  --background quad
  Def.Quad{
      InitCommand = function(self)
          self:zoomto(w,h)
          self:diffuse(color("#1e282f")):diffusealpha(0.65)
					self:y(offset)
      end
  },
  --Profile Name
  LoadFont("Common Normal")..{
      Text = "Profile Name",
      InitCommand = function(self)
				self:horizalign(center)
				self:xy(42,-30)
				self:settext(profile_name)
      end,
  },

	--Total Number Of Songs Completed
  LoadFont("Common Normal")..{
      Text = "Total Songs Completed",
      InitCommand = function(self)
				self:horizalign(center)
				self:xy(42,-5)
				self:zoom(0.8)
				self:settext("Total Songs Completed: ".. commify(profile:GetNumTotalSongsPlayed()))
      end,
  },

	-- Profile photo
	Def.Sprite{
		InitCommand=function(self)
			self:x(-92)
		end,

		OnCommand=function(self)

			if avatar == nil and self:GetTexture() ~= nil then
				self:Load(nil):diffusealpha(0):visible(false)
				return
			end

			-- only read from disk if not currently set
			if self:GetTexture() == nil then
				self:Load(avatar):finishtweening():linear(0.075):diffusealpha(1)

				self:horizalign(center)

				self:setsize(80,80)
			end
		end,
	},

	-- fallback avatar
	Def.ActorFrame{
		InitCommand=function(self) self:visible(false):xy(-132,-40) end,
		OnCommand=function(self)
			if avatar == nil then
				self:visible(true)
			else
				self:visible(false)
			end
		end,

		Def.Quad{
			InitCommand=function(self)
				self:align(0,0):zoomto(80,80):diffuse(color("#283239aa"))
			end
		},
		LoadActor(THEME:GetPathG("", "_VisualStyles/".. ThemePrefs.Get("VisualStyle") .."/SelectColor"))..{
			InitCommand=function(self)
				self:align(0.5,0):zoom(0.09):diffusealpha(0.9):xy(40,8)
			end
		},
		LoadFont("Common Normal")..{
			Text=THEME:GetString("ProfileAvatar","NoAvatar"),
			InitCommand=function(self)
				self:horizalign(center):zoom(0.815):diffusealpha(0.9):xy(40,71)
			end,
		}
	},

  -- Quad Star
	Def.Sprite{
      Texture = (THEME:GetPathG("","_grades/smallgrades 1x18.png")),
      InitCommand = function(self)
				self:animate(false):setstate(0)
				self:zoom(0.2):xy(-25,15)
			end,
  },

	--Quads Value
	LoadFont("Common Normal")..{
			Text = "",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(-25,32)
				if quads >= 0 then
					self:settext(commify(quads))
				else end
				self:zoom(0.7):maxwidth(40)
			end,
	},

	-- Tri Star
	Def.Sprite{
			Texture = (THEME:GetPathG("","_grades/smallgrades 1x18.png")),
			InitCommand = function(self)
				self:animate(false):setstate(1)
				self:zoom(0.2):xy(18.5,15)
			end,
	},

	--Tri Value
	LoadFont("Common Normal")..{
			Text = "",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(18.5,32)
				if tristars >= 0 then
					self:settext(commify(tristars))
				else end
				self:zoom(0.7)
			end,
	},

	-- Double Star
	Def.Sprite{
			Texture = (THEME:GetPathG("","_grades/smallgrades 1x18.png")),
			InitCommand = function(self)
				self:animate(false):setstate(2)
				self:zoom(0.2):xy(62,15)
			end,
	},

	--Double Value
	LoadFont("Common Normal")..{
			Text = "",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(62,32)
				if doublestars >= 0 then
					self:settext(commify(doublestars))
				else end
				self:zoom(0.7)
			end,
	},

	-- Single Star
	Def.Sprite{
			Texture = (THEME:GetPathG("","_grades/smallgrades 1x18.png")),
			InitCommand = function(self)
				self:animate(false):setstate(3)
				self:zoom(0.2):xy(105,15)
			end,
	},

	--Single Value
	LoadFont("Common Normal")..{
			Text = "",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(105,32)
				if singlestars >= 0 then
					self:settext(commify(singlestars))
				else end
				self:zoom(0.7)
			end,
	},

	--error message displayed to users if GetTotalScoresWithGrade() function isn't available
	LoadFont("Common Normal")..{
			Text = "",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(42,33)
				self:zoom(0.5)
				self:wrapwidthpixels(350)
				self:vertspacing(-5)
				if quads < 0 then
					self:settext(noGetTotalScoresWithGrade)
				else end
			end,
	},

	-- thin white line separating stats from mods
	Def.Quad {
		InitCommand=function(self)
			self:zoomto(w-20,2):xy(0,47):diffusealpha(0.5)
		end,
	},

	--Number of times current song attemped
	LoadFont("Common Normal")..{
		Text = "Number Times Song Attempted",
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end,
		InitCommand = function(self)
			self:horizalign(center)
			self:y(59)
			self:zoom(0.8)
		end,
		SetCommand=function(self)
			if GAMESTATE:GetCurrentSong() == nil then
				self:settext("")
			else
				self:settext("Times Song Attempted: "..commify(PROFILEMAN:GetSongNumTimesPlayed(GAMESTATE:GetCurrentSong(),p)))
			end
		end,
	},

	--Speed Mod Label
	LoadFont("Common Normal")..{
			Text = "SPEED MOD",
			InitCommand = function(self)
				self:horizalign(left)
				self:xy(-127,77)
				self:zoom(0.7)
				self:diffuse(color("0.5,0.5,0.5,1"))
			end,
	},

	--Speed Mod Value
  LoadFont("Common Normal")..{
    Text = "Speed Mod",
    InitCommand = function(self)
			self:horizalign(left)
			self:xy(-73,77)
			self:zoom(0.7)
			self:queuecommand("Set")
    end,
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end,
		SetCommand=function(self)
			if GAMESTATE:GetCurrentSong() == nil then
				self:settext("")
			else
				self:settext(SL[pn].ActiveModifiers.SpeedModType..SL[pn].ActiveModifiers.SpeedMod)
			end
		end,
  },

	--Scroll Rate Label
	LoadFont("Common Normal")..{
			Text = "SCROLL RATE",
			InitCommand = function(self)
				self:horizalign(right)
				self:xy(127,77)
				self:zoom(0.7)
				self:diffuse(color("0.5,0.5,0.5,1"))
			end,
	},

	--Scroll Rate Value
  LoadFont("Common Normal")..{
    Text = "Scroll Rate",
    InitCommand = function(self)
			self:horizalign(right)
			self:xy(65,77)
			self:zoom(0.7)
			self:queuecommand("Set")
    end,
		CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end,
		SetCommand=function(self)
			if GAMESTATE:GetCurrentSong() == nil then
				self:settext("")
			else
				self:settext(("%s%s"):format(SL[pn].ActiveModifiers.SpeedModType, CalculateScrollSpeed(player)))
			end
		end,
  },

	-- thin white line separating mods from profile stats
	Def.Quad {
		InitCommand=function(self)
			self:zoomto(w-20,2):xy(0,90):diffusealpha(0.5)
		end,
	},

--in Pay Modes, I understand that these set metrics might not make sense to most users
--even though the data shown would be per-set and not per-day, I think that's overall valuable to the player and should not be removed in pay modes

	--Time Spent In Gameplay Label
	LoadFont("Common Normal")..{
			Text = "TIME PLAYED",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(-89,102)
				self:zoom(0.7)
				self:diffuse(color("0.5,0.5,0.5,1"))
			end,
	},

	--Time Spent In Gameplay Value
  LoadFont("Common Normal")..{
    Text = "TimePlayedThisSetValue",
    InitCommand = function(self)
			self:horizalign(center)
			self:xy(-89,116)
			self:zoom(0.7)
			if hours > 1 then
				self:settext(hours .. " hrs, " .. minutes .. " mins")
			elseif hours == 1 then
				self:settext(hours .. " hr, " .. minutes .. " mins")
			else
				self:settext(minutes .. " mins")
			end
		end,
  },

	--Songs Played This Set Label
	LoadFont("Common Normal")..{
			Text = "PLAYED THIS SET",
			InitCommand = function(self)
				self:horizalign(center)
				self:y(102)
				self:zoom(0.7)
				self:diffuse(color("0.5,0.5,0.5,1"))
			end,
	},

	--Songs Played This Set Value
  LoadFont("Common Normal")..{
    Text = "SongsPlayedThisSetValue",
    InitCommand = function(self)
			self:horizalign(center)
			self:y(116)
			self:zoom(0.7)
			if songsPlayedThisGame == 1 then
				self:settext(songsPlayedThisGame.." Song")
			else
				self:settext(songsPlayedThisGame.." Songs")
			end
		end,
  },

	--Steps Hit This Set Label
	LoadFont("Common Normal")..{
			Text = "STEPS HIT",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(89,102)
				self:zoom(0.7)
				self:diffuse(color("0.5,0.5,0.5,1"))
			end,
	},

	--Steps Hit This Set Value
  LoadFont("Common Normal")..{
    Text = "notesHitThisGameValue",
    InitCommand = function(self)
			self:horizalign(center)
			self:xy(89,116)
			self:zoom(0.7)
			self:settext(commify(notesHitThisGame))
		end,
  },

--lifetime stats

	--Time Spent In Gameplay Label (Lifetime)
	LoadFont("Common Normal")..{
			Text = "LIFETIME PLAYED",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(-51,138)
				self:zoom(0.7)
				self:diffuse(color("0.5,0.5,0.5,1"))
			end,
	},
		--Time Spent In Gameplay (Lifetime)
		LoadFont("Common Normal")..{
			Text = "LifetimeGameplayValue",
			InitCommand = function(self)
				local Lifetime = profile:GetTotalGameplaySeconds()
				local TotalDays = math.floor(Lifetime/86400)
			  local TotalHours = math.floor(math.fmod(Lifetime, 86400)/3600)
			  local TotalMinutes = math.floor(math.fmod(Lifetime,3600)/60)
				self:horizalign(center)
				self:xy(-51,152)
				self:zoom(0.7)
				--lots of rules here to handle the gramatically correct way of displaying time data (in English)
				--I geniunely think that the format DDD:HH:MM is less optimal to English-speaking players
				--FIXME:there should probably be a check for English vs other languages and just display DDD:HH:MM instead, but until there is a need for other regions, I'm keeping things as-is

				--to sum up the rules: show [ days + hours /or/ hours + minutes /or/ minutes ]
				--unfortunately, displaying [days + hours + minutes] takes up an unreasonable amount of space in this iteration of the UI

				--I highly doubt there will be many people who play with profiles with a large number of days worth of playtime to make the jump to "weeks + days + hours" make sense
				--a large number of days takes up less space than jumping to weeks/years calculations to the point that it's unreasonable for a player to have played long engough where displaying "weeks/years" will save space and/or make more sense
				--my hope is that once a player has achieved years worth of ingame playtime this game will have moved to a better way to display this sort of information

				if TotalDays > 1 and TotalHours == 1 then
					self:settext(TotalDays .. " days, " .. TotalHours .. " hr")
				elseif TotalDays > 1 and TotalHours ~= 1 then
					self:settext(TotalDays .. " days, " .. TotalHours .. " hrs")
				elseif TotalDays == 1 and TotalHours == 1 then
					self:settext(TotalDays .. " day, " .. TotalHours .. " hr")
				elseif TotalDays == 1 and TotalHours ~= 1 then
					self:settext(TotalDays .. " day, " .. TotalHours .. " hrs")
				elseif TotalDays <= 0 and TotalHours > 1 and TotalMinutes > 1 then
					self:settext(TotalHours .. " hrs, " .. TotalMinutes .. " mins")
				elseif TotalDays <= 0 and TotalHours > 1 and TotalMinutes == 0 then
					self:settext(TotalHours .. " hrs, " .. TotalMinutes .. " mins")
				elseif TotalDays <= 0 and TotalHours > 1 and TotalMinutes == 1 then
					self:settext(TotalHours .. " hrs, " .. TotalMinutes .. " min")
				elseif TotalDays <= 0 and TotalHours == 1 and TotalMinutes == 1 then
					self:settext(TotalHours .. " hr, " .. TotalMinutes .. " min")
				elseif TotalDays <= 0 and TotalHours == 1 and TotalMinutes ~= 1 then
					self:settext(TotalHours .. " hr, " .. TotalMinutes .. " mins")
				elseif TotalDays <= 0 and TotalHours <= 0 and TotalMinutes ~= 1 then
					self:settext(TotalMinutes .. " mins")
				elseif TotalDays <= 0 and TotalHours <= 0 and TotalMinutes == 1 then
					self:settext(TotalMinutes .. " min")
				end
			end,
		},

		--Lifetime Steps Label
		LoadFont("Common Normal")..{
				Text = "LIFETIME STEPS",
				InitCommand = function(self)
					self:horizalign(center)
					self:xy(89-38,138)
					self:zoom(0.7)
					self:diffuse(color("0.5,0.5,0.5,1"))
				end,
		},

		--Lifetime Steps Value
	  LoadFont("Common Normal")..{
	    Text = "NotesHitLifetimeValue",
	    InitCommand = function(self)
				self:horizalign(center)
				self:xy(89-38,152)
				self:zoom(0.7)
				self:settext(commify(profile:GetTotalTapsAndHolds()))
			end,
	  },

	--NoteSkin prieview

	--can't be used because loads at first as the default noteskin then after going to player mods and exiting out or going to GAMEPLAY will correctly display the player's chosen NoteSkin
	-- GetNoteSkinActor() is defined in ./Scripts/SL-Helpers.lua, and performs some
	-- rudimentary error handling because NoteSkins From The Internet™ may contain Lua errors
	-- LoadActor(THEME:GetPathB("","_modules/NoteSkinPreview.lua"), {noteskin_name=noteskin})..{
	-- 	OnCommand=function(self)
	-- 		self:xy(-100-5-2+3,76):zoom(0.55):visible(true)
	-- 	end
	-- },
}
