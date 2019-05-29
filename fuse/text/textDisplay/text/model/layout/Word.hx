package fuse.text.textDisplay.text.model.layout;

import fuse.text.textDisplay.text.model.layout.Char;

/**
 * ...
 * @author P.J.Shand
 */
class Word {
	public var characters = new Array<Char>();
	public var begin(get, null):Char;
	public var end(get, null):Char;
	public var index:Int;

	public function new() {}

	public function containsIndex(index:Int):Bool {
		for (i in 0...characters.length) {
			if (characters[i].index == index)
				return true;
		}
		return false;
	}

	function get_begin():Char {
		return characters[0];
	}

	function get_end():Char {
		return characters[characters.length - 1];
	}
}
