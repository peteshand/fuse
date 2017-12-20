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
	var data = new Map<Int, InputData>();
	
	var mouseMouseData = new GcoArray<InputData>();
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
		for (i in 0...mouseMouseData.length) 
		{
			Fuse.current.workerSetup.addInput(mouseMouseData[i]);
		}
		mouseMouseData.clear();
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
		var mouseData:InputData = getMouseData(0);
		mouseData.x = e.stageX;
		mouseData.y = e.stageY;
		mouseData.type = e.type;
		for (i in 0...mouseMouseData.length) 
		{
			if (mouseMouseData[i].index == 0) {
				mouseMouseData[i] = mouseData;
				return;
			}
		}
		
		mouseMouseData.push(mouseData);
		
		//values[0] = e.stageX;
		//values[1] = e.stageY;
		//trace("OnMouseMove" + values);
		//messenger.send(values);
	}
	
	function getMouseData(index:Int):InputData
	{
		var mouseData:InputData = data.get(index);
		if (mouseData == null) {
			mouseData = { index:index };
			data.set(index, mouseData);
		}
		return mouseData;
	}
}

