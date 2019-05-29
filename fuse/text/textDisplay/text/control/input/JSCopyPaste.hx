package fuse.text.textDisplay.text.control.input;

import js.Browser;
import js.html.ClipboardEvent;
import js.html.InputElement;
import openfl.events.Event;
import delay.Delay;

@:access(fuse.text.textDisplay.TextDisplay)
class JSCopyPaste {
	@:isVar public var focusedTextDisplay(get, set):TextDisplay;

	private var _input:InputElement;
	private var input(get, null):InputElement;
	var ignoreChanges:Bool;

	public function new() {}

	function get_input():InputElement {
		if (_input == null) {
			_input = cast Browser.document.createElement("textarea");
			_input.id = "copyPaste";

			_input.style.setProperty("top", "0px");
			_input.style.setProperty("left", "0px");
			_input.style.setProperty("position", "absolute");
			_input.style.setProperty("z-index", "-1");

			var doc = Browser.document;
			var openflContent = doc.getElementById('content');
			if (openflContent == null)
				openflContent = doc.getElementById('openfl-content');
			if (openflContent == null)
				openflContent = js.Browser.document.body;
			openflContent.appendChild(_input);
		}
		return _input;
	}

	function get_focusedTextDisplay():TextDisplay {
		return focusedTextDisplay;
	}

	function set_focusedTextDisplay(value:TextDisplay):TextDisplay {
		if (focusedTextDisplay == value)
			return value;

		if (focusedTextDisplay != null) {
			input.onpaste = null;
			input.style.setProperty("display", "none");
			input.style.setProperty("visibility", "hidden");
			focusedTextDisplay.removeEventListener(Event.SELECT, OnTextSelectionChange);
		}
		focusedTextDisplay = value;

		if (focusedTextDisplay != null) {
			input.focus();
			input.onpaste = OnInputPaste;
			input.style.setProperty("display", "inline");
			input.style.setProperty("visibility", "visible");
			focusedTextDisplay.addEventListener(Event.SELECT, OnTextSelectionChange);
		}
		return value;
	}

	function OnInputPaste(e:ClipboardEvent) {
		input.value = "";
		Delay.nextFrame(pasteOnNextFrame);
	}

	function pasteOnNextFrame() {
		ignoreChanges = true;
		var newChars = input.value;
		focusedTextDisplay.replaceSelection(newChars);
		ignoreChanges = false;
		input.value = "";
	}

	private function OnTextSelectionChange(e:Event):Void {
		if (ignoreChanges)
			return;
		input.focus();
		// Tick.once(NextFrameSelectionChange.bind(focusedTextDisplay.getSelectedText()));
		Delay.nextFrame(nextFrameSelectionChange, [focusedTextDisplay.getSelectedText()]);
	}

	function nextFrameSelectionChange(value:String) {
		input.value = value;
		if (value.length > 0)
			input.select();
	}
}
