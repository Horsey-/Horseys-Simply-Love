local af = Def.ActorFrame{
	-- GameplayReloadCheck is a kludgy global variable used in ScreenGameplay in.lua to check
	-- if ScreenGameplay is being entered "properly" or being reloaded by a scripted mod-chart.
	-- If we're here in SelectMusic, set GameplayReloadCheck to false, signifying that the next
	-- time ScreenGameplay loads, it should have a properly animated entrance.
	InitCommand=function(self)
		SL.Global.GameplayReloadCheck = false

		-- While other SM versions don't need this, Outfox resets the
		-- the music rate to 1 between songs, but we want to be using
		-- the preselected music rate.
		local songOptions = GAMESTATE:GetSongOptionsObject("ModsLevel_Preferred")
		songOptions:MusicRate(SL.Global.ActiveModifiers.MusicRate)
	end,

	--Joining a new player to ScreenSelectMusicWide is going to be janky because the best way to go about it would be to fade out the first joined player's UI
	--We'll have to then deal with the performance hit associated with having the UI be duplicated but not visible (because hidden elements are still loaded?)
	--The best option, I think, is to reload the screen entirely
	PlayerJoinedMessageCommand=function(self)
		SCREENMAN:GetTopScreen():SetNextScreenName("ScreenSelectMusicWide"):StartTransitioningScreen("SM_GoToNextScreen")
	end,

	-- ---------------------------------------------------
	--  first, load files that contain no visual elements, just code that needs to run

	-- MenuTimer code for preserving SSM's timer value when going
	-- from SSM to Player Options and then back to SSM
	LoadActor("../ScreenSelectMusic overlay/PreserveMenuTimer.lua"),
	-- Apply player modifiers from profile
	LoadActor("../ScreenSelectMusic overlay/PlayerModifiers.lua"),

	-- ---------------------------------------------------
	-- next, load visual elements; the order of these matters
	-- i.e. content in PerPlayer/Over needs to draw on top of content from PerPlayer/Under

	LoadActor("./NotefieldPreview.lua"),

	-- number of steps, jumps, holds, etc., and high scores associated with the current stepchart
	LoadActor("./PaneDisplay.lua"),

	-- Banner Art
	LoadActor("./Banner.lua"),
	-- Song's Musical Artist, BPM, Duration
	LoadActor("./SongDescription/SongDescription.lua"),

	--reorder StepsDisplayList here so that the tail for the stepartistbubble isn't covered in CourseMode
	-- The grid for the difficulty picker (normal) or CourseContentsList (CourseMode)
	LoadActor("./StepsDisplayList/default.lua"),

	-- elements we need two of (one for each player) that draw underneath the StepsDisplayList
	-- this includes the stepartist boxes, the density graph, and the cursors.
	LoadActor("./PerPlayer/default.lua"),

	-- ---------------------------------------------------
	-- finally, load the overlay used for sorting the MusicWheel (and more), hidden by default
	LoadActor("../ScreenSelectMusic overlay/SortMenu/default.lua"),
	-- a Test Input overlay can (maybe) be accessed from the SortMenu
	LoadActor("../ScreenSelectMusic overlay/TestInput.lua"),

	-- The GrooveStats leaderboard that can (maybe) be accessed from the SortMenu
	-- This is only added in "dance" mode and if the service is available.
	LoadActor("../ScreenSelectMusic overlay/Leaderboard.lua"),

	-- a yes/no prompt overlay for backing out of SelectMusic when in EventMode can be
	-- activated via "CodeEscapeFromEventMode" under [ScreenSelectMusic] in Metrics.ini
	LoadActor("../ScreenSelectMusic overlay/EscapeFromEventMode.lua"),

	LoadActor("../ScreenSelectMusic overlay/SongSearch/default.lua"),

	LoadActor("./footer.lua"),
}

return af
