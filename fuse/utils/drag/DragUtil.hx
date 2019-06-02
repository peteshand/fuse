package fuse.utils.drag;

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

	public function new(displayObject:DisplayObject) {
		this.displayObject = displayObject;
	}

	public function startDrag() {
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
		if (touchStartX == null)
			touchStartX = touch.x;
		if (touchStartY == null)
			touchStartY = touch.y;
		displayObject.x = pressLoc.x + touch.x - touchStartX;
		displayObject.y = pressLoc.y + touch.y - touchStartY;
	}
}
