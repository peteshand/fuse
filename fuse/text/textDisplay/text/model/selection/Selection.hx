package fuse.text.textDisplay.text.model.selection;

import fuse.text.textDisplay.text.model.layout.Char;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import fuse.text.textDisplay.text.TextDisplay;

/**
 * ...
 * @author P.J.Shand
 */
class Selection extends EventDispatcher {
	private var textDisplay:TextDisplay;
	private var _index:Null<Int>;

	public var index(get, set):Null<Int>;

	private var _begin:Null<Int>;

	public var begin(get, set):Null<Int>;

	private var _end:Null<Int>;

	public var end(get, set):Null<Int>;
	public var line(get, set):Int;

	public function new(textDisplay:TextDisplay) {
		super();
		this.textDisplay = textDisplay;
	}

	public function set(_begin:Int, _end:Int, _index:Int) {
		if (_begin > _end) {
			var temp = _begin;
			_begin = _end;
			_end = temp;
		}
		this.begin = _begin;
		this.end = _end;

		if (_index < 0)
			_index = 0;
		if (_index > textDisplay.value.length)
			_index = textDisplay.value.length;
		this._index = _index;

		dispatchEvent(new Event(Event.SELECT));
	}

	public function clear(?avoidEvent:Bool) {
		this._index = -1;
		this.begin = null;
		this.end = null;
		if (!avoidEvent)
			dispatchEvent(new Event(Event.SELECT));
	}

	function get_index():Int {
		return _index;
	}

	function set_index(value:Int):Int {
		if (value < 0)
			value = 0;
		if (value > textDisplay.value.length)
			value = textDisplay.value.length;
		_index = value;

		this.begin = null;
		this.end = null;

		dispatchEvent(new Event(Event.SELECT));
		return _index;
	}

	function get_line():Int {
		if (index == -1)
			return -1;
		return textDisplay.charLayout.getCharOrEnd(index).lineNumber;
	}

	function set_line(value:Int):Int {
		var char:Char = textDisplay.charLayout.getCharOrEnd(index);
		var newChar:Char = textDisplay.charLayout.getCharByLineAndPosX(value, char.x);
		if (newChar != null)
			char = newChar;
		index = char.index;
		return char.lineNumber;
	}

	public function setToLine(value:Int):Void {
		var char:Char = textDisplay.charLayout.getCharOrEnd(index);
		var newChar:Char = textDisplay.charLayout.getCharByLineAndPosX(value, char.x);
		if (newChar != null)
			char = newChar;
		index = char.index;
	}

	function get_begin():Null<Int> {
		return _begin;
	}

	function set_begin(value:Null<Int>):Null<Int> {
		_begin = value;
		if (_begin < 0)
			_begin = 0;
		return _begin;
	}

	function get_end():Null<Int> {
		return _end;
	}

	function set_end(value:Null<Int>):Null<Int> {
		_end = value;
		if (_end > textDisplay.value.length)
			_end = textDisplay.value.length;
		return _end;
	}
}
