package editors;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxBasic;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import Type.ValueType;
import Controls;
import DialogueBoxPsych;
#if desktop
import Discord;
#end

using StringTools;

class EditorLua
{
	public static var Function_Stop = 1;
	public static var Function_Continue = 0;

	public function new(script:String)
	{
	}

	public function call(event:String, args:Array<Dynamic>):Dynamic
	{
		return Function_Continue;
	}

	public function set(variable:String, data:Dynamic)
	{
	}

	public function stop()
	{
	}
}
