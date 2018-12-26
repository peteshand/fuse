package mantle.time;

/**
 * ...
 * @author P.J.Shand
 */
class TimeUtils
{
	public static inline function convert(value:Float, from:TimeUnit, to:TimeUnit):Float
	{
		return value * to / from;
	}

	public static inline function milToDays(value:Float):Float
	{
		return convert(value, TimeUnit.MILLISECONDS, TimeUnit.DAYS);
		//return milToHours(value) / 24;
	}
	
	public static inline function milToHours(value:Float):Float
	{
		return convert(value, TimeUnit.MILLISECONDS, TimeUnit.HOURS);
		//return milToMinutes(value) / 60;
	}
	
	public static inline function milToMinutes(value:Float):Float
	{
		return convert(value, TimeUnit.MILLISECONDS, TimeUnit.MINUTES);
		//return milToSeconds(value) / 60;
	}
	
	public static inline function milToSeconds(value:Float):Float
	{
		return convert(value, TimeUnit.MILLISECONDS, TimeUnit.SECONDS);
		//return value / 1000;
	}
	
	
	public static inline function daysToMil(value:Float):Float
	{
		return convert(value, TimeUnit.DAYS, TimeUnit.MILLISECONDS);
		//return hoursToMil(value) * 24;
	}
	
	public static inline function hoursToMil(value:Float):Float
	{
		return convert(value, TimeUnit.HOURS, TimeUnit.MILLISECONDS);
		//return minutesToMil(value) * 60;
	}
	
	public static inline function minutesToMil(value:Float):Float
	{
		return convert(value, TimeUnit.MINUTES, TimeUnit.MILLISECONDS);
		//return secondsToMil(value) * 60;
	}
	
	public static inline function secondsToMil(value:Float):Float
	{
		return convert(value, TimeUnit.SECONDS, TimeUnit.MILLISECONDS);
		//return value * 1000;
	}
}