package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.sound.FlxSound;
import flixel.util.FlxGradient;

class CustomFadeTransition extends MusicBeatSubstate
{
	public static var finishCallback:Void->Void;
	public static var nextCamera:FlxCamera;

	public static var doorTransition:Bool = false;

	var isTransIn:Bool = false;
	var duration:Float = 0.5;

	var transSprite:FlxSprite;
	var transBlack:FlxSprite;
	var transGrad:FlxSprite;

	var ownCam:FlxCamera;

	// for compatibility, i will not remove duration
	public function new(duration:Float, isTransIn:Bool)
	{
		this.isTransIn = isTransIn;
		this.duration = duration;

		super();
	}

	override function create()
	{
		if (ownCam == null)
		{
			ownCam = new FlxCamera(0, 0, FlxG.width, FlxG.height);
			ownCam.bgColor.alpha = 0;
			FlxG.cameras.add(ownCam, false);
		}
		else
			ownCam = nextCamera;

		camera = ownCam;

		var doorSound:FlxSound = null;

		var width:Int = ownCam.width;
		var height:Int = ownCam.height;

		if (doorTransition)
		{
			(transSprite = new FlxSprite()).frames = Paths.getSparrowAtlas("transition");
			if (isTransIn)
			{
				transSprite.animation.addByPrefix('door', 'door opening', 24, false);
				transSprite.offset.y = -82; // random bs number i picked, but its close enuff

				doorSound = FlxG.sound.play(Paths.sound('transOpen'));
			}
			else
			{
				transSprite.animation.addByPrefix('door', 'door closing', 24, false);
				doorSound = FlxG.sound.play(Paths.sound('transClose'));
			}
			doorSound.persist = true;
			transSprite.animation.play('door');
			add(transSprite);
		}
		else
		{
			transGrad = FlxGradient.createGradientFlxSprite(1, height, (isTransIn ? [0x0, 0xFF000000] : [0xFF000000, 0x0]));
			transGrad.scale.x = width;
			transGrad.updateHitbox();
			transGrad.scrollFactor.set();
			add(transGrad);

			transBlack = new FlxSprite().makeGraphic(1, height + 400, 0xFF000000);
			transBlack.scale.x = width;
			transBlack.updateHitbox();
			transBlack.scrollFactor.set();
			add(transBlack);

			transGrad.x -= (width - FlxG.width) / 2;
			transBlack.x = transGrad.x;

			if (isTransIn)
			{
				transGrad.y = transBlack.y - transBlack.height;
				FlxTween.tween(transGrad, {y: transGrad.height + 50}, duration, {
					onComplete: function(twn:FlxTween)
					{
						close();
					},
					ease: FlxEase.linear
				});
			}
			else
			{
				transGrad.y = -transGrad.height;
				transBlack.y = transGrad.y - transBlack.height + 50;
				FlxTween.tween(transGrad, {y: transGrad.height + 50}, duration, {
					onComplete: function(twn:FlxTween)
					{
						if (finishCallback != null)
						{
							finishCallback();
						}
					},
					ease: FlxEase.linear
				});
			}
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (doorTransition)
		{
			super.update(elapsed);

			transSprite.screenCenter();

			if (transSprite.animation.finished)
			{
				close();
				if (finishCallback != null)
					finishCallback();
				finishCallback = null;
			}
		}
		else
		{
			if (isTransIn)
				transBlack.y = transGrad.y + transGrad.height;
			else
				transBlack.y = transGrad.y - transBlack.height;

			super.update(elapsed);

			if (isTransIn)
				transBlack.y = transGrad.y + transGrad.height;
			else
				transBlack.y = transGrad.y - transBlack.height;
		}
	}

	override function destroy()
	{
		FlxG.cameras.remove(ownCam, true);

		super.destroy();
	}
}
