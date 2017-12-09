package fuse.core.assembler.hierarchy;
import fuse.core.backend.Core;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.displaylist.DisplayList;
import fuse.utils.GcoArray;
import fuse.utils.Rect;

/**
    This class is called every frame and is responsible for converting the displaylist hierarchy into a flat array.
	To save on processing time, this process will only be executed if there is a change the the  displaylist hierarchy.
**/
class HierarchyAssembler
{
	public static var hierarchy = new GcoArray<CoreImage>([]);
	public static var transformActions = new GcoArray<Void -> Void>([]);
	
	public function new() 
	{
		
	}
	
	static public function build() 
	{
		// TODO: only rebuild hierarchy when required
		
		if (DisplayList.hierarchyBuildRequired)
		{
			hierarchy.clear();
			transformActions.clear();
			
			Core.displayList.stage.buildHierarchy2();
			
			Core.displayList.stage.buildTransformActions();
			
			OrderByRenderLayers(hierarchy);
		}
		
		for (i in 0...transformActions.length) 
		{
			transformActions[i]();
		}
	}
	
	static function OrderByRenderLayers(displayObjects:GcoArray<CoreImage>):Void
	{
		var swapping = false;
		var temp:CoreImage;
		while (!swapping) {
			swapping = true;
			for (i in 0...displayObjects.length-1) {
				if (displayObjects[i].renderLayer > displayObjects[i+1].renderLayer) {
					temp = displayObjects[i+1];
					displayObjects[i+1] = displayObjects[i];
					displayObjects[i] = temp;
					swapping = false;
				}
			}
		}
	}
}