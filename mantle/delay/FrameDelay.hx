package mantle.delay;

import haxe.Constraints.Function;
import mantle.util.func.FunctionUtil;
/**
 * ...
 * @author P.J.Shand
 */
class FrameDelay implements IDelayObject
{
	public var callback:Function;
	public var complete(get, null):Bool;
	var params:Array<Dynamic>;
	var frames:Int;
	var count:Int = 0;
	
	public function new(frames:Int, callback:Function, params:Array<Dynamic>=null) 
	{
		this.frames = frames;
		this.callback = callback;
		this.params = params;
	}
	
	function get_complete():Bool 
	{
		if (count++ >= frames) return true;
		return false;
	}
	
	public function dispatch():Void
	{
		FunctionUtil.dispatch(callback, params); 
	}
}