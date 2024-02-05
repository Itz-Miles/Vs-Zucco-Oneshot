package;

import flixel.FlxSprite;
import ClientPrefs;

class HealthSign extends FlxSprite
{
	public function new(xValue:Float, yValue:Float)
	{
		super(xValue, yValue);
		{
			frames = Paths.getSparrowAtlas('bar_up');
			animation.addByPrefix("signal", "up_bar", 0, false, false, ClientPrefs.downScroll);
			animation.play("signal");
			animation.pause();
			signal(1.0);
		}
	}

	/**
	 * Updates the signal, remapping the value to lights.
	 * @param value Remaps health (2.0) to frames (6). Negates 1 for frame indexing.
	 */
	public function signal(value:Float):Void
	{
		animation.curAnim.curFrame = Std.int(value * 3) - 1; // should green be starting or full health?
	}
}
