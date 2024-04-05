package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.addons.display.FlxBackdrop;


class FlashingState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var cinematic:FlxSprite;
	var checker:FlxSprite;
	var bg:FlxSprite = new FlxSprite();

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('gradientbg'));
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var cinematic:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('cinematicbar'));
		cinematic.setGraphicSize(Std.int(bg.width * 1.175));
		cinematic.updateHitbox();
		cinematic.screenCenter();
		cinematic.antialiasing = ClientPrefs.globalAntialiasing;
		add(cinematic);

		checker = new FlxBackdrop(Paths.image('chesslooking'), XY, 0, 0);
		checker.scrollFactor.set(0, 0.1);
		checker.y -= 80;
		checker.color = 0xFF3A4262;
		add(checker);

		checker.offset.x -= 0;
		checker.offset.y += 0;
		checker.velocity.x = 20;

		warnText = new FlxText(0, 0, FlxG.width,
			"Hey, watch out!\n
			This Mod contains some flashing lights!\n
         It can be disabled through the Options Menu!\n
			Press ESCAPE to start playing!.\n
			Enjoy The Mod!",
			32);
		warnText.setFormat(Paths.font("ATTFShinGoProDeBold.ttf"), 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			var back:Bool = controls.BACK;
			if (controls.ACCEPT || back) {
				leftState = true;
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				if(!back) {
					ClientPrefs.flashing = false;
					ClientPrefs.saveSettings();
					FlxG.sound.play(Paths.sound('selec'));
					FlxFlicker.flicker(warnText, 1, 0.1, false, true, function(flk:FlxFlicker) {
						new FlxTimer().start(0.5, function (tmr:FlxTimer) {
							MusicBeatState.switchState(new TitleState());
						});
					});
				} else {
					FlxG.sound.play(Paths.sound('selec'));
					FlxTween.tween(warnText, {y: 2000}, 2.2, {ease: FlxEase.expoInOut});
					FlxTween.tween(warnText, {alpha: 0}, 1, {
						onComplete: function (twn:FlxTween) {
							MusicBeatState.switchState(new TitleState());
						}
					});
				}
			}
		}
		super.update(elapsed);
	}

	
}
