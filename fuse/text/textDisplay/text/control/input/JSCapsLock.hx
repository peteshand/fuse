package fuse.text.textDisplay.text.control.input;

import js.Browser;
import js.html.Event;
import js.html.KeyboardEvent;

class JSCapsLock {
	var capsLock = false;
	var isMac:Bool;

	public function new() {
		isMac = ~/Mac/.match(Browser.navigator.platform);

		if (Browser.window.addEventListener != null) {
			Browser.window.addEventListener('keypress', handleKeyPress, false);
		} else {
			Browser.document.documentElement.addEventListener('onkeypress', handleKeyPress);
		}
	}

	public function isOn():Bool {
		return capsLock;
	}

	public function check():Void {
		handleKeyPress(untyped __js__("window.event"));
	}

	function handleKeyPress(e:KeyboardEvent) {
		// ensure the event object is defined
		if (e == null)
			e = untyped __js__("window.event");
		if (e == null)
			return;

		// store the prior status of the caps lock key
		var priorCapsLock:Bool = capsLock;

		// determine the character code
		var charCode = (e.charCode != null ? e.charCode : e.keyCode);
		if (charCode == 0)
			return;

		// store whether the caps lock key is down
		if (charCode >= 97 && charCode <= 122) {
			capsLock = e.shiftKey;
		} else if (charCode >= 65 && charCode <= 90 && !(e.shiftKey && isMac)) {
			capsLock = !e.shiftKey;
		}
	}
}
