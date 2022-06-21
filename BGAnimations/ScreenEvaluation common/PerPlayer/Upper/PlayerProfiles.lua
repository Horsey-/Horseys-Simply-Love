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

local w = 114
local h = 269.5
-----

if IsUsingWideScreen() then

return Def.ActorFrame{
	Name="PlayerProfileEval_" .. pn,

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
		self:y(_screen.cy + 78.75)

		if player == PLAYER_1 then
			self:x( _screen.cx - 634)

		elseif player == PLAYER_2 then
				self:x( _screen.cx - 219)
		end

		if GAMESTATE:IsHumanPlayer(player) then
			self:queuecommand("Appear" .. pn)
		end
	end,

  --black outline
  Def.Quad{
      InitCommand = function(self)
          self:zoomto(w, h):diffuse(Color.Black)
      end
  },
  --background quad
  Def.Quad{
      InitCommand = function(self)
          self:zoomto(w - 2, h - 2)
          self:diffuse(color("#1e282f"))
      end
  },
  --Profile Name
  LoadFont("Common Normal")..{
      Text = "Profile Name",
      InitCommand = function(self)
				self:horizalign(center)
				self:y(-90)
				self:maxwidth(105)
				self:settext(profile_name)
      end,
  },
  --Number of times current song played
  LoadFont("Common Normal")..{
      Text = "Number Times Song Played",
      InitCommand = function(self)
				self:horizalign(center)
				self:y(13)
				self:zoom(0.8)
				self:maxwidth(125)
      end,
			OnCommand=function(self)
				if GAMESTATE:GetCurrentSong() == nil then
					self:settext("")
				else
					self:settext("Times Played: "..PROFILEMAN:GetSongNumTimesPlayed(GAMESTATE:GetCurrentSong(),p))
				end
			end,
  },

	-- Profile photo
	Def.Sprite{
		InitCommand=function(self)
			self:y(-38)
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
		InitCommand=function(self) self:visible(false):xy(-40,-78) end,
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
				self:zoom(0.2):xy(-21,35)
			end,
  },

	--Quads Value
	LoadFont("Common Normal")..{
			Text = "",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(-21,52)
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
				self:zoom(0.2):xy(21,35)
			end,
	},

	--Tri Value
	LoadFont("Common Normal")..{
			Text = "",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(21,52)
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
				self:zoom(0.2):xy(-21,75)
			end,
	},

	--Double Value
	LoadFont("Common Normal")..{
			Text = "",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(-21,92)
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
				self:zoom(0.2):xy(21,75)
			end,
	},

	--Single Value
	LoadFont("Common Normal")..{
			Text = "",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(21,92)
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
				self:y(109)
				self:zoom(0.45)
				self:wrapwidthpixels(210)
				self:vertspacing(-5)
				if quads < 0 then
					self:settext(noGetTotalScoresWithGrade)
				else end
			end,
	},
}

else end
