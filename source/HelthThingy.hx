package;

import flixel.FlxSprite;
import flixel.math.FlxMath;
import ClientPrefs;

class HelthThingy extends FlxSprite
{
	public function new(xValue:Float, yValue:Float)
	{
		super(xValue, yValue);

		if (ClientPrefs.downScroll)
		{
			frames = Paths.getSparrowAtlas('bar_down');
			for (i in 0...6)
			{
				animation.addByIndices('${i}HP', 'down_bar', [i], "", 0, true);
			}
			animation.play("100HP", true);
		}
		else
		{
			frames = Paths.getSparrowAtlas('bar_up');
			for (i in 0...6)
			{
				animation.addByIndices('${i}HP', 'up_bar', [i], "", 0, true);
			}
			animation.play('100HP', true);
		}
	}

	public function healthUpdate():Void
	{
		if (FlxMath.roundDecimal(PlayState.instance.health % 0.4, 1) == 0)
		{
			var thingy:Float = PlayState.instance.health / 0.4;
			animation.play('${thingy}HP', true);
		}
		else
		{
			var thingAgain:Int = Math.floor(PlayState.instance.health / 0.4);
			animation.play('${thingAgain}HP', true);
		}
	}
}
