-- Majority of code borrowed from Mr. ThatKid and Sudospective

local NotefieldRenderBefore = 390 --THEME:GetMetric("Player","DrawDistanceBeforeTargetsPixels")
local NotefieldRenderAfter = 0 --THEME:GetMetric("Player","DrawDistanceAfterTargetsPixels")
local ReceptorPosNormal = THEME:GetMetric("Player","ReceptorArrowsYStandard")
local ReceptorPosReverse = THEME:GetMetric("Player","ReceptorArrowsYReverse")
local ReceptorOffset = ReceptorPosReverse - ReceptorPosNormal
local NotefieldY = (ReceptorPosNormal + ReceptorPosReverse) / 2

local PlayerPos = GAMESTATE:GetNumPlayersEnabled() == 1 and "OnePlayerTwoSides" or "TwoPlayersTwoSides"
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


-- to do:

--account for reverse direction with both players joined (swap the elements onscreen)
--Down+Left (on dance pad) to increase speed mod
--figure out why P2 profile is problematic for loading

for i, pn in ipairs(GAMESTATE:GetEnabledPlayers()) do
    -- To avoid crashes with player 2
    local pnNoteField = PlayerNumber:Reverse()[pn]

    t[#t+1] = Def.ActorFrame {
        Name="Player" .. ToEnumShortString(pn),
        FOV=45,
        InitCommand=function(self)
            -- self:xy(_screen.cx+293, _screen.cy-14)
            -- :zoom(SCREEN_HEIGHT / 480):visible(true)
            if pnNoteField == 0 then
              self:x(_screen.cx+293)
            elseif pnNoteField == 1 then
              self:x(_screen.cx-293)
            end

            self:y(_screen.cy-44)

            if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
              self:zoom(SCREEN_HEIGHT / 1080)
            else
              self:zoom(SCREEN_HEIGHT / 480)
            end
            self:visible(true)
        end,

        LoadFont("Common Normal")..{
            InitCommand=function(self)
              local PlayerModsArray = GAMESTATE:GetPlayerState(pnNoteField):GetPlayerOptionsString("ModsLevel_Preferred")

              self:settext(PlayerModsArray)
              -- self:settext(gsub("(,).*?(Mini,)",",",PlayerModsArray))
              self:maxwidth(200)
            end,
        },

        Def.NoteField {
            Name = "NotefieldPreview",
            Player = pnNoteField,
            NoteSkin = GAMESTATE:GetPlayerState(pnNoteField):GetPlayerOptions('ModsLevel_Preferred'):NoteSkin(),
            -- Chart = "Hard",
            DrawDistanceAfterTargetsPixels = NotefieldRenderAfter,
            DrawDistanceBeforeTargetsPixels = NotefieldRenderBefore,
            YReverseOffsetPixels = ReceptorOffset,
            FieldID=-1,
            OnCommand=function(self)
                self:ChangeReload( GAMESTATE:GetCurrentSteps(pnNoteField) )
                self:y(NotefieldY):GetPlayerOptions("ModsLevel_Current"):StealthPastReceptors(true, true)
                self:AutoPlay(true)
                --don't need to load this module for player note velocities to show up...? Disabling this module makes the arrows appear with their correct velocity based on the current speed mod selected by the player
                -- LoadModule("Player.SetSpeed.lua")(pn)
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
                --don't need to load this module for player note velocities to show up...? Disabling this module makes the arrows appear with their correct velocity based on the current speed mod selected by the player
                -- LoadModule("Player.SetSpeed.lua")(pn)
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

return t
