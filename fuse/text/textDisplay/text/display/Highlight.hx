package fuse.text.textDisplay.text.display;

import fuse.text.textDisplay.text.TextDisplay;
import fuse.text.textDisplay.text.model.layout.Char;
import fuse.text.textDisplay.text.model.layout.Line;
import fuse.text.textDisplay.display.Canvas;
import fuse.display.Sprite;
import openfl.events.Event;
import fuse.text.textDisplay.events.TextDisplayEvent;
import openfl.geom.Rectangle;

/**
 * ...
 * @author P.J.Shand
 */
class Highlight extends Sprite {
	static var rect:Rectangle = new Rectangle();
	static var RectPool:Array<Rectangle> = [];

	@:isVar public var highlightAlpha(get, set):Float = 0.5;
	@:isVar public var highlightColour(get, set):UInt = 0x0000FF;

	private var canvas:Canvas;
	private var textDisplay:TextDisplay;

	public function new(textDisplay:TextDisplay) {
		super();
		this.textDisplay = textDisplay;

		textDisplay.selection.addEventListener(Event.SELECT, onSelectionChange);
		textDisplay.charLayout.layoutChanged.add(onSelectionChange);
		textDisplay.addEventListener(TextDisplayEvent.FOCUS_CHANGE, onFocusChange);
	}

	private function onFocusChange(e:Event):Void {
		if (textDisplay != TextDisplay.focus) {
			if (canvas != null) {
				canvas.clear();
			}
		}
	}

	private function onSelectionChange():Void {
		updateDisplay();
	}

	public function updateDisplay() {
		if (canvas != null) {
			canvas.clear();
		}

		if (textDisplay.selection.begin == null || textDisplay.selection.begin == textDisplay.selection.end) {
			return;
		}

		var beginChar:Char = textDisplay.charLayout.getCharOrEnd(textDisplay.selection.begin);
		var endChar:Char = textDisplay.charLayout.getCharOrEnd(textDisplay.selection.end);

		if (canvas == null) {
			canvas = new Canvas();
			addChild(canvas);
		}

		var len:Int = (endChar.lineNumber - beginChar.lineNumber + 1);
		var total:Int = 0;
		var collisions:Array<Int> = [];
		for (i in 0...len) {
			var lineIndex:Int = beginChar.line.index + i;
			var line:Line = textDisplay.charLayout.getLine(lineIndex);
			if (textDisplay.maxLines != null && line.index >= textDisplay.maxLines)
				return;

			var rect:Rectangle = getRect(total);

			rect.x = line.x;
			rect.y = line.y;
			rect.width = line.boundsWidth;
			rect.height = line.height;

			if (i == 0 && i == len - 1) {
				rect.x = beginChar.x;
				rect.width = endChar.x - rect.x;
			} else if (i == 0) {
				rect.x = beginChar.x;
				rect.width = line.boundsWidth - rect.x + line.x;
			} else if (i == len - 1) {
				rect.width = endChar.x - line.x;
			}

			if (rect.width <= 0 || rect.height <= 0) {
				continue;
			}

			for (j in 0...total) {
				var otherRect:Rectangle = getRect(j);
				if (otherRect.intersects(rect)) {
					var otherInd:Null<Int> = collisions[j];
					if (otherInd == null)
						otherInd = j;
					collisions[total] = otherInd;
				}
			}
			total++;
		}

		// for(i in total)
		// {
		//     var group:Null<Int> = collisions[i];
		//     if(group == null)
		//     {
		//         var
		//         for(j in total)
		//         {

		//         }

		//     }
		// }

		canvas.beginFill(textDisplay.highlightColour, textDisplay.highlightAlpha);
		for (i in 0...total) {
			var rect:Rectangle = getRect(i);
			canvas.drawRectangle(rect.x, rect.y, rect.width, rect.height);
		}
	}

	inline function getRect(ind:Int):Rectangle {
		if (RectPool.length <= ind) {
			var ret = new Rectangle();
			RectPool[ind] = ret;
			return ret;
		} else {
			return RectPool[ind];
		}
	}

	function get_highlightAlpha():Float {
		return highlightAlpha;
	}

	function set_highlightAlpha(value:Float):Float {
		highlightAlpha = value;
		updateDisplay();
		return highlightAlpha;
	}

	function get_highlightColour():UInt {
		return highlightColour;
	}

	function set_highlightColour(value:UInt):UInt {
		highlightColour = value;
		updateDisplay();
		return highlightColour;
	}
}
