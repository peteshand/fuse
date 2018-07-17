package mantle.time;

/**
 * ...
 * @author P.J.Shand
 */
class TimeUtils
{
	public static inline function milToDays(value:Float):Float
	{
		return milToHours(value) / 24;
	}
	
	public static inline function milToHours(value:Float):Float
	{
		return milToMinutes(value) / 60;
	}
	
	public static inline function milToMinutes(value:Float):Float
	{
		return milToSeconds(value) / 60;
	}
	
	public static inline function milToSeconds(value:Float):Float
	{
		return value / 1000;
	}
	
	
	public static inline function daysToMil(value:Float):Float
	{
		return hoursToMil(value) * 24;
	}
	
	public static inline function hoursToMil(value:Float):Float
	{
		return minutesToMil(value) * 60;
	}
	
	public static inline function minutesToMil(value:Float):Float
	{
		return secondsToMil(value) * 60;
	}
	
	public static inline function secondsToMil(value:Float):Float
	{
		return value * 1000;
	}
}