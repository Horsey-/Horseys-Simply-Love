# Horsey's Simply Love (StepMania 5)

![Arrow Logo](https://i.imgur.com/oZmxyGo.png)

## IMPORTANT, WARNING, READ ME!:

This theme currently only works on OutFox Alpha 4.15 and above (0.4.15). The latest version of Outfox can be downloaded from the link below. If you would like to use this theme on any other version of SM5/OutFox, you will need to comment out the instances of GetTotalScoresWithGrade(). 

[Click here to visit the OutFox blog](https://projectoutfox.com)

## 🤠About This Fork🐴

The goal of this fork is to improve upon the mainline Simply Love theme. The upstream maintainers are very particular in what they will accept as a pull request based on their own personal idea of what the theme should be. I take a far more progressive approach to my fork and will actively look to merge new and interesting ideas from the many forks out there. Sometimes though, my fork aims to clean up /many/ of the inconsistencies and general UI oddities that plague the mainline branch. I hope you enjoy this fork if you find that you prefer it to the mainline theme.

The new features and design paradigms that exist in this fork are listed below:

## ScreenSelectMusic and ScreenEvaluation redesign

The most drastic change in this fork is the rework of ScreenSelectMusic. The screen was completely overhauled to have a different UI (and screen) depending on the aspect ratio selected in system options. In the interest of saving space, many new features will not be supported in 4:3 aspect ratio because there simply is not enough space onscreen with older displays. This theme fully utilizes the alotted space in 16:9. It is *highly recommended* to use this theme in 16:9 aspect ratio. When you select 16:9, instead of going to ScreenSelectMusic, you'll be automatically directed to a new screen called ScreenSelectMusicWide which was created to keep the 16:9 and 4:3 aspect ratio environments completely separate from each other.


The screenshots below showcase the redesigned screens:

![ScreenSelectMusicWide](https://user-images.githubusercontent.com/5679966/169926739-056a4964-71eb-4d2c-8211-55afbd2bed1f.jpg)
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

You'll need to download the old vocalize pack [here](http://www.mediafire.com/file/i8osxoy3h2ikdbj/Vocalize.zip/file) and place it in ~/Other/

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

 - There is a huge amount of real estate opened up for new features on this screen.

 - There is absolutely no second guessing which information pertains to which player.

 - Intuitively, song difficulty increases from left to right.

 In a future commit, I would like to change the I/O buttons for this screen making MenuLeft/PadLeft and MenuRight/PadRight select difficulty (without needing to double tap), and MenuUp and MenuDown scroll through the SongWheel.
  </details>
 ✅ Show a profile card for players with a local profile

<details>
  <summary>Click to expand for details ⬇️</summary>

 A profile card replaces the player name and avatar in the footer of ScreenSelectMusicWide and ScreenEvaluation. The profile card shows how many quads, tri-stars, duo-stars, and single-stars a player has achieved across ALL gametypes and difficulties along with a number of cool profile stats. Guest profiles (no profile) do not have a corresponding profile card. Make sure you make a local profile for yourself (or set up USB profiles) to get the most out of this theme.

- GetTotalScoresWithGrade() is a new function in Outfox Alpha 4 LTS that makes profile star counts possible; previously, GetTotalStepsWithTopGrade() was used, but it is incredibly inefficient and would cause Stepmania to hang the more songs were loaded. The popular Waterfall theme gets around this by creating its own separate highscores tables which are more efficient to parse by the engine.

- USB profiles are untested because I don't use them but probably work just fine.
   </details>
