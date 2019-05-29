package fuse.text.textDisplay.text.display;

import fuse.text.textDisplay.text.TextDisplay;
import fuse.display.Quad;
import openfl.events.Event;
import delay.Delay;

/**
 * ...
 * @author P.J.Shand
 */
class ClipMask extends Quad {
	var textDisplay:TextDisplay;

	public public function new(textDisplay:TextDisplay) {
		super(Math.floor(textDisplay.width), Math.floor(textDisplay.height), 0xFFFF00FF);
		this.textDisplay = textDisplay;

		textDisplay.charLayout.boundsChanged.add(updateMask);
		textDisplay.alignment.addEventListener(Event.CHANGE, updateMask);
		updateMask();
	}

	private function updateMask(e:Event):Void {
		update();
		// Tick.once(update, 2);
		Delay.nextFrame(update);
	}

	public function update():Void {
		this.width = textDisplay.targetWidth;
		this.height = textDisplay.targetHeight;

		if (textDisplay.clipOverflow
			&& (textDisplay.textBounds.width > textDisplay.width || textDisplay.textBounds.height > textDisplay.height)) {
			this.visible = true;
			textDisplay.mask = this;
		} else {
			this.visible = false;
			textDisplay.mask = null;
		}
	}
}
