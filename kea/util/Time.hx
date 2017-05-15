package kea.util;

import flash.Lib;
/**
 * ...
 * @author P.J.Shand
 */
class Time
{
	// Get time since the epoch and time since the VM was started
	private static var dateTime:Float = Date.now().getTime();
	private static var dateTimestamp:UInt = flash.Lib.getTimer();
	
	public function new() 
	{
		
	}
	
	public static function getCurrentTime():Float
	{
		return dateTime + (flash.Lib.getTimer() - dateTimestamp);
	}
	
}