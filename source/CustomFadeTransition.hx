package;

import flixel.util.FlxColor;
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

	public static var doorTransition:Bool = false;

	var isTransIn:Bool = false;
	var transSprite:FlxSprite;
	var duration:Float = 0.5;

	public function new(duration:Float, isTransIn:Bool)
	{
		this.duration = duration;
		this.isTransIn = isTransIn;
		super();
	}

	override function create()
	{
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		(transSprite = new FlxSprite()).frames = Paths.getSparrowAtlas("transition");
		if (isTransIn)
		{
			transSprite.animation.addByPrefix('door', 'door opening', 24, false);
			transSprite.offset.set(0, -100);
			FlxG.sound.play(Paths.sound('transOpen'));
		}
		else
		{
			transSprite.animation.addByPrefix('door', 'door closing', 24, false);
			FlxG.sound.play(Paths.sound('transClose'));
		}
		transSprite.animation.play('door');
		transSprite.animation.finishCallback = function(anim:String)
		{
			close();
			if (finishCallback != null)
				finishCallback();
			finishCallback = null;
		};
		transSprite.scrollFactor.set();
		transSprite.screenCenter();
		add(transSprite);

		super.create();
	}
}
