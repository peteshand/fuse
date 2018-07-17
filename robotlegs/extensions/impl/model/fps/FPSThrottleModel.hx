package robotlegs.extensions.impl.model.fps;
import mantle.notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
@:allow(robotlegs.extensions)
class FPSThrottleModel 
{
	private var _throttling:Bool = true;
	public var throttling(get, null):Bool;
	
	public var timeout:Int = 1000;
	public var activeFPS:Int = 60;
	public var throttleFPS:Int = 4;
	
	public function new() { }	
	
	function get_throttling():Bool 
	{
		return _throttling;
	}
}