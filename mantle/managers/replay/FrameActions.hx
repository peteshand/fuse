package mantle.managers.replay;
import openfl.events.MouseEvent;

/**
 * ...
 * @author P.J.Shand
 */
class FrameActions
{
	public var mouseEvents = new Array<MouseEventData>();

	public function new() 
	{
		
	}
	
	public function dispose():Void 
	{
		mouseEvents = null;
	}
}