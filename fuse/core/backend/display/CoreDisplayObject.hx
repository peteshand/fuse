package fuse.core.backend.display;

import fuse.core.input.TouchType;
import fuse.core.input.Touch;
import fuse.core.backend.displaylist.DisplayType;
import fuse.utils.ObjectId;
import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.backend.displaylist.Graphics;
import fuse.core.backend.util.transform.WorkerTransformHelper;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.utils.Pool;
import fuse.display.geometry.Bounds;
import fuse.display.geometry.QuadData;

/**
 * ...
 * @author P.J.Shand
 */

@:keep
@:access(fuse)
class CoreDisplayObject
{
	public var objectId		:ObjectId;
	
	public var displayData	:IDisplayData;
	public var parent		:CoreInteractiveObject;
	
	public var quadData		:QuadData;
	public var bounds		:Bounds;
	
	public var left			:Float = 0;
	public var right		:Float = 0;
	public var top			:Float = 0;
	public var bottom		:Float = 0;
	
	public var displayType	:DisplayType;
	
	//public var over:Bool = false;
	public var area(get, null):Float;
	public var diagonal(get, null):Float;

	@:isVar public var onPress(get, null):Touch;
	@:isVar public var onRelease(get, null):Touch;
	@:isVar public var onMove(get, null):Touch;
	@:isVar public var onOver(get, null):Touch;
	@:isVar public var onOut(get, null):Touch;
	
	public var transformData:TransformData;
	var parentNonStatic		:Bool;
	public var alpha:Float = 1;
	public var visible:Bool = true;
	public var hierarchyIndex:Int = -1;
	
	public var updatePosition:Bool = true;
	public var updateRotation:Bool = true;
	public var updateColour:Bool = true;
	public var updateVisible:Bool = false;
	public var updateAlpha:Bool = true;
	public var updateTexture:Bool = true;
	@:isVar public var updateAny(get, set):Bool = true;
	
	public function new() 
	{
		this.displayType = DisplayType.DISPLAY_OBJECT;
		bounds = new Bounds();
		quadData = new QuadData();
		transformData = new TransformData();
	}
	
	public function setUpdates(value:Bool) 
	{
		this.updatePosition = value;
		this.updateRotation = value;
		this.updateColour = value;
		this.updateVisible = value;
		this.updateAlpha = value;
		this.updateAny = value;
	}
	
	public function init(objectId:Int) 
	{
		this.objectId = objectId;
		displayData = untyped CommsObjGen.getDisplayData(objectId);
	}
	
	function calculateTransform() 
	{
		checkUpdates();
		updateTransform();
	}
	
	function updateTransform() 
	{
		alpha = parent.alpha * displayData.alpha;
		visible = parent.visible && (displayData.visible == 1);
		
		if (updateAny == true) {
			Fuse.current.conductorData.backIsStatic = 0;
		}
		
		if (updatePosition) {
			WorkerTransformHelper.update(this);
		}
		
		pushTransform();
	}
	
	inline function checkUpdates() 
	{
		if (Graphics.parent.updateAny) updateAny = true;
		if (updateAny){
			if (Graphics.parent.updatePosition) updatePosition = true;
			if (Graphics.parent.updateRotation) updateRotation = true;
			if (Graphics.parent.updateColour) updateColour = true;
			if (Graphics.parent.updateVisible) updateVisible = true;
			if (Graphics.parent.updateAlpha) updateAlpha = true;
			if (Graphics.parent.updateTexture) updateTexture = true;
		}
		
		if (Core.RESIZE) {
			updatePosition = true;
			updateAny = true;
		}
	}
	
	inline function pushTransform() 
	{
		Graphics.push(this);
	}
	
	function popTransform() 
	{
		Graphics.pop();
		setUpdates(false);
	}
	
	public function clone():CoreDisplayObject
	{
		var _clone:CoreDisplayObject = requestFromPool();
		_clone.displayData = displayData;
		_clone.objectId = objectId;
		return _clone;
	}
	
	public function copyTo(destination:CoreDisplayObject) 
	{
		destination.displayData = this.displayData;
		destination.objectId = this.objectId;
	}
	
	public function recursiveReleaseToPool():Void
	{
		Pool.displayObjects.release(this);
	}
	
	function requestFromPool():CoreDisplayObject
	{
		return Pool.displayObjects.request();
	}
	
	public function buildHierarchy()
	{
		
	}
	
	public function buildTransformActions()
	{
		if (this.visible) {
			hierarchyIndex = HierarchyAssembler.transformActions.length;
			HierarchyAssembler.transformActions.push(calculateTransform);
			HierarchyAssembler.transformActions.push(popTransform);
		}
	}
	
	function get_area():Float 
	{
		if (displayData == null) return 0;
		return displayData.width * displayData.height;
	}
	
	function get_diagonal():Float 
	{
		return Math.sqrt(Math.pow(quadData.topRightX - quadData.topLeftX, 2) + Math.pow(quadData.bottomLeftY - quadData.topLeftY, 2));
	}

	function get_onPress():Touch { if (onPress == null)		onPress =	{ targetId:objectId, type:TouchType.PRESS };	return onPress; }
	function get_onRelease():Touch { if (onRelease == null)	onRelease =	{ targetId:objectId, type:TouchType.RELEASE };	return onRelease; }
	function get_onMove():Touch { if (onMove == null)		onMove =	{ targetId:objectId, type:TouchType.MOVE };		return onMove; }
	function get_onOver():Touch { if (onOver == null)		onOver =	{ targetId:objectId, type:TouchType.OVER };		return onOver; }
	function get_onOut():Touch { if (onOut == null)			onOut =		{ targetId:objectId, type:TouchType.OUT };		return onOut; }
	
	public function clear():Void
	{
		//objectId = 0;
		//isStatic = 0;
		//isMoving = 1;
		//isRotating = 1;
		
		//displayData = null;
		//
		//if (displayData != null){
			//displayData.x = 0;
			//displayData.y = 0;
			//displayData.width = 0;
			//displayData.height = 0;
			//displayData.pivotX = 0;
			//displayData.pivotY = 0;
			//displayData.scaleX = 0;
			//displayData.scaleY = 0;
			//displayData.rotation = 0;
			//displayData.alpha = 0;
			//displayData.color = 0x0;
			//displayData.colorTL = 0x0;
			//displayData.colorTR = 0x0;
			//displayData.colorBL = 0x0;
			//displayData.colorBR = 0x0;
			////displayData.textureId:Int,
			//displayData.renderLayer = 0;
			//displayData.visible = 1;
			//displayData.isStatic = 0;
			//displayData.isMoving = 1;
			//displayData.isRotating = 1;
		//}
		
		//parent = null;
		
		//quadData.clear();
		//bounds.clear();
		//transformData.clear();
		//
		//left = 0;
		//right = 0;
		//top = 0;
		//bottom = 0;
		//
		//parentNonStatic = false;
		//alpha = 1;
	}
	
	function get_updateAny():Bool 
	{
		return updateAny;
	}
	
	function set_updateAny(value:Bool):Bool 
	{
		return updateAny = value;
	}
	
	public function insideBounds(x:Float, y:Float) 
	{
		// TODO: implement
		return false;
	}

	public function absoluteVis():Bool
	{
		if (visible == false) return false;

		if (parent != null) return parent.absoluteVis();

		return true;
	}
}