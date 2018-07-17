package mantle.managers.touch; 

import haxe.ds.Vector;
#if flash
import flash.ui.MouseCursor;
import flash.ui.Mouse;
#end
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.events.TouchEvent;
import starling.events.Touch;

/**
 * ...
 * @author P.J.Shand
 */
class TouchBehaviorVec 
{
	public var touchObject:DisplayObject;
	
	public var onBegin = new Array<Touch->Void>();
	public var onMove = new Array<Touch->Void>();
	public var onEnd = new Array<Touch->Void>();
	public var onOver = new Array<Touch->Void>();
	public var onOut = new Array<Touch->Void>();
	public var onHover = new Array<Touch->Void>();
	public var onStationary = new Array<Touch->Void>();
	
	private var touchBegans:TouchList;
	private var touchMoves:TouchList;
	private var touchEnds:TouchList;
	private var touchOvers:TouchList;
	private var touchOuts:TouchList;
	private var touchHovers:TouchList;
	private var touchStationary:TouchList;
	
	private var stageMoves:TouchList;
	private var stageHovers:TouchList;
	
	private var mEnabled:Bool = true;
	private var mUseHandCursor:Bool = true;
	
	private var touchBehaviorObjects = new Map<Int, TouchBehaviorObject>();
	var buttonMode:Bool;
	
	public function new(touchObject:DisplayObject, buttonMode:Bool=true) 
	{
		this.buttonMode = buttonMode;
		this.touchObject = touchObject;
		Reflect.setProperty(touchObject, "touchable", true);
		
		touchObject.addEventListener(TouchEvent.TOUCH, OnTouch);
	}
	
	private function OnTouch(e:TouchEvent):Void 
	{
		
		#if flash
		if (buttonMode) Mouse.cursor = (mUseHandCursor && mEnabled && e.interactsWith(touchObject)) ? MouseCursor.BUTTON:MouseCursor.AUTO;
		#end
		
		if (onBegin.length > 0) {
			touchBegans = e.getTouches(touchObject, TouchPhase.BEGAN); 
			if (touchBegans.length > 0) ParseTouchBegins(touchBegans);
		}
		if (onMove.length > 0) {
			touchMoves = e.getTouches(touchObject, TouchPhase.MOVED); 
			if (touchMoves.length > 0) ParseTouchMoves(touchMoves);
		}
		if (onEnd.length > 0) {
			touchEnds = e.getTouches(touchObject, TouchPhase.ENDED); 
			if (touchEnds.length > 0) ParseTouchEnds(touchEnds);
		}
		if (onHover.length > 0) {
			touchHovers = e.getTouches(touchObject, TouchPhase.HOVER); 
			if (touchHovers.length > 0) ParseTouchHovers(touchHovers);
		}
		if (onStationary.length > 0) {
			touchStationary = e.getTouches(touchObject, TouchPhase.STATIONARY); 
			if (touchStationary.length > 0) ParseTouchStationary(touchStationary);
		}
		
		if (onOver.length > 0 || onOut.length > 0) {
			stageHovers = e.getTouches(touchObject, TouchPhase.HOVER); 
			
			if (stageHovers.length > 0) {
				SetRollOver(stageHovers);
			}
			
			stageMoves = e.getTouches(touchObject, TouchPhase.MOVED); 
			if (stageMoves.length > 0) {
				SetRollOver(stageMoves);
			}
		}
		
		var allTouch:Touch = e.getTouch(touchObject);
		if (allTouch == null) {
			
			SetRollOut();
		}
	}
	
	// This breaks everything apart from touch_begin
	/*function getTouches(e:TouchEvent, touchObject:DisplayObject, began:String) 
	{
		#if swc
		return e.getTouches(touchObject, TouchPhase.BEGAN);
		#else
		return e.getTouches(touchObject, TouchPhase.BEGAN, new TouchList());
		#end
	}*/
	
	/*function ConvertToArray(touches:Vector<Touch>):Array<Touch>
	{
		var array = new Array<Touch>();
		for (i in 0...touches.length) {
			array.push(touches.get(i));
		}
		return array;
	}*/
	
	private function ParseTouchBegins(touchVector:TouchList):Void
	{
		for (i in 0...touchVector.length) {
			touchBehaviorObject(i).ParseTouchBegins(touchVector[i]);
		}
	}
	
	private function ParseTouchMoves(touchVector:TouchList):Void
	{
		for (i in 0...touchVector.length) {
			touchBehaviorObject(i).ParseTouchMoves(touchVector[i]);
		}
	}
	
	private function ParseTouchEnds(touchVector:TouchList):Void
	{
		for (i in 0...touchVector.length) {
			touchBehaviorObject(i).ParseTouchEnds(touchVector[i]);
		}
	}
	
	private function ParseTouchHovers(touchVector:TouchList):Void 
	{
		for (i in 0...touchVector.length) {
			touchBehaviorObject(i).ParseTouchHovers(touchVector[i]);
		}
	}
	
	private function ParseTouchStationary(touchVector:TouchList):Void 
	{
		for (i in 0...touchVector.length) {
			touchBehaviorObject(i).ParseTouchStationary(touchVector[i]);
		}
	}
	
	private function SetRollOver(touchVector:TouchList):Void 
	{
		for (i in 0...touchVector.length) {
			Reflect.setProperty(touchBehaviorObject(i), "isRolledOver", true);
		}
	}
	
	private function SetRollOut():Void 
	{
		for (touchBehaviorObject in touchBehaviorObjects) 
		{
			Reflect.setProperty(touchBehaviorObject, "isRolledOver", false);
		}
	}
	
	private function touchBehaviorObject(index:Int):TouchBehaviorObject 
	{
		if (touchBehaviorObjects.exists(index)) return touchBehaviorObjects.get(index);
		
		var touchBehaviorObject = new TouchBehaviorObject(this, touchObject);
		touchBehaviorObjects.set(index, touchBehaviorObject);
		return touchBehaviorObject;
	}
	
	public function dispose():Void 
	{
		touchObject.removeEventListener(TouchEvent.TOUCH, OnTouch);
		touchObject = null;
		
		onBegin = new Array<Touch->Void>();
		onMove = new Array<Touch->Void>();
		onEnd = new Array<Touch->Void>();
		onOver = new Array<Touch->Void>();
		onOut = new Array<Touch->Void>();
		onHover = new Array<Touch->Void>();
		onStationary = new Array<Touch->Void>();
		
		touchBegans = null;
		touchMoves = null;
		touchEnds = null;
		touchOvers = null;
		touchOuts = null;
		touchHovers = null;
		touchStationary = null;
		stageMoves = null;
		stageHovers = null;
	}
}

/*#if swc
typedef TouchList = flash.Vector<Touch>;
#else*/
typedef TouchList = openfl.Vector<Touch>;
//#end