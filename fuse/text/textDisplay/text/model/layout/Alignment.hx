package fuse.text.textDisplay.text.model.layout;

import openfl.events.Event;
import openfl.events.EventDispatcher;
import fuse.utils.Align;

/**
 * ...
 * @author P.J.Shand
 */
class Alignment extends EventDispatcher {
	private var textDisplay:TextDisplay;

	@:isVar public var hAlign(default, set):Align = Align.LEFT;
	@:isVar public var vAlign(default, set):Align = Align.TOP;

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;
		super();
	}

	function set_vAlign(value:Align):Align {
		if (value == null)
			value = Align.TOP;
		if (vAlign == value)
			return value;
		vAlign = value;
		textDisplay.markForUpdate();
		this.dispatchEvent(new Event(Event.CHANGE));
		return vAlign;
	}

	function set_hAlign(value:Align):Align {
		hAlign = value;
		textDisplay.markForUpdate();
		return hAlign;
	}
}
