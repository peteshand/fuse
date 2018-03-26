package fuse.core.backend.display;

import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.backend.displaylist.Graphics;
import fuse.core.backend.util.transform.WorkerTransformHelper;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.utils.Pool;
import fuse.display.geometry.Bounds;
import fuse.display.geometry.QuadData;
import openfl.geom.Point;

/**
 * ...
 * @author P.J.Shand
 */

@:keep
@:access(fuse)
class CoreDisplayObject
{
	public var objectId		:Int;
	
	public var displayData	:IDisplayData;
	public var parent		:CoreInteractiveObject;
	
	public var quadData		:QuadData;
	public var bounds		:Bounds;
	
	public var left			:Float = 0;
	public var right		:Float = 0;
	public var top			:Float = 0;
	public var bottom		:Float = 0;
	
	public var displayType	:Int;
	
	//public var over:Bool = false;
	public var area(get, null):Float;
	public var diagonal(get, null):Float;
	
	public var transformData:TransformData;
	var parentNonStatic		:Bool;
	public var alpha:Float = 1;
	public var visible:Bool = true;
	
	//public var visible(get, null):Bool;
	//public var updateUVs:Bool = false;
	//public var updateTexture:Bool = false;
	//public var updateMask:Bool = false;
	//public var updateAll:Bool = true;
	public var updatePosition:Bool = true;
	public var updateRotation:Bool = true;
	public var updateColour:Bool = true;
	public var updateVisible:Bool = false;
	public var updateAlpha:Bool = true;
	public var updateTexture:Bool = true;
	public var updateAny:Bool = true;
	
	public function new() 
	{
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
		this.updateTexture = value;
		this.updateAny = value;
	}
	
	public function init(objectId:Int) 
	{
		//trace("init: " + objectId);
		this.objectId = objectId;
		//trace("NEW: " + objectId);
		displayData = untyped CommsObjGen.getDisplayData(objectId);
	}
	
	function calculateTransform() 
	{
		checkUpdates();
		updateTransform();
	}
	
	function updateTransform() 
	{
		alpha = Graphics.parent.alpha * displayData.alpha;
		visible = Graphics.parent.visible && (displayData.visible == 1);
		//Graphics.pushAlpha(alpha, visible);
		
		//trace("alpha = " + alpha);
		
		if (updateAny == true) {
			Fuse.current.conductorData.backIsStatic = 0;
		}
		
		if (updatePosition) {
			
			//beginSetChildrenIsStatic(false);
			//trace("moving");
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
	
	////////////////////////////////////////////////////////////////
	// New Assembler ///////////////////////////////////////////////
	////////////////////////////////////////////////////////////////
	
	public function buildHierarchy()
	{
		
	}
	
	public function buildTransformActions()
	{
		if (this.visible){
			HierarchyAssembler.transformActions.push(calculateTransform);
			HierarchyAssembler.transformActions.push(popTransform);
		}
	}
	
	function get_area():Float 
	{
		return displayData.width * displayData.height;
	}
	
	function get_diagonal():Float 
	{
		return Math.sqrt(Math.pow(quadData.topRightX - quadData.topLeftX, 2) + Math.pow(quadData.bottomLeftY - quadData.topLeftY, 2));
	}
	
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
}