package fuse.core.backend.displaylist;
import fuse.core.backend.display.CoreDisplayObject;
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
	
	public function addChildAt(objectId:Int, displayType:Int, parentId:Int, addAtIndex:Int) 
	{
		var coreDisplay:CoreDisplayObject = getDisplayFromPool(displayType);
		coreDisplay.displayData = getDisplayData(objectId);
		coreDisplay.textureId = coreDisplay.displayData.textureId;
		coreDisplay.objectId = objectId;
		
		var parent:CoreDisplayObject = getParent(parentId);
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
	
	function getParent(parentId:Int):CoreDisplayObject
	{
		return map.get(parentId);
	}
	
	public function removeChild(objectId:Int) 
	{
		var coreDisplay:CoreDisplayObject = map.get(objectId);
		if (coreDisplay == null) return;
		
		if (coreDisplay.parent != null) {
			coreDisplay.parent.removeChild(coreDisplay);
		}
		transformDataMap.remove(objectId);
		//vertexDataMap.remove(objectId);
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
			//displayDataAccess = workerComms.getSharedProperty(WorkerSharedProperties.DISPLAY + objectId);
			//displayDataAccess.endian = Endian.LITTLE_ENDIAN;
			transformDataMap.set(objectId, displayDataAccess);
		}
		return transformDataMap.get(objectId);
	}
}