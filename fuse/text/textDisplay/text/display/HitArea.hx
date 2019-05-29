package fuse.text.textDisplay.text.display;

import openfl.geom.Rectangle;
import fuse.display.Quad;
import fuse.display.Sprite;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class HitArea extends Quad {
	private static inline var borderThinkness:Int = 3;

	var textDisplay:TextDisplay;

	public function new(textDisplay:TextDisplay, width:Float, height:Null<Float>) {
		if (height == null)
			height = 50;

		super(Math.floor(width), Math.floor(height));
		this.textDisplay = textDisplay;

		alpha = 0;

		textDisplay.charLayout.layoutChanged.add(onLayoutChange);
		trace("TODO: fix this");
		// textDisplay.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		onLayoutChange();
	}

	private function onAddedToStage(e:Event):Void {
		onLayoutChange();
	}

	private function onLayoutChange():Void {
		if (textDisplay.stage == null)
			return;

		var w = textDisplay.width;
		var h = textDisplay.height;
		width = (w < 10 ? 10 : w);
		height = (h < 10 ? 10 : h);
	}
}
