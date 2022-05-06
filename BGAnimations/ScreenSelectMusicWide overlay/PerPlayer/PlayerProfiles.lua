local player = ...
local pn = ToEnumShortString(player)
local p = PlayerNumber:Reverse()[player]
local profile_name = PROFILEMAN:GetProfile(player):GetDisplayName(player)
local profile = PROFILEMAN:GetProfile(player)
local avatar = GetPlayerAvatarPath(player)

local quads = profile:GetTotalScoresWithGrade('Grade_Tier01')
local tristars = profile:GetTotalScoresWithGrade('Grade_Tier02')
local doublestars = profile:GetTotalScoresWithGrade('Grade_Tier03')
local singlestars = profile:GetTotalScoresWithGrade('Grade_Tier04')

local w = 266.5
local h = 84
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
		self:y(SCREEN_TOP + 74)

		if player == PLAYER_1 then
			self:x( _screen.cx - 294)

		elseif player == PLAYER_2 then
				self:x( _screen.cx + 294)
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
				self:xy(42,-30)
				self:settext(profile_name)
      end,
  },
  --Number of times current song played
  LoadFont("Common Normal")..{
      Text = "Number Times Song Played",
			CurrentSongChangedMessageCommand=function(self) self:playcommand("Set") end,
      InitCommand = function(self)
				self:horizalign(center)
				self:xy(42,-5)
				self:zoom(0.8)
      end,
			SetCommand=function(self)
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
			Text = "9999",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(-25,32)
				self:settext(quads)
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
			Text = "9999",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(18.5,32)
				self:settext(tristars)
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
			Text = "9999",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(62,32)
				self:settext(doublestars)
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
			Text = "9999",
			InitCommand = function(self)
				self:horizalign(center)
				self:xy(105,32)
				self:settext(singlestars)
				self:zoom(0.7)
			end,
	},
}
