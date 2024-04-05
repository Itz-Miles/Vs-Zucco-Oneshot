package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var optionShit:Array<String> = ['story_mode', 'credits', 'options'];

	var debugKeys:Array<FlxKey>;
	var lockerBG:FlxSprite;
	var light:FlxSprite;
	var escDude:FlxSprite;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();

		lockerBG = new FlxSprite(0, 0, Paths.image("wall"));
		lockerBG.antialiasing = ClientPrefs.globalAntialiasing;
		add(lockerBG);

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(200, 140 + (i * 180));
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24, true);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24, true);
			menuItem.animation.addByPrefix('click', optionShit[i] + " click", 24, false);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItems.add(menuItem);
		}

		add(menuItems);

		light = new FlxSprite(0, 0, Paths.image('light'));
		light.blend = ADD;
		add(light);

		var escDude:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('escdude'));
		escDude.updateHitbox();
		// escDude.screenCenter();
		escDude.x = 30;
		escDude.y = 440;
		escDude.scale.set(0.4, 0.4);
		escDude.alpha = 0.5;
		escDude.antialiasing = ClientPrefs.globalAntialiasing;
		add(escDude);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('ATTFShinGoProDeBold.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('ATTFShinGoProDeBold.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
		{
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if (!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2]))
			{ // It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end
		flickerLights();
		super.create();
	}

	private function flickerLights():Void
	{
		// hmm yes recursion. very lousy but will serve its purpose.
		FlxTween.tween(light, {alpha: Std.random(2) - 0.4}, Math.random(), {
			ease: FlxEase.bounceInOut,
			startDelay: 0.7,
			onComplete: function(twn:FlxTween)
			{
				flickerLights();
			}
		});
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement()
	{
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						spr.offset.set();

						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						switch (curSelected)
						{
							case 0:
								spr.offset.set(30, 60);
							case 1:
								spr.offset.set(67, 63);
							case 2:
								spr.offset.set(57, 80);
						}
						spr.animation.play('click', true);
					}
				});
				new FlxTimer().start(1.5, function(tmr:FlxTimer)
				{
					var daChoice:String = optionShit[curSelected];

					switch (daChoice)
					{
						case 'story_mode':
							selectSong();
						case 'credits':
							MusicBeatState.switchState(new CreditsState());
						case 'options':
							LoadingState.loadAndSwitchState(new options.OptionsState());
					}
				});
			}
		}
		#if desktop
		else if (FlxG.keys.anyJustPressed(debugKeys))
		{
			selectedSomethin = true;
			MusicBeatState.switchState(new MasterEditorMenu());
		}
		#end

		super.update(elapsed);
	}

	function selectSong()
	{
		// Nevermind that's stupid lmao
		try
		{
			PlayState.storyPlaylist = ['5chool-bre4k'];
			PlayState.isStoryMode = true;
			PlayState.storyDifficulty = 2;
			CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
			var diffic = CoolUtil.getDifficultyFilePath();
			if (diffic == null)
				diffic = '';

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
		}
		catch (e:Dynamic)
		{
			trace('ERROR! $e');
			return;
		}

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			LoadingState.loadAndSwitchState(new PlayState(), true);
			FreeplayState.destroyFreeplayVocals();
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
			{
				switch (curSelected)
				{
					case 0:
						spr.offset.set(36, 5);
					case 1:
						spr.offset.set(66, 5);
					case 2:
						spr.offset.set(60, 5);
				}
				spr.animation.play('selected');
			}
			else
			{
				spr.animation.play('idle');
				spr.offset.set();
			}
		});
	}
}
