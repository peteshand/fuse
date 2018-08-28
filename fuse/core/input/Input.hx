package fuse.core.input;

import openfl.ui.MultitouchInputMode;
import openfl.ui.Multitouch;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.TouchEvent;
import openfl.events.MouseEvent;
import openfl.display.Stage;
import fuse.core.backend.Core;
import fuse.core.messenger.MessageID;
import fuse.core.messenger.Messenger;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class Input {
	var touchData = new Map<String, Touch>();
	var touchDataArray = new GcoArray<Touch>();

	public function new() {
		trace("Multitouch.supportsTouchEvents = " + Multitouch.supportsTouchEvents);
		Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

		var stage:Stage = Lib.current.stage;
		if (Multitouch.supportsTouchEvents) {
			stage.addEventListener(TouchEvent.TOUCH_MOVE, OnTouch, false, 100);
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, OnTouch);
			stage.addEventListener(TouchEvent.TOUCH_END, OnTouch);
		} else {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouse, false, 100);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouse);
			stage.addEventListener(MouseEvent.MOUSE_UP, OnMouse);
		}

		stage.addEventListener(Event.MOUSE_LEAVE, OnMouseLeave);
		stage.addEventListener(Event.ENTER_FRAME, OnTick);
	}

	private function OnTick(e:Event):Void {
		for (i in 0...touchDataArray.length) {
			Fuse.current.workerSetup.addInput(touchDataArray[i]);
		}
		touchDataArray.clear();
	}

	function OnMouseXChange(value:Array<Float>) {
		// trace("OnMouseXChange: " + value);
	}

	private function OnMouseLeave(e:Event):Void {
		// OnMouse(leaveStageMouseEvent);
	}

	function OnTouch(e:TouchEvent):Void {
		trace(e.type);
		if (Fuse.current.stage == null)
			return;
		var type:String = e.type;
		if (type == TouchEvent.TOUCH_END)
			type = TouchEvent.TOUCH_BEGIN; // share TOUCH_BEGIN and TOUCH_END id
		var id:String = type + e.touchPointID;
		if (e.type == TouchEvent.TOUCH_BEGIN) {
			trace(id);
		}
		var touch:Touch = getMouseData(e.touchPointID, id);
		touch.x = e.stageX + Fuse.current.stage.camera.x;
		touch.y = e.stageY + Fuse.current.stage.camera.y;
		touch.type = e.type;

		touchDataArray.push(touch);
	}

	function OnMouse(e:MouseEvent):Void {
		if (Fuse.current.stage == null)
			return;
		var type:String = e.type;
		if (type == MouseEvent.MOUSE_UP)
			type = MouseEvent.MOUSE_DOWN; // share MOUSE_DOWN and MOUSE_UP id
		var id:String = type + 0;
		var touch:Touch = getMouseData(0, id);
		touch.x = e.stageX + Fuse.current.stage.camera.x;
		touch.y = e.stageY + Fuse.current.stage.camera.y;
		touch.type = e.type;

		touchDataArray.push(touch);
	}

	function getMouseData(index:Int, id:String):Touch {
		var touch:Touch = touchData.get(id);
		if (touch == null) {
			touch = {index: index};
			touchData.set(id, touch);
		}
		return touch;
	}
}
