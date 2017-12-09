package fuse.core.backend.displaylist;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.display.CoreInteractiveObject;
import fuse.core.backend.display.CoreStage;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.utils.Pool;

/**
 * ...
 * @author P.J.Shand
 */

class DisplayList
{
	public static var hierarchyBuildRequired:Bool = false;
	
	public var stage:CoreDisplayObject;
	var map:Map<Int, CoreDisplayObject> = new Map<Int, CoreDisplayObject>();
	var transformDataMap:Map<Int, IDisplayData> = new Map<Int, IDisplayData>();
	
	var staticCount:Int = 0;
	
	public function new() 
	{
		
	}
	
	function addMask(objectId:Int, maskId:Int) 
	{
		var display:CoreImage = untyped map.get(objectId);
		if (display == null) {
			trace("displayObject much be added to the stage before it can have a mask attached to it");
			return;
		}
		var maskDisplay:CoreImage = untyped map.get(maskId);
		if (maskDisplay == null) {
			trace("mask displayObject much be added to the stage before it can be attached to a displayObject");
			return;
		}
		display.mask = maskDisplay;
		staticCount = 0;
	}
	
	function removeMask(objectId:Int) 
	{
		var display:CoreImage = untyped map.get(objectId);
		if (display == null) return;
		display.mask = null;
		staticCount = 0;
	}
	
	public function addChildAt(objectId:Int, displayType:Int, parentId:Int, addAtIndex:Int) 
	{
		var parent:CoreInteractiveObject = getParent(parentId);
		if (parent == null && objectId != 0) {
			return;
		}
		
		var display:CoreDisplayObject = getDisplayFromPool(displayType);
		display.displayType = displayType;
		display.init(objectId);
		
		if (parent != null) {
			parent.addChildAt(display, addAtIndex);
		}
		map.set(display.objectId, display);
		
		if (objectId == 0) {
			stage = display;
		}
		
		staticCount = 0;
	}
	
	inline function getDisplayFromPool(displayType:Int):CoreDisplayObject
	{
		if (displayType == DisplayType.STAGE)			return new CoreStage();
		if (displayType == DisplayType.SPRITE)			return Pool.sprites.request();
		if (displayType == DisplayType.DISPLAY_OBJECT)	return Pool.displayObjects.request();
		if (displayType == DisplayType.IMAGE)			return Pool.images.request();
		if (displayType == DisplayType.QUAD)			return Pool.quads.request();
		return null;
	}
	
	function getParent(parentId:Int):CoreInteractiveObject
	{
		return untyped map.get(parentId);
	}
	
	public function removeChild(objectId:Int) 
	{
		var display:CoreDisplayObject = untyped map.get(objectId);
		if (display == null) return;
		
		if (Std.is(display, CoreInteractiveObject)){ // NEEDS TESTING
			var coreInteractiveObject:CoreInteractiveObject = untyped display;
			
			var j:Int = coreInteractiveObject.numChildren - 1;
			while (j >= 0) 
			{
				var child:CoreDisplayObject = coreInteractiveObject.getChildAt(j);
				removeChild(child.objectId);
				j--;
			}
		}
		
		if (display.parent != null) {
			display.parent.removeChild(display);
		}
		
		releaseDisplayToPool(display);
		
		transformDataMap.remove(objectId);
		map.remove(objectId);
		
		staticCount = 0;
	}
	
	inline function releaseDisplayToPool(display:CoreDisplayObject)
	{
		if (display.displayType == DisplayType.SPRITE)			Pool.sprites.release(untyped display);
		if (display.displayType == DisplayType.DISPLAY_OBJECT)	Pool.displayObjects.release(untyped display);
		if (display.displayType == DisplayType.IMAGE)			Pool.images.release(untyped display);
		if (display.displayType == DisplayType.QUAD)			Pool.quads.release(untyped display);
	}
	
	public function get(key:Int) 
	{
		return map.get(key);
	}
	
	public function checkForDisplaylistChanges() 
	{
		if (staticCount <= 1){
			hierarchyBuildRequired = true;
		}
		else {
			hierarchyBuildRequired = false;
		}
		staticCount++;
	}
}