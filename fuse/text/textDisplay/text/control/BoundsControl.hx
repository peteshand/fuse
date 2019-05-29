package fuse.text.textDisplay.text.control;

import fuse.text.textDisplay.display.Border;
import fuse.display.Quad;
import fuse.display.Sprite;
import openfl.events.Event;

class BoundsControl extends Border {
	var textDisplay:TextDisplay;

	public var showBoundsBorder(get, set):Bool;
	public var showTextBorder(get, set):Bool;

	public function new(textDisplay:TextDisplay) {
		super();

		this.textDisplay = textDisplay;
		textDisplay.charLayout.boundsChanged.add(onLayoutChange);
	}

	function createBoundsBorder() {
		if (textDisplay.boundsBorder == null) {
			textDisplay.boundsBorder = new Border(100, 100, 0xFF0000, 1, BorderPosition.CENTER);
			textDisplay.addChild(textDisplay.boundsBorder);
			resizeBoundsBorder();
		}
	}

	function createTextBorder() {
		if (textDisplay.textBorder == null) {
			textDisplay.textBorder = new Border(100, 100, 0x00FF00, 1, BorderPosition.CENTER);
			textDisplay.addChild(textDisplay.textBorder);
			resizeTextBorder();
		}
	}

	private function onLayoutChange():Void {
		if (textDisplay.textBorder != null)
			resizeTextBorder();
		if (textDisplay.boundsBorder != null)
			resizeBoundsBorder();
	}

	function resizeBoundsBorder() {
		textDisplay.boundsBorder.width = textDisplay.actualWidth;
		textDisplay.boundsBorder.height = textDisplay.actualHeight;
	}

	function resizeTextBorder() {
		textDisplay.textBorder.x = textDisplay.textBounds.x;
		textDisplay.textBorder.y = textDisplay.textBounds.y;
		textDisplay.textBorder.width = textDisplay.textBounds.width;
		textDisplay.textBorder.height = textDisplay.textBounds.height;

		// switch(textDisplay.vAlign){
		// 	case VAlign.TOP:
		// 		textDisplay.textBorder.y = 0;

		// 	case VAlign.CENTER:
		// 		textDisplay.textBorder.y = (textDisplay.targetHeight - textDisplay.textBounds.height) / 2;

		// 	case VAlign.BOTTOM:
		// 		textDisplay.textBorder.y = (textDisplay.targetHeight - textDisplay.textBounds.height);
		// }
	}

	function get_showBoundsBorder():Bool {
		if (textDisplay.boundsBorder == null) {
			return false;
		} else {
			return textDisplay.boundsBorder.visible;
		}
	}

	function set_showBoundsBorder(value:Bool):Bool {
		if (textDisplay.boundsBorder == null) {
			if (value) {
				createBoundsBorder();
			}
		} else {
			textDisplay.boundsBorder.visible = value;
		}
		return value;
	}

	function get_showTextBorder():Bool {
		if (textDisplay.textBorder == null) {
			return false;
		} else {
			return textDisplay.textBorder.visible;
		}
	}

	function set_showTextBorder(value:Bool):Bool {
		if (textDisplay.textBorder == null) {
			if (value) {
				createTextBorder();
			}
		} else {
			textDisplay.textBorder.visible = value;
		}
		return value;
	}
}
