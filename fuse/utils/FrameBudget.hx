package fuse.utils;
import openfl.Lib;

/**
 * ...
 * @author P.J.Shand
 */
class FrameBudget
{
	static var currentTime:Float;
	static var difference:Float;
	
	public static var progress(get, null):Float;
	
	static public function startFrame() 
	{
		currentTime = Lib.getTimer();
	}
	
	static function get_progress():Float 
	{
		difference = Lib.getTimer() - currentTime;
		return difference / (1000 / 60); // TODO: replace with FPS ref
	}
	
}