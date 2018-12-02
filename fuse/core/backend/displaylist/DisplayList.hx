package fuse.core.backend.displaylist;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.display.CoreInteractiveObject;
import fuse.core.backend.display.CoreStage;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.communication.messageData.AddMaskMsg;
import fuse.core.communication.messageData.StaticData;
import fuse.core.utils.Pool;

/**
 * ...
 * @author P.J.Shand
 */

class DisplayList
{
	public static var hierarchyBuildRequired:Bool = true;
	var hierarchyChangeCount:Int = 0;
	
	public var stage:CoreDisplayObject;
	public var map = new Map<Int, CoreDisplayObject>();
	//var transformDataMap = new Map<Int, IDisplayData>();
	
	public function new() 
	{
		
	}
	
	function visibleChange(objectId:Int, visible:Bool) 
	{
		var display:CoreDisplayObject = untyped map.get(objectId);
		if (display == null) return;
		display.visible = visible;
		hierarchyChangeCount = 0;
	}
	
	function addMask(payload:AddMaskMsg) //objectId:Int, displayType:Int, maskId:Int, maskDisplayType:Int
	{
		var display:CoreImage = untyped getDisplay(payload.objectId, payload.displayType);//map.get(objectId);
		if (display == null) {
			trace("displayObject must be added to the stage before it can have a mask attached to it");
			return;
		}
		var maskDisplay:CoreImage = untyped getDisplay(payload.maskId, payload.maskDisplayType);//map.get(maskId);
		if (maskDisplay == null) {
			trace("mask displayObject must be added to the stage before it can be attached to a displayObject");
			return;
		}
		display.setMask(maskDisplay);
		//display.mask = maskDisplay;
		hierarchyChangeCount = 0;
	}
	
	function removeMask(objectId:Int) 
	{
		var display:CoreImage = untyped map.get(objectId);
		if (display == null) return;
		display.setMask(null);
		//display.mask = null;
		hierarchyChangeCount = 0;
	}
	
	public function addChildAt(objectId:Int, displayType:Int, parentId:Int, addAtIndex:Int) 
	{
		var parent:CoreInteractiveObject = getParent(parentId);
		
		if (parent == null && objectId != 0) {
			return;
		}
		
		var display:CoreDisplayObject = getDisplay(objectId, displayType);
		display.displayType = displayType;
		display.init(objectId);
		
		if (parent != null) {
			parent.addChildAt(display, addAtIndex);
		}
		if (objectId == 0) {
			stage = display;
		}
		
		hierarchyChangeCount = 0;
	}

	public function setChildIndex(objectId:Int, displayType:Int, parentId:Int, index:Int)
	{
		var parent:CoreInteractiveObject = getParent(parentId);
		if (parent == null) return;
		var display:CoreDisplayObject = getDisplay(objectId, displayType);
		var currentIndex:Int = parent.children.indexOf(display);
		parent.children.splice(currentIndex, 1);
		parent.children.insert(index, display);
		hierarchyChangeCount = 0;
	}
	
	public function getDisplay(objectId:Int, displayType:Int):CoreDisplayObject
	{
		var display:CoreDisplayObject = map.get(objectId);
		if (display == null) {
			display = getDisplayFromPool(displayType);
			map.set(objectId, display);
		}
		return display;
	}
	
	inline function getDisplayFromPool(displayType:Int):CoreDisplayObject
	{
		switch displayType {
			case DisplayType.STAGE:				return new CoreStage();
			case DisplayType.SPRITE:			return Pool.sprites.request();
			case DisplayType.SCALE9_IMAGE:		return Pool.sprites.request();
			case DisplayType.DISPLAY_OBJECT:	return Pool.displayObjects.request();
			case DisplayType.IMAGE:				return Pool.images.request();
			case DisplayType.MOVIECLIP:			return Pool.movieclips.request();
			case DisplayType.QUAD:				return Pool.quads.request();
			default: return null;
		}
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
		
		// TODO: add dispose function that releases and removes from map
		//releaseDisplayToPool(display);
		//transformDataMap.remove(objectId);
		//map.remove(objectId);
		
		hierarchyChangeCount = 0;
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
		if (hierarchyChangeCount < 2){
			hierarchyBuildRequired = true;
			Fuse.current.conductorData.backIsStatic = 0;
		}
		else {
			hierarchyBuildRequired = false;
		}
		
		hierarchyChangeCount++;
	}
	
	public function setStatic(payload:StaticData) 
	{
		var display:CoreDisplayObject = untyped map.get(payload.objectId);
		if (display == null) return;
		
		display.updateAny = payload.updateAny;
		display.updatePosition = payload.updatePosition;
		display.updateRotation = payload.updateRotation;
		display.updateColour = payload.updateColour;
		display.updateVisible = payload.updateVisible;
		display.updateAlpha = payload.updateAlpha;
		display.updateTexture = payload.updateTexture;
		display.updateUVs = payload.updateUVs;
	}
}