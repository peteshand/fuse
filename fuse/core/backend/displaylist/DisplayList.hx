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
@:dox(hide)
class DisplayList
{
	public var stage:CoreDisplayObject;
	var map:Map<Int, CoreDisplayObject> = new Map<Int, CoreDisplayObject>();
	var transformDataMap:Map<Int, IDisplayData> = new Map<Int, IDisplayData>();
	var unparented:Array<Unparented> = [];
	
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
		var parent:CoreInteractiveObject = getParent(parentId);
		if (parent == null && objectId != 0) {
			unparented.push({ objectId:objectId, displayType:displayType, parentId:parentId, addAtIndex:addAtIndex });
			return;
		}
		
		var coreDisplay:CoreDisplayObject = getDisplayFromPool(displayType);
		coreDisplay.displayData = getDisplayData(objectId);
		coreDisplay.objectId = objectId;
		
		if (Std.is(coreDisplay, CoreImage)){
			cast(coreDisplay, CoreImage).textureId = coreDisplay.displayData.textureId;
		}
		
		if (parent != null) {
			parent.addChildAt(coreDisplay, addAtIndex);
		}
		map.set(coreDisplay.objectId, coreDisplay);
		
		if (objectId == 0) {
			stage = coreDisplay;
		}
		
		
		var i:Int = unparented.length - 1;
		while (i >= 0) 
		{
			if (unparented[i].parentId == coreDisplay.objectId) {
				addChildAt(unparented[i].objectId, unparented[i].displayType, unparented[i].parentId, unparented[i].addAtIndex);
				unparented.splice(i, 1);
			}
			i--;
		}
		
		Core.hierarchyBuildRequired = true;
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
		var coreDisplay:CoreDisplayObject = untyped map.get(objectId);
		if (coreDisplay == null) return;
		
		if (Std.is(coreDisplay, CoreInteractiveObject)){ // NEEDS TESTING
			var coreInteractiveObject:CoreInteractiveObject = untyped coreDisplay;
			
			var j:Int = coreInteractiveObject.numChildren - 1;
			while (j >= 0) 
			{
				var child:CoreDisplayObject = coreInteractiveObject.getChildAt(j);
				removeChild(child.objectId);
				j--;
			}
		}
		
		if (coreDisplay.parent != null) {
			coreDisplay.parent.removeChild(coreDisplay);
		}
		transformDataMap.remove(objectId);
		map.remove(objectId);
		
		var i:Int = unparented.length - 1;
		while (i >= 0) 
		{
			if (unparented[i].objectId == objectId) {
				unparented.splice(i, 1);
			}
			i--;
		}
		
		Core.hierarchyBuildRequired = true;
	}
	
	public function get(key:Int) 
	{
		return map.get(key);
	}
	
	function getDisplayData(objectId:Int):IDisplayData
	{
		var displayDataAccess:IDisplayData = null;
		if (!transformDataMap.exists(objectId)) {
			//displayDataAccess = new WorkerDisplayData(objectId);
			displayDataAccess = CommsObjGen.getDisplayData(objectId);
			transformDataMap.set(objectId, displayDataAccess);
		}
		return transformDataMap.get(objectId);
	}
}

typedef Unparented =
{
	objectId:Int, 
	displayType:Int, 
	parentId:Int, 
	addAtIndex:Int
}