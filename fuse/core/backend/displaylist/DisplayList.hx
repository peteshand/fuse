package fuse.core.backend.displaylist;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.display.CoreInteractiveObject;
import fuse.core.backend.display.CoreStage;
import fuse.core.communication.data.displayData.DisplayData;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.pool.Pool;

/**
 * ...
 * @author P.J.Shand
 */
class DisplayList
{
	public var stage:CoreDisplayObject;
	var map:Map<Int, CoreDisplayObject> = new Map<Int, CoreDisplayObject>();
	var transformDataMap:Map<Int, IDisplayData> = new Map<Int, IDisplayData>();
	
	public function new() 
	{
		
	}
	
	function addMask(objectId:Int, maskId:Int) 
	{
		var coreDisplay:CoreImage = untyped map.get(objectId);
		if (coreDisplay == null) {
			trace("displayObject much be added to the stage before it can have a mask attached to it");
			return;
		}
		var maskDisplay:CoreImage = untyped map.get(maskId);
		if (maskDisplay == null) {
			trace("mask displayObject much be added to the stage before it can be attached to a displayObject");
			return;
		}
		coreDisplay.mask = maskDisplay;
		
	}
	
	function removeMask(objectId:Int) 
	{
		var coreDisplay:CoreImage = untyped map.get(objectId);
		if (coreDisplay == null) return;
		coreDisplay.mask = null;
	}
	
	public function addChildAt(objectId:Int, displayType:Int, parentId:Int, addAtIndex:Int) 
	{
		var coreDisplay:CoreDisplayObject = getDisplayFromPool(displayType);
		coreDisplay.displayData = getDisplayData(objectId);
		coreDisplay.objectId = objectId;
		
		if (Std.is(coreDisplay, CoreImage)){
			cast(coreDisplay, CoreImage).textureId = coreDisplay.displayData.textureId;
		}
		
		var parent:CoreInteractiveObject = getParent(parentId);
		if (parent != null) {
			parent.addChildAt(coreDisplay, addAtIndex);
		}
		map.set(coreDisplay.objectId, coreDisplay);
		
		if (objectId == 0) {
			stage = coreDisplay;
		}
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
		var coreDisplay:CoreInteractiveObject = untyped map.get(objectId);
		if (coreDisplay == null) return;
		
		if (coreDisplay.parent != null) {
			coreDisplay.parent.removeChild(coreDisplay);
		}
		transformDataMap.remove(objectId);
		map.remove(objectId);
	}
	
	public function get(key:Int) 
	{
		return map.get(key);
	}
	
	function getDisplayData(objectId:Int):IDisplayData
	{
		var displayDataAccess:IDisplayData = null;
		if (!transformDataMap.exists(objectId)) {
			displayDataAccess = new DisplayData(objectId);
			transformDataMap.set(objectId, displayDataAccess);
		}
		return transformDataMap.get(objectId);
	}
}