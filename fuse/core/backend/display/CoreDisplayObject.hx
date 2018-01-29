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
	var combinedAlpha		:Float = 1;
	
	public function new() 
	{
		bounds = new Bounds();
		quadData = new QuadData();
		transformData = new TransformData();
	}
	
	public function init(objectId:Int) 
	{
		this.objectId = objectId;
		displayData = untyped CommsObjGen.getDisplayData(objectId);
	}
	
	public function buildHierarchy() 
	{
		HierarchyAssembler.transformActions.push(calculateTransform);
		HierarchyAssembler.transformActions.push(popTransform);
	}
	
	function calculateTransform() 
	{
		setIsStatic();
		updateTransform();
		
	}
	
	function updateTransform() 
	{
		if (isStatic == 0) {
			//beginSetChildrenIsStatic(false);
			combinedAlpha = Graphics.alpha * displayData.alpha;
			Graphics.pushAlpha(combinedAlpha);
			WorkerTransformHelper.update(this);
		}
		
		pushTransform();
	}
	
	inline function setIsStatic() 
	{
		isStatic = displayData.isStatic;
		if (Graphics.isStatic == 0) isStatic = 0;
		else if (Core.RESIZE) isStatic = 0;
		displayData.isStatic = 1; // reset static prop
	}
	
	inline function pushTransform() 
	{
		Graphics.pushTransformation(transformData.localTransform, isStatic);
	}
	
	function popTransform() 
	{
		Graphics.popTransformation();
		
		if (isStatic == 0){	
			Graphics.popAlpha();
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
		trace("objectId = " + objectId);
	}
	
	public function buildTransformActions()
	{
		HierarchyAssembler.transformActions.push(calculateTransform);
		HierarchyAssembler.transformActions.push(popTransform);
	}
	
	function get_area():Float 
	{
		return displayData.width * displayData.height;
	}
	
	function get_diagonal():Float 
	{
		return Math.sqrt(Math.pow(quadData.topRightX - quadData.topLeftX, 2) + Math.pow(quadData.bottomLeftY - quadData.topLeftY, 2));
	}
}