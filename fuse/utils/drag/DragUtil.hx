package fuse.utils.drag;

import signals.Signal;
import fuse.input.Touch;
import fuse.display.DisplayObject;
import openfl.geom.Point;

/**
 * ...
 * @author P.J.Shand
 */
class DragUtil {
	var displayObject:DisplayObject;
	var pressLoc = new Point();
	var touchStartX:Null<Float>;
	var touchStartY:Null<Float>;
	var xAxis:Bool = true;
	var yAxis:Bool = true;

	public var minX:Null<Float>;
	public var maxX:Null<Float>;
	public var minY:Null<Float>;
	public var maxY:Null<Float>;
	public var onMove = new Signal();

	public var pastThreshold:Bool;
	public var threshold:Float = 0;
	public var pressTouch:Touch;

	public function new(displayObject:DisplayObject) {
		this.displayObject = displayObject;
		displayObject.onPress.add(onPress);
	}

	public function onPress(touch:Touch) {
		pastThreshold = false;
		pressTouch = touch;
	}

	public function startDrag(xAxis:Bool = true, yAxis:Bool = true) {
		this.xAxis = xAxis;
		this.yAxis = yAxis;
		touchStartX = null;
		touchStartY = null;
		pressLoc.setTo(displayObject.x, displayObject.y);
		displayObject.stage.touchable = true;
		displayObject.stage.onMove.add(onDragMove);
		displayObject.onMove.add(onDragMove);
	}

	public function stopDrag() {
		displayObject.stage.onMove.remove(onDragMove);
		displayObject.onMove.remove(onDragMove);
	}

	function onDragMove(touch:Touch) {
		if (pressTouch != null) {
			if (pressTouch.index != touch.index)
				return;
		}

		if (touchStartX == null)
			touchStartX = touch.x;
		if (touchStartY == null)
			touchStartY = touch.y;
		if (xAxis) {
			displayObject.x = pressLoc.x + touch.x - touchStartX;
			if (minX != null && displayObject.x < minX) {
				displayObject.x = minX;
			}
			if (maxX != null && displayObject.x > maxX) {
				displayObject.x = maxX;
			}
		}
		if (yAxis) {
			displayObject.y = pressLoc.y + touch.y - touchStartY;
			if (minY != null && displayObject.y < minY) {
				displayObject.y = minY;
			}
			if (maxY != null && displayObject.y > maxY) {
				displayObject.y = maxY;
			}
		}

		if (threshold == 0) {
			pastThreshold = true;
		} else {
			if (Math.abs(touchStartX - touch.x) >= threshold)
				pastThreshold = true;
			else if (Math.abs(touchStartY - touch.y) >= threshold)
				pastThreshold = true;
		}

		if (pastThreshold) {
			onMove.dispatch();
		}
	}
}
