package fuse.core.front.input.mouse;

import fuse.core.messenger.MessageID;
import fuse.core.messenger.Messenger;
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
	var messenger:Messenger<Array<Float>>;
	var values:Array<Float> = [];
	
	public function new() 
	{
		messenger = new Messenger<Array<Float>>(MessageID.MOUSE_POSITION, Float, 2);
		messenger.listen(MessageID.MOUSE_POSITION, OnMouseXChange);
		
		//if (Fuse.current.workerSetup.numberOfWorkers == 0 || Worker.current.isPrimordial) {
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);
		//}
	}
	
	function OnMouseXChange(value:Array<Float>) 
	{
		//trace("OnMouseXChange: " + value);
	}
	
	function OnMouseMove(e:MouseEvent):Void 
	{
		values[0] = e.stageX;
		values[1] = e.stageY;
		//trace("OnMouseMove" + values);
		messenger.send(values);
	}
}