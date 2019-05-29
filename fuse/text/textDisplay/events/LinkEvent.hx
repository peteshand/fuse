package fuse.text.textDisplay.events;

import openfl.events.Event;

class LinkEvent extends Event {
	static public inline var CLICK:String = "click";

	public var href:String;

	public function new(type:String, href:String, bubbles:Bool = false) {
		super(type, bubbles, null);
		this.href = href;
	}
}
