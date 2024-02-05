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
	var transGrad:FlxSprite;

	// for compatibility, i will not remove duration
	public function new(duration:Float, isTransIn:Bool)
	{
		this.isTransIn = isTransIn;
		this.duration = duration;

		super();
	}

	override function create()
	{
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]]; // if it aint broke, don't fix it

		var doorSound:FlxSound = null;

		var width:Int = FlxG.width;
		var height:Int = FlxG.height;

		if (doorTransition)
		{
			(transSprite = new FlxSprite()).frames = Paths.getSparrowAtlas("transition");
			if (isTransIn)
			{
				transSprite.animation.addByPrefix('door', 'door opening', 24, false);
				transSprite.offset.set(0, -82);

				doorSound = FlxG.sound.play(Paths.sound('transOpen'));
			}
			else
			{
				transSprite.animation.addByPrefix('door', 'door closing', 24, false);
				doorSound = FlxG.sound.play(Paths.sound('transClose'));
			}
			doorSound.persist = true;
			transSprite.scrollFactor.set();
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

			transSprite = new FlxSprite().makeGraphic(1, height + 400, 0xFF000000);
			transSprite.scale.x = width;
			transSprite.updateHitbox();
			transSprite.scrollFactor.set();
			add(transSprite);

			transGrad.x -= (width - FlxG.width) / 2;
			transSprite.x = transGrad.x;

			if (isTransIn)
			{
				transGrad.y = transSprite.y - transSprite.height;
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
				transSprite.y = transGrad.y - transSprite.height + 50;
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
				transSprite.y = transGrad.y + transGrad.height;
			else
				transSprite.y = transGrad.y - transSprite.height;

			super.update(elapsed);

			if (isTransIn)
				transSprite.y = transGrad.y + transGrad.height;
			else
				transSprite.y = transGrad.y - transSprite.height;
		}
	}
}
