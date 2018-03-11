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
	public var isStatic		:Int = 0;
	public var isMoving		:Int;
	public var isRotating	:Int;
	
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
	
	var transformData		:TransformData;
	var parentNonStatic		:Bool;
	public var combinedAlpha:Float = 1;
	public var visible:Bool = true;
	
	//public var visible(get, null):Bool;
	
	public function new() 
	{
		bounds = new Bounds();
		quadData = new QuadData();
		transformData = new TransformData();
	}
	
	public function init(objectId:Int) 
	{
		//trace("init: " + objectId);
		this.objectId = objectId;
		//trace("NEW: " + objectId);
		displayData = untyped CommsObjGen.getDisplayData(objectId);
	}
	
	//public function buildHierarchy() 
	//{
		//HierarchyAssembler.transformActions.push(calculateTransform);
		//HierarchyAssembler.transformActions.push(popTransform);
	//}
	
	function calculateTransform() 
	{
		setIsStatic();
		updateTransform();
		
	}
	
	function updateTransform() 
	{
		combinedAlpha = Graphics.alpha * displayData.alpha;
		visible = Graphics.visible && (displayData.visible == 1);
		Graphics.pushAlpha(combinedAlpha, visible);
		//trace("combinedAlpha = " + combinedAlpha);
		if (isStatic == 0) {
			
			//beginSetChildrenIsStatic(false);
			
			WorkerTransformHelper.update(this);
		}
		
		pushTransform();
	}
	
	inline function setIsStatic() 
	{
		isStatic = displayData.isStatic;
		isMoving = 0;
		isRotating = 0;
		
		if (Graphics.isStatic == 0) isStatic = 0;
		displayData.isStatic = 1; // reset static prop
		
		if (isStatic == 0) {
			Fuse.current.conductorData.isStatic = 0;
			
			isMoving = displayData.isMoving;
			if (Graphics.isMoving == 1) isMoving = 1;
			displayData.isMoving = 0;
			
			isRotating = displayData.isRotating;
			displayData.isRotating = 0;
		}
		
		if (Core.RESIZE) {
			isStatic = 0;
			isMoving = 1;
			isRotating = 1;
		}
	}
	
	inline function pushTransform() 
	{
		Graphics.pushTransformation(transformData.localTransform, isStatic, isMoving);
	}
	
	function popTransform() 
	{
		Graphics.popTransformation();
		Graphics.popAlpha();
		
		if (isStatic == 0){	
			
		}
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
	
	public function buildHierarchy2()
	{
		trace("buildHierarchy2 = " + objectId);
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
		//combinedAlpha = 1;
	}
	
	//function get_visible():Bool 
	//{
		//if (parent != null && parent.visible == false) {
			//return false;
		//}
		//else {
			//if (displayData.visible == 0) {
				//return false;
			//}
			//return true;
		//}
	//}
}