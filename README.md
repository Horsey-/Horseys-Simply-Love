# Simply Love (StepMania 5)

![Arrow Logo](https://i.imgur.com/oZmxyGo.png)

## 🤠About This Fork🐴

The goal of this fork is to improve upon the mainline Simply Love theme. The upstream maintainers are very particular in what they will accept as a pull request based on their own personal idea of what the theme should be. I take a far more progressive approach to my fork and will actively look to merge new and interesting ideas from the many forks out there. Sometimes though, my fork aims to clean up /many/ of the inconsistencies and general UI oddities that plague the mainline branch. I hope you enjoy this fork if you find that you prefer it to the mainline theme.

The new features that exist in this fork are listed below:

✅ Re-added vocalize support

 You'll need to download the old vocalize pack [here](http://www.mediafire.com/file/i8osxoy3h2ikdbj/Vocalize.zip/file) and place it in ~/Other/

 If you placed the Vocalize pack correctly, the option to select a vocalization will appear in the "Advanced Options" page in Player Options, all the way at the bottom.

✅ Display "Song Folder" or "Group" On SelectMusic and Evaluation

SongDescription on ScreenSelectMusic and TitleAndBanner on ScreenEvaluation have been reworked to show either the song folder or song group from the currently selected song. There is a preference in Simple Love Options to toggle between the two; the default is to display the song Group. This is especially useful when sorting by anything other than group in the SongWheel. The rework of ScreenEvaluation shows only the current group because I don't see a need to display the exact folder a song is in on Evaluation.

![ScreenSelectMusic Rework](https://i.imgur.com/h5TuVsy.png)
![ScreenEvaluation Rework](https://i.imgur.com/EFAy08c.png)

✅ Expand Personal Highscore name to 9 characters (configurable in Simply Love Options)
 ![Highscore Expansion (Entry)](https://i.imgur.com/G574IaR.png)
 ![Highscore Expansion (SL Options)](https://i.imgur.com/pxI4jsO.png)

 ✅ Added a clock on ScreenSelectMusic in CoinMode_Home. This is useful for home players that want to keep track of the time while playing.

 ![ScreenSelectMusic clock](https://i.imgur.com/Mhjj8qL.png)
 ![ScreenEvaluation clock](https://i.imgur.com/aNRHfFr.png)

✅ There is now a preference to display the group banner for songs that do not have a banner. This is configurable in Simply Love Options. When a song group (pack) has a banner, but a song does not have a banner, the song group (pack) banner will be shown. When there is no group (pack) banner, and a song does not have a banner, the default banner will be shown. The default is to show the group banner when no banner is present.

✅ Moved "Has Edit" graphic to outside the SongWheel to give more room for the SongTitle in the MusicWheel. This implementation is much cleaner.

![HasEdit image](https://i.imgur.com/elOjMHM.png)

✅ Slightly redesigned ScreenEvaluation to clean up "floating" BitmapText:
  *Difficulty number is now in the coloured box along with the difficulty name (beginner, expert, etc).
  *Style (single/double) string was removed from the evaluation screen because it's redundant information when there is a graphical representation of style in the top right of the screen.
  *Song credit information is now in a quad that is the same colour as the difficulty box but darkened (ligher colour in rainbow mode). The difficulty box was also widened from a square to a rectangle to better fit the difficulty name text.
![ScreenEvaluation cleanup](https://i.imgur.com/KL6WYIw.png)

## About

Simply Love is a StepMania 5 theme for the post-ITG community.

It features a clean and simple design, offers numerous data-driven features not implemented by the StepMania 5 engine, and allows the current generation of ITG fans to breathe new life into the game they've known for over a decade.

Simply Love was originally designed and implemented for a previous version of StepMania (SM3.95) by hurtpiggypig.  For more information on that version of Simply Love, check here:
https://www.youtube.com/watch?v=OtcWy5m6-CQ


## Supported Versions of StepMania

Simply Love is compatible with current releases from the official StepMania project.

**Compatible Releases**<br>
✅ [StepMania 5.0.12](https://github.com/stepmania/stepmania/releases/tag/v5.0.12)<br>
✅ [StepMania 5.1-b2](https://github.com/stepmania/stepmania/releases/tag/v5.1.0-b2)<br>
✅ [OutFox 5.3 alpha 4.12.0](https://projectoutfox.com/releases/5.3.0-alpha-4.12.0) (preliminary support)<br>

For new installations we currently recommend installing StepMania 5.1. While
5.0.12 is officially the latest stable release of StepMania, 5.1 is widely used
and an improvement over 5.0 in almost every regard. StepMania 5.3 (Outfox) is
currently in an alpha stage of development. Check it out, though. The project
is making great progress!

If you are able to compile StepMania's source code yourself, the [5_1-new branch](https://github.com/stepmania/stepmania/tree/5_1-new/) is supported.  The wiki has [instructions for compiling](https://github.com/stepmania/stepmania/wiki/Compiling-StepMania).


**Incompatible**<br>
❌ Forks of SM5 (e.g. *starworlds*)<br>
❌ Older versions of StepMania (e.g. StepMania 3.9)<br>
❌ Forks of older versions of StepMania (e.g. OpenITG, NotITG)<br>
❌ SM5.2


## Installing Simply Love

If you are upgrading from a previous version of Simply Love, fully delete the old Simply Love folder first.  **Do not merge the new folder into the old.**

You can download the current Simply Love release at the [Latest Release](https://github.com/Simply-Love/Simply-Love-SM5/releases/latest) page.

Full install instructions are in the [Installing Simply Love](./Other/Documentation/InstallingSimplyLove-README.md) README.


## Language Support

Simply Love has support for:

  * English
  * Deutsch
  * Español
  * Français
  * Italiano
  * 日本語
  * Polski
  * Português Brasileiro

The current language can be changed in Simply Love under *System Options*.


## Aspect Ratio Support

Simply Love is designed to be usable at resolutions as low as 640x480 but still look crisp and clean in HD, 2k, 4k, etc.  It supports many screen aspect ratios:

  * <strong>16:9</strong> (common)
  * <strong>16:10</strong> (Apple laptops, some LCD monitors)
  * <strong>4:3</strong> (CRT arcade monitors, older TVs)
  * <strong>21:9</strong> ("Ultrawide")

The aspect ratio can be changed under *Graphics / Sound Options*.


## Screenshots

![Title Screen](https://i.imgur.com/txGZj2Ul.png)
![Gameplay](https://i.imgur.com/6PRBIHil.png)
![twenty-one nine gameplay](https://i.imgur.com/rl6WibDl.png)
![Player Options](https://i.imgur.com/Jk5A4LTl.png)
![Evaluation](https://i.imgur.com/VamMT1Ql.png)
![Select Profile](https://i.imgur.com/1SsDc90l.png)
![Visual Themes](https://i.imgur.com/AQeRafLl.png)

Check out this imgur album for more screenshots: [http://imgur.com/a/56wDq](http://imgur.com/a/56wDq)


---

# Guides

### Installing Simply Love

[Installing Simply Love](./Other/Documentation/InstallingSimplyLove-README.md)

### Profile Avatars

[Profile Avatars](./Other/Documentation/ProfileAvatars-README.md)

### Player Options Menu

Guide by Rob Nichols:
[Player Options Menu](https://robnicholsgames.com/2020/04/13/how-to-setup-stepmania-for-modern-dance-gaming/#menus)

### Custom Songs from USB

[Custom Songs from USB](./Other/Documentation/CustomSongsFromUSB-README.md)

### Casual Mode

<p>Casual Mode was designed with public arcade machines and casual players in mind. Learn more here:</p>

[Casual Mode](./Other/Documentation/CasualMode-README.md)

### Tips for installing StepMania

[Troubleshooting StepMania](./Other/Documentation/TroubleshootingStepMania-README.md)


## Hardware Guides

### Buying a 4-Panel Dance Pad

*Dom ITG* has an excellent summary of 4-panel dance pad available in 2020:<br/>
https://www.youtube.com/watch?v=sEWj2_BNG_0

### USB Polling Issues

[USB Polling Issues](./Other/Documentation/USBPollingIssues-README.md)

### Linux for a Dedicated SM5 PC

<p>
  din maintains a Linux image for running SM5 on common arcade hardware:<br/>
  https://dinsfire.com/itgimage
</p>

<p>
  It streamlines the setup process for those who have arcade hardware and
  want to start playing as quickly as possible.
</p>
