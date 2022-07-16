-- Majority of code borrowed from Mr. ThatKid and Sudospective; with much help from the OutFox discord.

local NotefieldRenderAfter = 0 --THEME:GetMetric("Player","DrawDistanceAfterTargetsPixels")
local PreviewDelay = THEME:GetMetric("ScreenSelectMusic", "SampleMusicDelay")

local function GetCurrentChartIndex(pn, ChartArray)
    local PlayerSteps = GAMESTATE:GetCurrentSteps(pn)
    -- Not sure how the previous checks fails at times, so here it is once again
    if ChartArray then
        for i=1,#ChartArray do
            if PlayerSteps == ChartArray[i] then
                return i
            end
        end
    end
    -- If it reaches this point, the selected steps doesn't equal anything
    return nil
end

local t = Def.ActorFrame {}

for i, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
    -- To avoid crashes with player 2
    local pnNoteField = PlayerNumber:Reverse()[pn]

    -- the draw distance needs to be dependant on doubles mode because the notefield has to be zoomed out in order for the doubles NoteField to fit onscreen
    local function NotefieldRenderBefore()  --THEME:GetMetric("Player","DrawDistanceBeforeTargetsPixels")
      if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
        return 805
      else
        if PROFILEMAN:IsPersistentProfile(pnNoteField) then
          return 740
        else
          return 390
        end
      end
    end

    local function NotefieldX()
      -- 2 players joined UI
      if GAMESTATE:GetNumPlayersEnabled() == 2 then
        --player 1
        if pnNoteField == 0 then
          --with profile
          if PROFILEMAN:IsPersistentProfile(pn) then
            return _screen.cx-213
          --without profile
          else
            return _screen.cx-293
          end
        --player 2
        elseif pnNoteField == 1 then
          --with profile
          if PROFILEMAN:IsPersistentProfile(pn) then
            return _screen.cx+213
          --without profile
          else
            return _screen.cx+293
          end
        end
      -- single player UI (won't differ based on whether a profile is loaded)
      else
        --player 1
        if pnNoteField == 0 then
          return _screen.cx+293
        --player 2
        elseif pnNoteField == 1 then
          return _screen.cx-293
        end
      end
    end

    local function NotefieldZoom()
      --2 players
      if GAMESTATE:GetNumPlayersEnabled() == 2 then
        --with profiles
        if PROFILEMAN:IsPersistentProfile(pn) then
          return 0.4
        --without profiles
        else
          return 1
        end
      --1 player
      else
        --doubles mode
        if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
          return 0.5
        end
        --default to zoom(1) outside of doubles mode
        return 1
      end
    end

    local function ReceptorPosNormal()
      --2 players
      if GAMESTATE:GetNumPlayersEnabled() == 2 then
        --with profiles
        if PROFILEMAN:IsPersistentProfile(pn) then
          return _screen.cy-115
        --without profiles
        else
          return _screen.cy-170
        end
      --1 player
      else
        --doubles mode
        if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
          return _screen.cy-135
        end

        return _screen.cy-170
      end
    end

    local function ReceptorPosReverse()
      --2 players
      if GAMESTATE:GetNumPlayersEnabled() == 2 then
        --with profiles
        if PROFILEMAN:IsPersistentProfile(pn) then
          return _screen.cy+492
        --without profiles
        else
          return _screen.cy+35
        end
      --1 player
      else
        --doubles mode
        if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
          return _screen.cy+615
        end

        return _screen.cy+170
      end
    end

    local ReceptorOffset = ReceptorPosReverse() - ReceptorPosNormal()
    local NotefieldY = (ReceptorPosNormal() + ReceptorPosReverse()) / 2

  --upgrade to OutFox LTS 0.4.18 or later for NoteField previews
  if not ActorUtil.IsRegisteredClass("NoteField") then
    t[#t+1] = Def.ActorFrame {
        Name="Player" .. ToEnumShortString(pn),
        FOV=45,
        InitCommand=function(self)
          self:x(NotefieldX())
          self:zoom(NotefieldZoom())
        end,

        LoadFont("Common Normal")..{
          InitCommand=function(self)
            self:y(_screen.cy)
            self:settext("Upgrade To OutFox LTS 0.4.18 Or Later For NoteField Previews \n \n (missing NoteField class)")
            self:wrapwidthpixels(250)
    				self:vertspacing(-5)
          end,
        },
    }
  else
    t[#t+1] = Def.ActorFrame {
        Name="Player" .. ToEnumShortString(pn),
        FOV=45,
        InitCommand=function(self)
          self:x(NotefieldX())
          self:zoom(NotefieldZoom())
        end,

        Def.NoteField {
            Name = "NotefieldPreview",
            Player = pnNoteField,
            NoteSkin = GAMESTATE:GetPlayerState(pnNoteField):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin(),
            Chart = Challenge,
            DrawDistanceAfterTargetsPixels = NotefieldRenderAfter,
            DrawDistanceBeforeTargetsPixels = NotefieldRenderBefore(),
            YReverseOffsetPixels = ReceptorOffset,
            FieldID=-1,
            OnCommand=function(self)
              self:ChangeReload( GAMESTATE:GetCurrentSteps(pnNoteField) )
              self:y(NotefieldY):GetPlayerOptions("ModsLevel_Current"):StealthPastReceptors(true, true)
              self:AutoPlay(true)
              local PlayerModsArray = GAMESTATE:GetPlayerState(pnNoteField):GetPlayerOptionsString("ModsLevel_Preferred")
              --force Mini% to 0 here because it throws off the notefield positioning; this notefield is meant to be a preview of the steps in the space allowed, not a complete 1:1 recreation of what the player will see on ScreenGameplay
              self:GetPlayerOptions("ModsLevel_Current"):FromString(PlayerModsArray):Mini(0)
            end,

            CurrentStepsP1ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
            CurrentStepsP2ChangedMessageCommand=function(self) self:playcommand("Refresh") end,
            --we don't need to use a messagecommand to refresh when switching from Single to Double style because the whole screen refreshes anyway
            OptionsListStartMessageCommand=function(self) self:playcommand("Refresh") end,

            RefreshCommand=function(self)
                self:AutoPlay(false)
                local ChartArray = nil

                local Song = GAMESTATE:GetCurrentSong()
                if Song then ChartArray = Song:GetAllSteps() else return end
                local PlayerModsArray = GAMESTATE:GetPlayerState(pnNoteField):GetPlayerOptionsString("ModsLevel_Preferred")
                --force Mini% to 0 here because it throws off the notefield positioning; this notefield is meant to be a preview of the steps in the space allowed, not a complete 1:1 recreation of what the player will see on ScreenGameplay
                self:GetPlayerOptions("ModsLevel_Current"):FromString(PlayerModsArray):Mini(0)

                local ChartIndex = GetCurrentChartIndex(pnNoteField, ChartArray)
                if not ChartIndex then return end

                local NoteData = Song:GetNoteData(ChartIndex)
                if not NoteData then return end

                self:SetNoteDataFromLua({})
                --SCREENMAN:SystemMessage("Loading ChartIndex!")
                self:SetNoteDataFromLua(NoteData)
                self:AutoPlay(true)
            end
        }
    }
    end
end

return t
