package fuse.text.textDisplay.text.control.input;

import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import fuse.text.textDisplay.text.TextDisplay;
import fuse.text.textDisplay.text.model.layout.Char;
import fuse.text.textDisplay.text.model.layout.CharLayout;
import fuse.text.textDisplay.text.model.selection.Selection;
import fuse.text.textDisplay.utils.SpecialChar;

class KeyboardShortcuts {
	private var _active:Null<Bool> = null;

	public var active(get, set):Null<Bool>;

	var selection:Selection;
	var textDisplay:TextDisplay;

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;
		selection = textDisplay.selection;
	}

	private function OnKeyDown(e:KeyboardEvent):Void {
		if (e.isDefaultPrevented())
			return;

		if (!e.altKey) {
			if (e.keyCode == Keyboard.LEFT && e.shiftKey == false)
				ChangeIndex(-1, e.ctrlKey);
			else if (e.keyCode == Keyboard.RIGHT && e.shiftKey == false)
				ChangeIndex(1, e.ctrlKey);
			else if (e.keyCode == Keyboard.LEFT && e.shiftKey == true)
				ChangeSelected(-1, e.ctrlKey);
			else if (e.keyCode == Keyboard.RIGHT && e.shiftKey == true)
				ChangeSelected(1, e.ctrlKey);
			else if (e.keyCode == Keyboard.UP && e.shiftKey == false)
				ChangeLine(-1);
			else if (e.keyCode == Keyboard.DOWN && e.shiftKey == false)
				ChangeLine(1);
			else if (e.keyCode == Keyboard.UP && e.shiftKey == true)
				ChangeLineSelected(-1);
			else if (e.keyCode == Keyboard.DOWN && e.shiftKey == true)
				ChangeLineSelected(1);
		}
	}

	function ChangeIndex(offset:Int, byWord:Bool) {
		if (byWord) {
			selection.index = findWordIndex(selection.index, offset);
		} else {
			if (selection.begin != null) {
				if (offset < 0)
					selection.index = selection.begin;
				else
					selection.index = selection.end;
			} else
				selection.index += offset;
		}
	}

	function findWordIndex(fromIndex:Int, offset:Int):Int {
		if (offset < 0) {
			if (textDisplay.value.charAt(fromIndex - 1) == SpecialChar.Space) {
				fromIndex--;
			}
			if (textDisplay.value.charAt(fromIndex) == SpecialChar.Space) {
				fromIndex--;
			}
			var index:Int = lastIndexOf(textDisplay.value, SpecialChar.WhiteSpace, fromIndex);
			if (index == -1) {
				return 0;
			} else {
				return index + 1;
			}
		} else {
			if (textDisplay.value.charAt(fromIndex) == SpecialChar.Space) {
				fromIndex++;
			}
			var index:Int = indexOf(textDisplay.value, SpecialChar.WhiteSpace, fromIndex);
			if (index == -1) {
				return textDisplay.value.length;
			} else {
				return index + 1;
			}
		}
	}

	inline function indexOf(str:String, chars:Array<String>, fromIndex:Int = -1) {
		var ret:Int = -1;
		for (char in chars) {
			var index:Int = str.indexOf(char, fromIndex);
			if (index == -1)
				continue;
			if (ret == -1 || ret > index)
				ret = index;
		}
		return ret;
	}

	inline function lastIndexOf(str:String, chars:Array<String>, fromIndex:Int = -1) {
		var ret:Int = -1;
		for (char in chars) {
			var index:Int = str.lastIndexOf(char, fromIndex);
			if (index == -1)
				continue;
			if (ret == -1 || ret < index)
				ret = index;
		}
		return ret;
	}

	function ChangeLine(offset:Int) {
		selection.line += offset;
	}

	function ChangeLineSelected(offset:Int) {
		var begin:Int = 0;
		var end:Int = 0;
		var index:Int = 0;

		var char:Char = textDisplay.charLayout.getCharOrEnd(selection.index);
		var newChar:Char = textDisplay.charLayout.getCharByLineAndPosX(selection.line + offset, char.x);
		if (newChar != null)
			char = newChar;
		if (selection.begin == null || selection.begin == selection.end) {
			if (selection.index > char.index) {
				begin = char.index;
				end = selection.index;
				index = begin;
			} else if (selection.index < char.index) {
				begin = selection.index;
				end = char.index;
				index = end;
			} else {
				if (offset < 0) {
					if (newChar == null)
						begin = 0;
					else
						begin = char.index;
					end = char.index;
					index = begin;
				} else {
					begin = selection.index;
					if (newChar == null)
						end = textDisplay.value.length;
					else
						end = char.index;
					index = end;
				}
			}
		} else if (selection.begin < char.index) {
			if (selection.end == selection.index) {
				begin = selection.begin;
				if (newChar == null)
					end = textDisplay.value.length;
				else
					end = char.index;
				index = end;
			} else {
				begin = selection.end;
				end = char.index;
				index = end;
			}
		} else if (selection.end > char.index) {
			if (selection.end == selection.index) {
				begin = char.index;
				end = selection.begin;
				index = begin;
			} else {
				if (newChar == null)
					begin = 0;
				else
					begin = char.index;
				end = selection.end;
				index = begin;
			}
		}
		selection.set(begin, end, index);
	}

	function ChangeSelected(offset:Int, byWord:Bool) {
		var begin:Int = 0;
		var end:Int = 0;
		var index:Int = 0;

		if (byWord) {
			offset = findWordIndex(selection.index, offset) - selection.index;
		}

		if (offset < 0) {
			if (selection.begin == null || selection.begin == selection.end) {
				begin = selection.index + offset;
				end = selection.index;
				index = begin;
			} else {
				if (selection.begin == selection.index) {
					begin = selection.begin + offset;
					end = selection.end;
					index = begin;
				} else {
					begin = selection.begin;
					end = selection.end + offset;
					index = end;
				}
			}
		} else if (offset > 0) {
			if (selection.begin == null || selection.begin == selection.end) {
				begin = selection.index;
				end = selection.index + offset;
				index = end;
			} else {
				if (selection.begin == selection.index) {
					begin = selection.begin + offset;
					end = selection.end;
					index = begin;
				} else {
					begin = selection.begin;
					end = selection.end + offset;
					index = end;
				}
			}
		}

		selection.set(begin, end, index);
	}

	function get_active():Null<Bool> {
		return _active;
	}

	function set_active(value:Null<Bool>):Null<Bool> {
		if (_active == value)
			return value;
		_active = value;

		if (_active) {
			textDisplay.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		} else {
			textDisplay.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		}

		return _active;
	}
}
