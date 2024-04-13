# Simply Love (StepMania 5)

![Arrow Logo](https://i.imgur.com/oZmxyGo.png)

## IMPORTANT, WARNING, READ ME!:

<sup>Since many aspects of this theme incorporate OutFox-only APIs. It is recommended to stay up-to-date with the latest OutFox release. Alpha V will be released eventually as a daily driver, but as of now, Project OutFox Alpha 4 (0.4.18 LTS) or newer is recommended since Alpha V is not ready for daily use. See the OutFox blog below, and the OutFox discord channel for the latest builds.</sup>

[Click here to visit the OutFox blog](https://projectoutfox.com)

[Click here to visit the OutFox discord channel](https://discord.gg/fXSX2TaRr5)

## ScreenSelectMusic and ScreenEvaluation redesign

<sup>ScreenSelectMusic will look different depending on the aspect ratio selected in system options; this screen was completely overhauled to make room for chart previews when set to a widescreen aspect ratio. In the interest of saving space, many new features will not be supported in 4:3 aspect ratio because there simply is not enough space onscreen with older displays. This theme fully utilizes the allotted space in 16:9. It is *highly recommended* to use this theme in 16:9 aspect ratio. When you select 16:9, instead of going to ScreenSelectMusic, you'll be automatically directed to a new screen called ScreenSelectMusicWide which was created to keep the 16:9 and 4:3 aspect ratio environments completely separate from each other.</sup>

#### Chart Previews On ScreenSelectMusicWide

<sup>Chart previews is the biggest thing to happen to the post-ITG community. New rhythm games have added this feature; finally it arrives to dance games! The chart preview is powered by the new NoteField class in OutFox Alpha 4 (recommended to use Alpha 0.4.18 RC12 or newer). The chart preview will display all player mods *except* mods that add/subtract/modify steps in any way. All other visual mods such as your noteskin, speed mod, visual mods will all show up. </sup>

The screenshots below showcase the redesigned screens:

![ScreenSelectMusicWide](https://user-images.githubusercontent.com/5679966/195915023-aff6b6ef-7f92-4847-b852-c2376be46186.png)
![ScreenEvaluation common](https://user-images.githubusercontent.com/5679966/169926744-86e2eaf0-1820-45a3-9f75-75a8852856d0.png)
![Highscore Expansion (Entry)](https://i.imgur.com/G574IaR.png)

## What New Options Are Available?

New options can be found in Simply Love Options (the operator menu)
![Screen Shot 2022-05-23 at 11 31 59 AM](https://user-images.githubusercontent.com/5679966/169884308-93d41c85-c3ad-4335-ad7e-80820b815f03.png)

Change Score Vocalization in Advanced Options (after selecting a song)

![Screen Shot 2022-05-23 at 5 55 44 PM](https://user-images.githubusercontent.com/5679966/169927408-13416f01-9011-48ea-87a4-c17f2db24214.png)

✅ Expand Personal Highscore name to 9 characters (configurable in Simply Love Options)

✅ Verbose Song Folder: Display "Song Folder" or "Group" On SelectMusic and Evaluation
<details>
  <summary>Click to expand for details ⬇️</summary>
SongDescription on ScreenSelectMusic and TitleAndBanner on ScreenEvaluation have been reworked to show either the song folder or song group from the currently selected song. There is a preference in Simple Love Options to toggle between the two; the default is to display the song Group. This is especially useful when sorting by anything other than group in the SongWheel. The rework of ScreenEvaluation shows only the current group because I don't see a need to display the exact folder a song is in on Evaluation.
  </details>

✅ Option to show the Pack/Group banner instead of the default banner

<details>
  <summary>Click to expand for details ⬇️</summary>

This is configurable in Simply Love Options. When a song group (pack) has a banner, but a song does not have a banner, the song group (pack) banner will be shown. When there is no group (pack) banner, and a song does not have a banner, the default banner will be shown. The default is to show the group banner when no banner is present.

 </details>

 ## New Features And Tweaks

 ✅ Re-added vocalize score support (The selected voice will read out your score when arriving in Evaluation)
<details>
  <summary>Click to expand for details ⬇️</summary>

You'll need to download the old vocalize pack [here](https://www.mediafire.com/file/5r4lvn6gb1ghwhk/Simply_Love_Vocalize.zip/file) and place its contents in ~/Vocalize

The theme comes prepackaged with my own voice so place any other vocalization folders in the same manner as my voice pack.

 If you placed the Vocalize pack correctly, the option to select a vocalization will appear in the "Advanced Options" page in Player Options, all the way at the bottom.
 </details>

✅ Added a clock on ScreenSelectMusic in CoinMode_Home. This is useful for home players that want to keep track of the time while playing.

✅ Moved "Has Edit" graphic to outside the SongWheel on 4:3 to give more room for the SongTitle in the MusicWheel. This implementation is much cleaner. In 16:9 this graphic in the music wheel because there is adequate space.

✅ Slightly redesigned ScreenEvaluation to clean up "floating" BitmapText:
<details>
  <summary>Click to expand for details ⬇️</summary>

  - Difficulty number is now in the coloured box along with the difficulty name (beginner, expert, etc).

  - Style (single/double) string was removed from the evaluation screen because it's redundant information when there is a graphical representation of style in the top right of the screen.

  - Song credit information is now in a quad that is the same colour as the difficulty box but darkened (ligher colour in rainbow mode). The difficulty box was also widened from a square to a rectangle to better fit the difficulty name text.

  </details>
✅ New Features Enabled By ScreenSelectMusicWide

<details>
  <summary>Click to expand for details ⬇️</summary>
Completely reworked ScreenSelectMusic; this screen is no longer very lopsided in appearance with the song wheel on the right side and player elements squished on the left side. The main goal of the rework was to put all of the P1 assets on the left and P2 assets on the right.

 - ScreenSelectMusicWide is now visually balanced

 - Chart Previews enabled by the new NoteField class in OutFox

 - There is a huge amount of real estate opened up for new features on this screen.

 - There is absolutely no second guessing which information pertains to which player.

 - Intuitively, song difficulty increases from left to right.

 In a future commit, I would like to change the I/O buttons for this screen making MenuLeft/PadLeft and MenuRight/PadRight select difficulty (without needing to double tap), and MenuUp and MenuDown scroll through the SongWheel.
  </details>
 ✅ Show a profile card for players with a local profile

<details>
  <summary>Click to expand for details ⬇️</summary>

 A profile card replaces the player name and avatar in the footer of ScreenSelectMusicWide and ScreenEvaluation. The profile card shows how many quads, tri-stars, duo-stars, and single-stars a player has achieved across ALL gametypes and difficulties along with a number of cool profile stats. Guest profiles (no profile) do not have a corresponding profile card. Make sure you make a local profile for yourself (or set up USB profiles) to get the most out of this theme.

- GetTotalScoresWithGrade() is a new function in Outfox Alpha 0.4.15 that makes profile star counts possible; previously, GetTotalStepsWithTopGrade() was used, but it is incredibly inefficient and would cause the engine to hang the more songs were loaded. The popular Waterfall theme gets around this by creating its own separate highscores tables which are more efficient to parse by the engine; it's not worth creating or "borrowing" similar code from Waterfall, so instead this theme will work best where GetTotalScoresWithGrade() is supported.

- USB profiles are untested because I don't use them but probably work just fine.
   </details>

 ✅ Define default songs in ITG Mode (the same way it's done in Casual Mode) via "~/Other/ITG-Mode-DefaultSongs.txt"

<details>
  <summary>Click to expand for details ⬇️</summary>

Upstream has a feature in which you can define the default song that the song wheel will default to when no preferred song is set (in Casual Mode). This theme expands that to ITG Mode as well. If more than one default song is defined in "Other/ITG-Mode-DefaultSongs.txt", one song will be selected at random each time the music wheel is loaded (for the first song in a set) with no preferred song set. Starting a set with no preferred song set occurs when: all players are using the guest profile, no player is using a profile at all, when the last song played has been removed from an existing profile, all defined preferred songs are not found, and when loading a new profile for the first time. If one player has no preferred song, a second player with a valid preferred song will take precedence (this is the current upstream behaviour).

The file where you define these default songs is located here:
~/Other/ITG-Mode-DefaultSongs.txt

There is no official definition in the parsing function to ignore lines starting with '#', but since lines that don't point to a valid directory are ignored, it's safe to comment out lines with '#'. 

When defining a song in the aforementioned file, use a newline for each entry. Use the filesystem name for the pack/song folder exactly as it appears on the filesystem. Do not use the chart's '#TITLE', use the song's folder name to define a song.

See ~/Other/ITG-Mode-DefaultSongs.txt for examples.
   </details>
