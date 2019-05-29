package fuse.text.textDisplay.events;

import openfl.events.Event;

class TextDisplayEvent extends Event {
	public static var SIZE_CHANGE:String = "sizeChange";
	public static var FOCUS_CHANGE:String = "focusChange";

	public function new(type:String, bubbles:Bool = false, data:Dynamic = null) {
		super(type, bubbles, data);
	}
}
