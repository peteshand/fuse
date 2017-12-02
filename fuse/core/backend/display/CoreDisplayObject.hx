package fuse.core.backend.display;
import fuse.core.assembler.hierarchy.HierarchyAssembler;
import fuse.core.backend.displaylist.Graphics;
import fuse.core.backend.layerCache.groups.LayerGroup;
import fuse.core.backend.util.transform.WorkerTransformHelper;
import fuse.core.communication.data.CommsObjGen;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.utils.Pool;
import openfl.geom.Point;

/**
 * ...
 * @author P.J.Shand
 */

@:keep
@:access(fuse)
class CoreDisplayObject
{
	//@:isVar var applyPosition(get, set):Int;
	//@:isVar var applyRotation(get, set):Int;
	
	public var objectId		:Int;
	public var isStatic		:Int = 0;
	//public var x			:Float = 0;
	//public var y			:Float = 0;
	//public var width		:Float = 0;
	//public var height		:Float = 0;
	//public var pivotX		:Float = 0;
	//public var pivotY		:Float = 0;
	//public var rotation	:Float = 0;
	//public var scaleX		:Float = 0;
	//public var scaleY		:Float = 0;
	//public var alpha		:Float = 0;
	//public var visible	:Int = 1;
	
	public var displayData	:IDisplayData;
	public var parent		:CoreInteractiveObject;
	public var layerGroup	:LayerGroup;
	
	public var bottomLeftX:Float = 0;
	public var bottomLeftY:Float = 0;
	public var topLeftX:Float = 0;
	public var topLeftY:Float = 0;
	public var topRightX:Float = 0;
	public var topRightY:Float = 0;
	public var bottomRightX:Float = 0;
	public var bottomRightY:Float = 0;
	
	public var left:Float = 0;
	public var right:Float = 0;
	public var top:Float = 0;
	public var bottom:Float = 0;
	
	public var displayType	:Int;
	
	var transformData		:TransformData;
	//var staticDef			:StaticDef;
	var parentNonStatic		:Bool;
	var combinedAlpha		:Float = 1;
	
	public function new() 
	{
		//staticDef = { 
			//index:-1,
			//layerCacheRenderTarget:-1,
			//state:LayerGroupState.DRAW_TO_LAYER
		//};
		transformData = new TransformData();
	}
	
	public function init(objectId:Int) 
	{
		this.objectId = objectId;
		displayData = CommsObjGen.getDisplayData(objectId);
	}
	
	public function buildHierarchy() 
	{
		HierarchyAssembler.transformActions.push(calculateTransform);
		HierarchyAssembler.transformActions.push(popTransform);
	}
	
	function calculateTransform() 
	{
		isStatic = displayData.isStatic;
		displayData.isStatic = 1; // reset static prop
		
		if (isStatic == 0) {
			beginSetChildrenIsStatic(false);
			combinedAlpha = Graphics.alpha * displayData.alpha;
			Graphics.pushAlpha(combinedAlpha);
			WorkerTransformHelper.update(this);
		}
		
		pushTransform();
	}
	
	inline function pushTransform() 
	{
		Graphics.pushTransformation(transformData.localTransform);
		
		// Not sure if this is used anymore
		//transformData.globalTransform.setFrom(transformData.localTransform);
	}
	
	function beginSetChildrenIsStatic(value:Bool) 
	{
		// CoreInteractiveObject will override
	}
	
	function setChildrenIsStatic(value:Bool) 
	{
		if (value) {
			parentNonStatic = true;
		}
	}
	
	//function readDisplayData() 
	//{
		//if (isStatic == 0 || parentNonStatic){
			////x = displayData.x;
			////y = displayData.y;
			////width = displayData.width;
			////height = displayData.height;
			////pivotX = displayData.pivotX;
			////pivotY = displayData.pivotY;
			////scaleX = displayData.scaleX;
			////scaleY = displayData.scaleY;
			////rotation = displayData.rotation;
			////alpha = displayData.alpha;
			////visible = displayData.visible;
		//}
	//}
	
	function popTransform() 
	{
		if (isStatic == 0){
			Graphics.popTransformation();
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
		//pushTransform();
		//popTransform();
		
		HierarchyAssembler.transformActions.push(calculateTransform);
		HierarchyAssembler.transformActions.push(popTransform);
	}
}

typedef StaticDef =
{
	index:Int,
	layerCacheRenderTarget:Int,
	state:LayerGroupState
}