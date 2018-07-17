package mantle.delay;

import haxe.Constraints.Function;
import mantle.time.EnterFrame;

/**
 * ...
 * @author P.J.Shand
 */

class Delay 
{
	private static var delayObjects:Array<IDelayObject>;
	
	static function __init__() { 
       delayObjects = new Array<IDelayObject>();
	   EnterFrame.add(OnTick);
    }
	
	static private function OnTick() 
	{
		var i:Int = 0;
		while (i < delayObjects.length) 
		{
			if (delayObjects[i].complete) {
				delayObjects[i].dispatch();
				delayObjects.splice(i, 1);
			}
			else i++;
		}
	}
	
	public function new() { }
	
	public static function nextFrame(callback:Function, params:Array<Dynamic>=null):Void
	{
		Delay.byFrames(1, callback, params);
	}
	
	public static function byFrames(frames:Int, callback:Function, params:Array<Dynamic>=null):Void 
	{
		delayObjects.push(new FrameDelay(frames, callback, params));
	}
	
	public static function byTime(duration:Float, callback:Function, params:Array<Dynamic>=null, timeUnit:TimeUnit=null, precision:Bool=false):Void 
	{
		if (timeUnit == null) timeUnit = TimeUnit.SECONDS;
		delayObjects.push(new TimeDelay(duration, callback, params, timeUnit, precision));
	}
	
	public static function killDelay(callback:Function):Void 
	{
		var i = delayObjects.length - 1;
		while (i >= 0) {
			if (delayObjects[i].callback == callback) {
				delayObjects.splice(i, 1);
			}
			i--;
		}
	}
}