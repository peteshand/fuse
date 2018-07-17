package mantle.managers.replay;
import openfl.display.InteractiveObject;
import openfl.events.MouseEvent;

/**
 * ...
 * @author P.J.Shand
 */
class MouseEventData
{
	public var type:String;
	public var bubbles:Bool = true;
	public var cancelable:Bool = false;
	public var localX:Float = 0;
	public var localY:Float = 0;
	//public var relatedObject:InteractiveObject = null;
	public var ctrlKey:Bool = false;
	public var altKey:Bool = false;
	public var shiftKey:Bool = false;
	public var buttonDown:Bool = false;
	public var delta:Int = 0;
	public var commandKey:Bool = false;
	public var clickCount:Int = 0;
	
	public function new() 
	{
		
	}
	
	public function add(e:MouseEvent) 
	{
		type = e.type;
		bubbles = e.bubbles;
		cancelable = e.cancelable;
		localX = e.localX;
		localY = e.localY;
		//relatedObject = null;// e.relatedObject;
		ctrlKey = e.ctrlKey;
		altKey = e.altKey;
		shiftKey = e.shiftKey;
		buttonDown = e.buttonDown;
		delta = e.delta;
		commandKey = e.commandKey;
		clickCount = e.clickCount;
	}
}