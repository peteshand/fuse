package fuse.text.textDisplay.text.control.input;

import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import fuse.text.textDisplay.events.TextDisplayEvent;
import fuse.text.textDisplay.text.TextDisplay;

@:access(fuse.text.textDisplay)
class SoftKeyboardIO {
	private var textDisplay:TextDisplay;

	private static var nativeTextField:TextField;

	var hasFocus:Bool;

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;

		if (nativeTextField == null) {
			nativeTextField = new TextField();
			nativeTextField.y = -1000000; // place off stage
			nativeTextField.type = TextFieldType.INPUT;
			nativeTextField.needsSoftKeyboard = true;
		}

		textDisplay.addEventListener(TextDisplayEvent.FOCUS_CHANGE, OnFocusChange);
	}

	private function OnFocusChange(e:TextDisplayEvent):Void {
		if (textDisplay.hasFocus == hasFocus)
			return;
		hasFocus = textDisplay.hasFocus;

		if (hasFocus) {
			Starling.current.nativeStage.addChild(nativeTextField);
			nativeTextField.requestSoftKeyboard();
		} else {
			Starling.current.nativeStage.removeChild(nativeTextField);
		}
	}
}
