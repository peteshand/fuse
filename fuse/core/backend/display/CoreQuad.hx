package fuse.core.backend.display;

import fuse.core.backend.displaylist.DisplayType;
import fuse.core.utils.Pool;

/**
 * ...
 * @author P.J.Shand
 */
class CoreQuad extends CoreImage {
	public function new() {
		super();
		this.displayType = DisplayType.QUAD;
	}

	override public function clone():CoreDisplayObject {
		var _clone:CoreDisplayObject = Pool.quads.request();
		_clone.displayData = displayData;
		_clone.objectId = objectId;
		return _clone;
	}

	override public function recursiveReleaseToPool() {
		Pool.quads.release(this);
	}
}
