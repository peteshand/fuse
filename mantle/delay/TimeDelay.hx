package mantle.delay;

import haxe.Constraints.Function;
import mantle.time.TimeUtils;
import mantle.util.func.FunctionUtil;
import mantle.time.GlobalTime;
/**
 * ...
 * @author P.J.Shand
 */
class TimeDelay implements IDelayObject
{
	public var callback:Function;
	public var complete(get, null):Bool;
	var params:Array<Dynamic>;
	var startTime:Float;
	var endTime:Float;
	var millisecondsDuration:Float;
	
	public function new(duration:Float, callback:Function, params:Array<Dynamic>=null, timeUnit:TimeUnit=null, precision:Bool=false) 
	{
		this.callback = callback;
		this.params = params;
		
		if (timeUnit == TimeUnit.MILLISECONDS) millisecondsDuration = duration;
		else if (timeUnit == TimeUnit.SECONDS) millisecondsDuration = TimeUtils.secondsToMil(duration);
		else if (timeUnit == TimeUnit.MINUTES) millisecondsDuration = TimeUtils.minutesToMil(duration);
		else if (timeUnit == TimeUnit.HOURS) millisecondsDuration = TimeUtils.hoursToMil(duration);
		else if (timeUnit == TimeUnit.DAYS) millisecondsDuration = TimeUtils.daysToMil(duration);
		
		startTime = GlobalTime.nowTime();
		endTime = startTime + millisecondsDuration;
	}
	
	function get_complete():Bool 
	{
		if (GlobalTime.nowTime() >= endTime) return true;
		return false;
	}
	
	public function dispatch():Void
	{
		FunctionUtil.dispatch(callback, params); 
	}
}