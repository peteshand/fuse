package fuse.core.backend.display;

import fuse.input.TouchType;
import fuse.input.Touch;
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

	public var transformData:TransformData;
	var parentNonStatic		:Bool;
	public var alpha:Float = 1;
	public var visible:Bool = true;
	public var renderIndex	:Int = -1;
	public var drawIndex	:Int = -1;
	public var hierarchyIndex:Int = -1;
	
	public var updatePosition:Bool = true;
	public var updateRotation:Bool = true;
	public var updateColour:Bool = true;
	public var updateVisible:Bool = false;
	public var updateAlpha:Bool = true;
	public var updateTexture:Bool = true;
	@:isVar public var updateAny(get, set):Bool = true;
	
	public var touchDisplay:CoreDisplayObject;
	public var touchable:Null<Bool> = null;

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
		/*var _w:Float = (quadData.topRightX - quadData.topLeftX) / 2 * Core.STAGE_WIDTH;
		var _h:Float = (quadData.topLeftY - quadData.bottomLeftY) / 2 * Core.STAGE_HEIGHT;
		return _w * _h;*/

		if (displayData == null) return 0;
		return displayData.width * this.absoluteScaleX() * displayData.height * this.absoluteScaleY();
	}
	
	function get_diagonal():Float 
	{
		return Math.sqrt(Math.pow(quadData.topRightX - quadData.topLeftX, 2) + Math.pow(quadData.bottomLeftY - quadData.topLeftY, 2));
	}

	

	var _onPresses = new Map<Int, Touch>();
	var _onRelease = new Map<Int, Touch>();
	var _onMove = new Map<Int, Touch>();
	var _onOver = new Map<Int, Touch>();
	var _onOut = new Map<Int, Touch>();

	public function onPress(index:Int):Touch {	return getTouch(_onPresses, index, TouchType.PRESS); }
	public function onRelease(index:Int):Touch {return getTouch(_onRelease, index, TouchType.RELEASE); }
	public function onMove(index:Int):Touch {	return getTouch(_onMove, index, TouchType.MOVE); }
	public function onOver(index:Int):Touch {	return getTouch(_onOver, index, TouchType.OVER); }
	public function onOut(index:Int):Touch {	return getTouch(_onOut, index, TouchType.OUT); }

	function getTouch(map:Map<Int, Touch>, index:Int, type:TouchType):Touch
	{
		var touch:Touch = map.get(index);
		if (touch == null){
			touch = { targetId:objectId, type:type };
			map.set(index, touch);
		}
		return touch;
	}
	//function get_onPress():Touch { if (onPress == null)		onPress =	{ targetId:objectId, type:TouchType.PRESS };	return onPress; }
	//function get_onRelease():Touch { if (onRelease == null)	onRelease =	{ targetId:objectId, type:TouchType.RELEASE };	return onRelease; }
	//function get_onMove():Touch { if (onMove == null)		onMove =	{ targetId:objectId, type:TouchType.MOVE };		return onMove; }
	//function get_onOver():Touch { if (onOver == null)		onOver =	{ targetId:objectId, type:TouchType.OVER };		return onOver; }
	//function get_onOut():Touch { if (onOut == null)			onOut =		{ targetId:objectId, type:TouchType.OUT };		return onOut; }
	
	public function clear():Void
	{
		
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
		else if (this.displayType != DisplayType.STAGE) return false;
		//trace("check absoluteVis: " + objectId);
		return true;
	}

	public function absoluteScaleX():Float
	{
		var sx:Float = displayData.scaleX;
		if (parent != null) sx *= parent.absoluteScaleX();
		return sx;
	}

	public function absoluteScaleY():Float
	{
		var sx:Float = displayData.scaleY;
		if (parent != null) sx *= parent.absoluteScaleY();
		return sx;
	}

	public function withinBounds(x:Float, y:Float):Bool
	{
		return false;
	}

	public function getTriangleSum(x:Float, y:Float) 
	{
		var t1:Float = triangleArea(x, y,
			quadData.bottomLeftX, quadData.bottomLeftY,
			quadData.topLeftX, quadData.topLeftY
		);
		var t2:Float = triangleArea(x, y,
			quadData.topLeftX, quadData.topLeftY,
			quadData.topRightX, quadData.topRightY
		);
		var t3:Float = triangleArea(x, y,
			quadData.topRightX, quadData.topRightY,
			quadData.bottomRightX, quadData.bottomRightY
		);
		var t4:Float = triangleArea(x, y,
			quadData.bottomRightX, quadData.bottomRightY,
			quadData.bottomLeftX, quadData.bottomLeftY
		);
		
		return Math.round(t1 + t2 + t3 + t4);
	}

	function triangleArea(x:Float, y:Float, bx:Float, by:Float, cx:Float, cy:Float):Float
	{
		bx = (bx + 1) / 2 * Core.STAGE_WIDTH;
		by = (1 - by) / 2 * Core.STAGE_HEIGHT;
		cx = (cx + 1) / 2 * Core.STAGE_WIDTH;
		cy = (1 - cy) / 2 * Core.STAGE_HEIGHT;
		
		var a:Float = Math.sqrt(Math.pow(x - bx, 2) + Math.pow(y - by, 2));
		var b:Float = Math.sqrt(Math.pow(bx - cx, 2) + Math.pow(by - cy, 2));
		var c:Float = Math.sqrt(Math.pow(cx - x, 2) + Math.pow(cy - y, 2));
		var p:Float = (a + b + c) / 2;
		return Math.sqrt(p * (p - a) * (p - b) * (p - c));// * 4;
	}

	public function addToArray(touchDisplay:CoreDisplayObject, flattened:Array<CoreDisplayObject>)
	{
		// override
	}
}