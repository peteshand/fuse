package mantle.managers.replay;

import openfl.display.Stage;
import openfl.events.MouseEvent;


/**
 * ...
 * @author P.J.Shand
 */
class InstantReplayObject
{
	private var currentActions:FrameActions;
	public var frames = new Array<FrameActions>();
	public var totalFrames(get, null):Int;
	@:isVar public var recording(default, set):Bool;
	
	public function new()
	{
		currentActions = new FrameActions();
	}
	
	private function OnMouseEvent(e:MouseEvent):Void 
	{
		var mouseEventData:MouseEventData = new MouseEventData();
		mouseEventData.add(e);
		currentActions.mouseEvents.push(mouseEventData);
	}
	
	public function dispose():Void 
	{
		for (i in 0...frames.length) 
		{
			frames[i].dispose();
		}
		frames = null;
		currentActions = null;
		InstantReplay.stage.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouseEvent);
	}
	
	public function record(frameIndex:Int):Void 
	{
		frames[frameIndex] = currentActions;
		currentActions = new FrameActions();
	}
	
	public function play(frameIndex:Int):Void 
	{
		if (frames.length == 0) return;
		var len:Int = frames[frameIndex].mouseEvents.length;
		for (i in 0...len) 
		{
			if (frames.length > i) {
				var e:MouseEventData = frames[frameIndex].mouseEvents[i];
				var mouseEvent:MouseEvent = new MouseEvent(e.type, e.bubbles, e.cancelable, e.localX, e.localY, null, e.ctrlKey, e.altKey, e.shiftKey, e.buttonDown, e.delta, e.commandKey, e.clickCount);
				InstantReplay.stage.dispatchEvent(mouseEvent);
			}
		}
		
	}
	
	public function clear():Void 
	{
		for (i in 0...frames.length) 
		{
			frames[i].dispose();
		}
		frames = new Array<FrameActions>();
	}
	
	function get_totalFrames():Int 
	{
		return frames.length;
	}
	
	function set_recording(value:Bool):Bool 
	{
		if(recording == value) return value;
		recording = value;
		
		if(value){
			InstantReplay.stage.addEventListener(MouseEvent.CLICK, OnMouseEvent);
			InstantReplay.stage.addEventListener(MouseEvent.DOUBLE_CLICK, OnMouseEvent);
			InstantReplay.stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseEvent);
			InstantReplay.stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseEvent);
			InstantReplay.stage.addEventListener(MouseEvent.MOUSE_OUT, OnMouseEvent);
			InstantReplay.stage.addEventListener(MouseEvent.MOUSE_OVER, OnMouseEvent);
			InstantReplay.stage.addEventListener(MouseEvent.MOUSE_UP, OnMouseEvent);
			InstantReplay.stage.addEventListener(MouseEvent.MOUSE_WHEEL, OnMouseEvent);
			InstantReplay.stage.addEventListener(MouseEvent.ROLL_OUT, OnMouseEvent);
			InstantReplay.stage.addEventListener(MouseEvent.ROLL_OVER, OnMouseEvent);
		}else{
			InstantReplay.stage.removeEventListener(MouseEvent.CLICK, OnMouseEvent);
			InstantReplay.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, OnMouseEvent);
			InstantReplay.stage.removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseEvent);
			InstantReplay.stage.removeEventListener(MouseEvent.MOUSE_MOVE, OnMouseEvent);
			InstantReplay.stage.removeEventListener(MouseEvent.MOUSE_OUT, OnMouseEvent);
			InstantReplay.stage.removeEventListener(MouseEvent.MOUSE_OVER, OnMouseEvent);
			InstantReplay.stage.removeEventListener(MouseEvent.MOUSE_UP, OnMouseEvent);
			InstantReplay.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, OnMouseEvent);
			InstantReplay.stage.removeEventListener(MouseEvent.ROLL_OUT, OnMouseEvent);
			InstantReplay.stage.removeEventListener(MouseEvent.ROLL_OVER, OnMouseEvent);
		}
		
		return value;
	}
	
}