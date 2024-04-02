package;

import flixel.addons.display.FlxBackdrop;
#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];
	var descText:FlxText;
	var why:FlxSprite;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var offsetThing:Float = -475;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('gradientbg'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		why = new FlxSprite(0, 0, Paths.image('this oneshot was a disaster'));
		why.setGraphicSize(1280, 720);
		why.updateHitbox();
		why.screenCenter();
		why.antialiasing = ClientPrefs.globalAntialiasing;
		why.alpha = 0;
		add(why);

		var cinematic:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('cinematicbar'));
		cinematic.setGraphicSize(Std.int(bg.width * 1.175));
		cinematic.updateHitbox();
		cinematic.screenCenter();
		cinematic.antialiasing = ClientPrefs.globalAntialiasing;
		add(cinematic);

		var checker:FlxBackdrop = new FlxBackdrop(Paths.image('chesslooking'), XY, 0, 0);
		checker.scrollFactor.set(0, 0.1);
		checker.y -= 80;
		checker.color = 0xFF3A4262;
		add(checker);

		checker.offset.x -= 0;
		checker.offset.y += 0;
		checker.velocity.x = 20;

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		var pisspoop:Array<Array<String>> = [
			// Name - Icon name - Description - Link - Thoughts
			['Versus Zucco'],
			[
				"Szymibymi",
				"szymi",
				"Director",
				"https://twitter.com/Szymi_bymi",
				'"WHO POSTED MY NUDES ON TWITTER.COM"'
			],
			[
				"Sewshy",
				"sewshy",
				"Co-Director",
				"https://twitter.com/Mohamed43225725",
				"are you flirting with my sister\n
				yes i am\n
				do you wanna die\n
				yes i do\n
				wait what?..\n
				take me sweet death!!!\n"
			],
			[
				"Sleepless\nPhatmann",
				"sleepling",
				"Lead Musician",
				"https://www.youtube.com/channel/UCwI905uZLMUjK2BlcAhjMxg",
				"When the.. the uh.... peak-o \nis.....     is...... \n         uh...  \npic....co......."
			],
			[
				"Ange!",
				"ange",
				"Co-Musician",
				"https://twitter.com/Angesilly",
				"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla tincidunt, nulla at semper malesuada, mauris nisi vehicula felis, vitae sodales libero est at sem. Donec quis lorem quis orci facilisis blandit."
			],
			[
				"Loof",
				"fister",
				"Lead Sound Designer",
				"https://twitter.com/MrFister4000",
				"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla tincidunt, nulla at semper malesuada, mauris nisi vehicula felis, vitae sodales libero est at sem. Donec quis lorem quis orci facilisis blandit."
			],
			[
				"Mr. Stache",
				"stache",
				"Lead Charter",
				"https://www.youtube.com/channel/UC5fK5X4_YR-NMWM9heqe9yg",
				"... \n\n\n\n\n\n\n\n\n\n\n\n   i completely forgot i even worked here"
			],
			[
				"Jackson",
				"adamko",
				"Voice Actor for Pablo",
				"https://www.youtube.com/channel/UC1c4V0sWEcpTJ_BCBah9YNA",
				"nya o o e a i o a eninio eninio unana unana hee - jackson 2024"
			],
			[
				"Mr. Salvage",
				"salvage",
				"Voice Actor for Pico",
				"https://youtube.com/@MrSalvage1?si=NMTPkVaZAnlZA67V",
				"“MOM GET OFF ME I HAVE A HARD PENIS” -Gaege Gibson"
			],
			[
				"name",
				"github",
				"role",
				"https://twitter.com",
				"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla tincidunt, nulla at semper malesuada, mauris nisi vehicula felis, vitae sodales libero est at sem. Donec quis lorem quis orci facilisis blandit."
			],
			[
				"name",
				"github",
				"role",
				"https://twitter.com",
				"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla tincidunt, nulla at semper malesuada, mauris nisi vehicula felis, vitae sodales libero est at sem. Donec quis lorem quis orci facilisis blandit."
			],
			[
				"name",
				"github",
				"role",
				"https://twitter.com",
				"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla tincidunt, nulla at semper malesuada, mauris nisi vehicula felis, vitae sodales libero est at sem. Donec quis lorem quis orci facilisis blandit."
			],
			[
				"name",
				"github",
				"role",
				"https://twitter.com",
				"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla tincidunt, nulla at semper malesuada, mauris nisi vehicula felis, vitae sodales libero est at sem. Donec quis lorem quis orci facilisis blandit."
			],
			[
				"Itz_Miles",
				"miles",
				"Lead Programmer",
				"https://twitter.com/Itz_MilesDev",
				"It all started earlier last month, when Sewshy got in touch and asked me to join. I declined at first due to lack of free time, but couldn't help myself after fixing a bug or two! I was the only dev capable of duct-taping this mess together on such short notice, but I hope it wads our collective talent into something cool you can enjoy. Miles out!"
			],
			[''],
			[''],
			['Psych Engine'],
			[
				'Shadow Mario',
				'shadowmario',
				'Main Programmer of Psych Engine',
				'https://twitter.com/Shadow_Mario_',
				'444444'
			],
			[
				'RiverOaken',
				'river',
				'Main Artist/Animator of Psych Engine',
				'https://twitter.com/RiverOaken',
				'B42F71'
			],
			[
				'shubs',
				'shubs',
				'Additional Programmer of Psych Engine',
				'https://twitter.com/yoshubs',
				'5E99DF'
			],
			[''],
			[''],
			['Contributors'],
			[
				'bb-panzu',
				'bb',
				'Ex-Programmer of Psych Engine',
				'https://twitter.com/bbsub3',
				'3E813A'
			],
			[
				'iFlicky',
				'flicky',
				'Composer of Psync and Tea Time\nMade the Dialogue Sounds',
				'https://twitter.com/flicky_i',
				'9E29CF'
			],
			[
				'SqirraRNG',
				'sqirra',
				'Crash Handler and Base code for\nChart Editor\'s Waveform',
				'https://twitter.com/gedehari',
				'E1843A'
			],
			[
				'EliteMasterEric',
				'mastereric',
				'Runtime Shaders support',
				'https://twitter.com/EliteMasterEric',
				'FFBD40'
			],
			[
				'PolybiusProxy',
				'proxy',
				'.MP4 Video Loader Library (hxCodec)',
				'https://twitter.com/polybiusproxy',
				'DCD294'
			],
			[
				'KadeDev',
				'kade',
				'Fixed some cool stuff on Chart Editor\nand other PRs',
				'https://twitter.com/kade0912',
				'64A250'
			],
			[
				'Keoiki',
				'keoiki',
				'Note Splash Animations',
				'https://twitter.com/Keoiki_',
				'D2D2D2'
			],
			[
				'Nebula the Zorua',
				'nebula',
				'LUA JIT Fork and some Lua reworks',
				'https://twitter.com/Nebula_Zorua',
				'7D40B2'
			],
			[
				'Smokey',
				'smokey',
				'Sprite Atlas Support',
				'https://twitter.com/Smokey_5_',
				'483D92'
			],
			[''],
			["Funkin' Crew"],
			[
				'ninjamuffin99',
				'ninjamuffin99',
				"Programmer of Friday Night Funkin'",
				'https://twitter.com/ninja_muffin99',
				'CF2D2D'
			],
			[
				'PhantomArcade',
				'phantomarcade',
				"Animator of Friday Night Funkin'",
				'https://twitter.com/PhantomArcade3K',
				'FADC45'
			],
			[
				'evilsk8r',
				'evilsk8r',
				"Artist of Friday Night Funkin'",
				'https://twitter.com/evilsk8r',
				'5ABD4B'
			],
			[
				'kawaisprite',
				'kawaisprite',
				"Composer of Friday Night Funkin'",
				'https://twitter.com/kawaisprite',
				'378FC7'
			]
		];

		for (i in pisspoop)
		{
			creditsStuff.push(i);
		}

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(300, 210, creditsStuff[i][0], !isSelectable);
			optionText.isMenuItem = true;
			optionText.targetY = i;
			optionText.changeX = false;
			optionText.snapToPosition();
			grpOptions.add(optionText);

			if (isSelectable)
			{
				if (creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = -icon.width;
				icon.sprTracker = optionText;

				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if (curSelected == -1)
					curSelected = i;
			}
			else
				optionText.alignment = CENTERED;
		}

		descBox = new AttachedSprite();
		descBox.setPosition(750, 245);
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.setGraphicSize(520, 490);
		descBox.updateHitbox();
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.4;
		descBox.alpha = 0.4;
		add(descBox);

		descText = new FlxText(750, 200, 500, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		changeSelection();
		super.create();
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!quitting)
		{
			if (creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if (FlxG.keys.pressed.SHIFT)
					shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(shiftMult);
					holdTime = 0;
				}

				if (controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			if (controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4))
			{
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if (colorTween != null)
				{
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}

		for (item in grpOptions.members)
		{
			if (!item.bold)
			{
				var lerpVal:Float = CoolUtil.boundTo(elapsed * 12, 0, 1);
				if (item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.x = 250;
					item.x = FlxMath.lerp(lastX, item.x + 70, lerpVal);
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200, lerpVal);
				}
			}
		}
		super.update(elapsed);
	}

	var moveTween:FlxTween = null;

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do
		{
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
			if (curSelected == 13)
				why.alpha = 1;
			else
				why.alpha = 0;
		}
		while (unselectableCheck(curSelected));

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if (!unselectableCheck(bullShit - 1))
			{
				item.alpha = 0.4;
				if (item.targetY == 0)
				{
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2] + '\n\n' + creditsStuff[curSelected][4];
		descText.y = 125 - 45;

		if (moveTween != null)
			moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y: 125}, 0.25, {ease: FlxEase.sineOut});
	}

	private function unselectableCheck(num:Int):Bool
	{
		return creditsStuff[num].length <= 1;
	}
}
