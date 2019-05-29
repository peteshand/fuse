package fuse.text.textDisplay.text.control.focus;

import fuse.text.textDisplay.events.TextDisplayEvent;
import fuse.input.Touch;
import delay.Delay;

@:access(fuse.text.textDisplay)
class ClickFocus {
	var textDisplay:TextDisplay;
	var stageListening:Bool;

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;
		textDisplay.onPress.add(onPress);
		textDisplay.addEventListener(TextDisplayEvent.FOCUS_CHANGE, onFocusChange);
	}

	private function onPress(touch:Touch):Void {
		Delay.nextFrame(setFocus);
	}

	function setFocus() {
		TextDisplay.focus = textDisplay;
	}

	function onFocusChange(e:TextDisplayEvent) {
		if (textDisplay.hasFocus) {
			if (!stageListening) {
				stageListening = true;
				textDisplay.stage.onPress.add(onStageTouch);
			}
		} else if (stageListening) {
			stageListening = false;
			textDisplay.stage.onPress.remove(onStageTouch);
		}
	}

	function onStageTouch(touch:Touch) {
		trace("TODO: FIX THIS");
		// if (e.getTouch(textDisplay) == null)
		//	TextDisplay.focus = null;
	}
}
