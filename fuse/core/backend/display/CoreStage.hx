package fuse.core.backend.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.core.backend.util.transform.WorkerTransformHelper;
import fuse.core.utils.Calc;
import fuse.core.utils.Pool;

/**
 * ...
 * @author P.J.Shand
 */
class CoreStage extends CoreInteractiveObject {
	public function new() {
		super();
		setUpdates(false);
		this.displayType = DisplayType.STAGE;
		this.touchDisplay = this;
	}

	override public function clone():CoreDisplayObject {
		return null;
	}

	override public function recursiveReleaseToPool() {}

	override public function withinBounds(debug:Bool = false, x:Float, y:Float):Bool {
		return true;
	}

	override public function insideBounds(x:Float, y:Float) {
		return true;
	}

	override function get_alpha() {
		return displayData.alpha;
	}

	override function updateTransform() {
		visible = displayData.visible == 1;

		if (updateAny == true) {
			// trace("backIsStatic 4");
			Fuse.current.conductorData.backIsStatic = 0;
		}

		if (updatePosition) {
			WorkerTransformHelper.update(this, null);
		}

		pushTransform();
	}
}
