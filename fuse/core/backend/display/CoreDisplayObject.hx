package fuse.core.backend.display;
import fuse.core.backend.displaylist.Graphics;
import fuse.core.backend.layerCache.groups.LayerGroup;
import fuse.core.backend.util.transform.WorkerTransformHelper;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.pool.Pool;
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
	public var x			:Float = 0;
	public var y			:Float = 0;
	public var width		:Float = 0;
	public var height		:Float = 0;
	public var pivotX		:Float = 0;
	public var pivotY		:Float = 0;
	public var rotation		:Float = 0;
	public var scaleX		:Float = 0;
	public var scaleY		:Float = 0;
	public var alpha		:Float = 0;
	public var visible		:Int = 1;
	
	public var displayData	:IDisplayData;
	public var parent		:CoreInteractiveObject;
	public var layerGroup	:LayerGroup;
	
	public var bottomLeft	:Point = new Point();
	public var topLeft		:Point = new Point();
	public var topRight		:Point = new Point();
	public var bottomRight	:Point = new Point();
	
	var transformData		:TransformData;
	var staticDef			:StaticDef;
	var parentNonStatic		:Bool;
	var combinedAlpha		:Float = 1;
	
	public function new() 
	{
		staticDef = { 
			index:-1,
			layerCacheRenderTarget:0,
			state:LayerGroupState.DRAW_TO_LAYER
		};
		transformData = new TransformData();
	}
	
	public function buildHierarchy() 
	{
		Core.displayListBuilder.hierarchyApplyTransform.push(pushTransform);
		Core.displayListBuilder.hierarchyApplyTransform.push(popTransform);
	}
	
	function pushTransform() 
	{
		updateIsStatic();
		
		if (isStatic == 0) {
			readDisplayData();
			combinedAlpha = Graphics.alpha * this.alpha;
			Graphics.pushAlpha(combinedAlpha);
			WorkerTransformHelper.update(this);
			updatePositionData();
		}
	}
	
	inline function updatePositionData() 
	{
		WorkerTransformHelper.multvec(bottomLeft, transformData.localTransform, -pivotX, -pivotY + height);
		WorkerTransformHelper.multvec(topLeft, transformData.localTransform, -pivotX, -pivotY);
		WorkerTransformHelper.multvec(topRight, transformData.localTransform, -pivotX + width, -pivotY);
		WorkerTransformHelper.multvec(bottomRight, transformData.localTransform, -pivotX + width, -pivotY + height);
	}
	
	function updateIsStatic() 
	{
		isStatic = displayData.isStatic;
		displayData.isStatic = 1; // reset static prop
		
		/*var tempApplyPosition:Int = displayData.applyPosition;
		if (applyPosition != tempApplyPosition) {
			applyPosition = tempApplyPosition;
			displayData.applyPosition = 0;
		}
		var tempApplyRotation:Int = displayData.applyRotation;
		if (applyRotation != tempApplyRotation) {
			applyRotation = tempApplyRotation;
			//trace("applyRotation = " + applyRotation);
			displayData.applyRotation = 0;
		}*/
		if (isStatic == 0) {
			setChildrenIsStatic(false);
		}
	}
	
	function setChildrenIsStatic(value:Bool) 
	{
		if (value) {
			parentNonStatic = true;
			//checkIsStatic();
		}
	}
	
	function readDisplayData() 
	{
		if (isStatic == 0 || parentNonStatic){
			x = displayData.x;
			y = displayData.y;
			width = displayData.width;
			height = displayData.height;
			pivotX = displayData.pivotX;
			pivotY = displayData.pivotY;
			scaleX = displayData.scaleX;
			scaleY = displayData.scaleY;
			rotation = displayData.rotation;
			alpha = displayData.alpha;
			visible = displayData.visible;
		}
	}
	
	function popTransform() 
	{
		if (isStatic == 0){
			Graphics.popTransformation();
			Graphics.popAlpha();
			
			//applyPosition = 0;
			//applyRotation = 0;
		}
	}
	
	//inline function get_applyPosition():Int { return applyPosition; }
	//inline function get_applyRotation():Int { return applyRotation; }
	
	/*inline function set_applyPosition(value:Int):Int 
	{
		if (applyPosition != value) {
			applyPosition = value;
			checkIsStatic();
		}
		return applyPosition;
	}
	
	inline function set_applyRotation(value:Int):Int 
	{
		if (applyRotation != value) {
			applyRotation = value;
			checkIsStatic();
		}
		return applyRotation;
	}*/
	
	/*inline function checkIsStatic():Void 
	{
		if (applyRotation == 1 || applyPosition == 1 || parentNonStatic) isStatic = 0;
	}*/
	
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
}

typedef StaticDef =
{
	index:Int,
	layerCacheRenderTarget:Int,
	state:LayerGroupState
}