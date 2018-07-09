package fuse.core.input;

import fuse.core.backend.Core;
import fuse.core.messenger.MessageID;
import fuse.core.messenger.Messenger;
import fuse.utils.GcoArray;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.MouseEvent;
//import openfl.system.Worker;

/**
 * ...
 * @author P.J.Shand
 */

class FrontMouseInput
{
	var touchData = new Map<Int, Touch>();
	var touchDataArray = new GcoArray<Touch>();
	//var leaveStageMouseEvent:MouseEvent;
	
	//var messenger:Messenger<Array<Float>>;
	//var values:Array<Float> = [];
	
	public function new() 
	{
		//leaveStageMouseEvent = new MouseEvent(MouseEvent.MOUSE_MOVE, true, false, 10000, 10000);
		//messenger = new Messenger<Array<Float>>(MessageID.MOUSE_POSITION, Float, 2);
		//messenger.listen(MessageID.MOUSE_POSITION, OnMouseXChange);
		
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouse);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouse);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, OnMouse);
		Lib.current.stage.addEventListener(Event.MOUSE_LEAVE, OnMouseLeave);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, OnTick);
		
		
	}
	
	private function OnTick(e:Event):Void 
	{
		for (i in 0...touchDataArray.length) 
		{
			Fuse.current.workerSetup.addInput(touchDataArray[i]);
		}
		touchDataArray.clear();
	}
	
	function OnMouseXChange(value:Array<Float>) 
	{
		//trace("OnMouseXChange: " + value);
	}
	
	private function OnMouseLeave(e:Event):Void 
	{
		//OnMouse(leaveStageMouseEvent);
	}
	
	function OnMouse(e:MouseEvent):Void 
	{
		if (Fuse.current.stage == null) return;
		var touch:Touch = getMouseData(0);
		touch.x = e.stageX + Fuse.current.stage.camera.x;
		touch.y = e.stageY + Fuse.current.stage.camera.y;
		touch.type = e.type;
		for (i in 0...touchDataArray.length) 
		{
			if (touchDataArray[i].index == 0) {
				touchDataArray[i] = touch;
				return;
			}
		}
		
		touchDataArray.push(touch);
		
		//values[0] = e.stageX;
		//values[1] = e.stageY;
		//trace("OnMouseMove");
		//messenger.send(values);
	}
	
	function getMouseData(index:Int):Touch
	{
		var touch:Touch = touchData.get(index);
		if (touch == null) {
			touch = { index:index };
			touchData.set(index, touch);
		}
		return touch;
	}
}

