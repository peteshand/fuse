package fuse.core.backend.display;

import fuse.core.backend.displaylist.DisplayType;

/**
 * ...
 * @author P.J.Shand
 */
class CoreDisplayObjectContainer extends CoreInteractiveObject {
	public function new() {
		super();
		this.displayType = DisplayType.DISPLAY_OBJECT_CONTAINER;
	}
}
