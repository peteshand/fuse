package fuse.core.assembler.hierarchy;

import fuse.core.backend.Core;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.displaylist.DisplayList;
import fuse.utils.GcoArray;

/**
	This class is called every frame and is responsible for converting the displaylist hierarchy into a flat array.
	To save on processing time, this process will only be executed if there is a change the the  displaylist hierarchy.
**/
class HierarchyAssembler {
	public static var renderIndex:Int = 0;
	public static var hierarchy = new GcoArray<CoreImage>([]);
	public static var transformActions = new GcoArray<Void->Void>([]);

	public function new() {}

	static public function build() {
		// TODO: only rebuild hierarchy when required

		if (DisplayList.hierarchyBuildRequired) {
			hierarchy.clear();
			transformActions.clear();

			HierarchyAssembler.renderIndex = 0;
			Core.displayList.stage.buildHierarchy();
			
			Core.displayList.stage.buildTransformActions();

			orderByRenderLayers(hierarchy);
		}

		if (DisplayList.movementCount == 0)
			return;
		DisplayList.movementCount = 0;

		var i:Int = 0;
		while (i < transformActions.length) {
			transformActions[i]();
			i++;
		}
	}

	static function orderByRenderLayers(displayObjects:GcoArray<CoreImage>):Void {
		var swapping = false;
		var temp:CoreImage;
		while (!swapping) {
			swapping = true;
			var i:Int = displayObjects.length - 2;
			while (i >= 0) {
				if (displayObjects[i].renderLayer > displayObjects[i + 1].renderLayer) {
					temp = displayObjects[i + 1];
					displayObjects[i + 1] = displayObjects[i];
					displayObjects[i] = temp;
					swapping = false;
				}
				i--;
			}
		}
	}
}
