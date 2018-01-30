package fuse.utils.time;
import openfl.Lib;

/**
 * ...
 * @author P.J.Shand
 */
class Time
{
	// Get time since the epoch and time since the VM was started
	private static var dateTime:Float;
	private static var dateTimestamp:UInt;
	
	static function __init__() 
	{
		dateTime = Date.now().getTime();
		dateTimestamp = Lib.getTimer();
	}
	
	/**
	 * Current time in ms
	 */ 
	public static function getCurrentTime():Float
	{
		return dateTime + (Lib.getTimer() - dateTimestamp);
	}
	
	static public function now() 
	{
		// TODO: optimize
		return Date.now();
	}
}