package fuse.utils;
import openfl.Lib;

/**
    This class is used to determine how much compute time is available at the time of executing code.
    
	@author P.J.Shand
**/
class FrameBudget
{
	static var currentTime:Float;
	static var difference:Float;
	/**
        @return Float between 0-1 specifying how much of the time budget has been spent.
		Technically a value greater than 1 can be returned, in this case it would indicate that the framerate has dropped between the target framerate.  
    **/
	public static var progress(get, null):Float;
	
	static function startFrame() 
	{
		currentTime = Lib.getTimer();
	}
	
	static function get_progress():Float 
	{
		difference = Lib.getTimer() - currentTime;
		return difference / (1000 / 60); // TODO: replace with FPS ref
	}
	
}