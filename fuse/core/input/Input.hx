package fuse.core.input;

import openfl.ui.MultitouchInputMode;
import openfl.ui.Multitouch;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.TouchEvent;
import openfl.events.MouseEvent;
import openfl.display.Stage;
import fuse.input.Touch;
import fuse.input.TouchType;
import fuse.core.backend.Core;
import fuse.core.messenger.MessageID;
import fuse.core.messenger.Messenger;
import fuse.utils.GcoArray;
import fuse.utils.Orientation;
/**
 * ...
 * @author P.J.Shand
 */
class Input {
	var touchData = new Map<String, Touch>();
	var activeTouchData = new Map<String, Touch>();
	//var touchDataArray = new GcoArray<Touch>();
	var touchMap = new Map<String, TouchType>();
	var mouseMap = new Map<String, TouchType>();

	public function new() {
		//trace("Multitouch.supportsTouchEvents = " + Multitouch.supportsTouchEvents);
		Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

		touchMap.set(TouchEvent.TOUCH_MOVE, TouchType.MOVE);
		touchMap.set(TouchEvent.TOUCH_BEGIN, TouchType.PRESS);
		touchMap.set(TouchEvent.TOUCH_END, TouchType.RELEASE);
		//touchMap.set(TouchEvent.TOUCH_OVER, TouchType.OVER);
		//touchMap.set(TouchEvent.TOUCH_OUT, TouchType.OUT);
		
		mouseMap.set(MouseEvent.MOUSE_MOVE, TouchType.MOVE);
		mouseMap.set(MouseEvent.MOUSE_DOWN, TouchType.PRESS);
		mouseMap.set(MouseEvent.MOUSE_UP, TouchType.RELEASE);
		//mouseMap.set(MouseEvent.MOUSE_OVER, TouchType.OVER);
		//mouseMap.set(MouseEvent.MOUSE_OUT, TouchType.OUT);
		
		var stage:Stage = Lib.current.stage;
		if (Multitouch.supportsTouchEvents) {
			stage.addEventListener(TouchEvent.TOUCH_MOVE, OnTouch, false, 100);
			stage.addEventListener(TouchEvent.TOUCH_BEGIN, OnTouch);
			stage.addEventListener(TouchEvent.TOUCH_END, OnTouch);
		}// else {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouse, false, 100);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, OnMouse);
			stage.addEventListener(MouseEvent.MOUSE_UP, OnMouse);
		//}

		stage.addEventListener(Event.MOUSE_LEAVE, OnMouseLeave);
		stage.addEventListener(Event.ENTER_FRAME, OnTick);
	}

	private function OnTick(e:Event):Void {
		for (touch in activeTouchData.iterator()){
			Fuse.current.workerSetup.addInput(touch);
		}
		activeTouchData = new Map<String, Touch>();
		/*for (i in 0...touchDataArray.length) {
			Fuse.current.workerSetup.addInput(touchDataArray[i]);
		}
		touchDataArray.clear();*/
	}

	function OnMouseXChange(value:Array<Float>) {
		// trace("OnMouseXChange: " + value);
	}

	private function OnMouseLeave(e:Event):Void {
		// OnMouse(leaveStageMouseEvent);
	}

	function OnTouch(e:TouchEvent):Void {
		if (Fuse.current.stage == null)
			return;
		var type:String = e.type;
		if (type == TouchEvent.TOUCH_END)
			type = TouchEvent.TOUCH_BEGIN; // share TOUCH_BEGIN and TOUCH_END id
		var id:String = touchMap.get(type) + "-" + e.touchPointID;
		var touch:Touch = getTouchItem(id, e.touchPointID);
		setPosition(touch, e);
		//touch.x = e.stageX + Fuse.current.stage.camera.x;
		//touch.y = e.stageY + Fuse.current.stage.camera.y;
		touch.type = touchMap.get(e.type);

		//touchDataArray.push(touch);
		activeTouchData.set(id, touch);
	}

	function OnMouse(e:MouseEvent):Void {
		if (Fuse.current.stage == null)
			return;
		var type:String = e.type;
		if (type == MouseEvent.MOUSE_UP)
			type = MouseEvent.MOUSE_DOWN; // share MOUSE_DOWN and MOUSE_UP id
		var id:String = mouseMap.get(type) + "-" + 0;
		var touch:Touch = getTouchItem(id, 0);
		setPosition(touch, e);
		//touch.x = e.stageX + Fuse.current.stage.camera.x;
		//touch.y = e.stageY + Fuse.current.stage.camera.y;
		touch.type = mouseMap.get(e.type);
		//touchDataArray.push(touch);
		activeTouchData.set(id, touch);
	}

	function setPosition(touch:Touch, e:InputEvent)
	{
		touch.x = e.stageX + Fuse.current.stage.camera.x;
		touch.y = e.stageY + Fuse.current.stage.camera.y;
	}

	function getTouchItem(id:String, index:Int):Touch {
		var touch:Touch = touchData.get(id);
		if (touch == null) {
			touch = {index: index};
			touchData.set(id, touch);
		}
		return touch;
	}
}


typedef InputEvent = {
	public var stageX:Float;
	public var stageY:Float;
}