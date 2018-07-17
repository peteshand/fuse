package mantle.managers.touch;

import flash.geom.Point;
import starling.display.DisplayObject;
import starling.events.Touch;

/**
 * ...
 * @author P.J.Shand
 */
class TouchBehaviorObject 
{
	private var touchBehaviorVec:TouchBehaviorVec;
	private var touchObject:DisplayObject;
	
	public var onBegin:Touch->Void;
	public var onMove:Touch->Void;
	public var onEnd:Touch->Void;
	public var onOver:Touch->Void;
	public var onOut:Touch->Void;
	public var onHover:Touch->Void;
	public var onStationary:Touch->Void;
	
	private var _isRolledOver:Bool = false;
	
	private var hitPoint = new Point();
	
	public var isRolledOver(get, set):Bool; 
	
	public function new(touchBehaviorVec:TouchBehaviorVec, touchObject:DisplayObject) 
	{
		this.touchObject = touchObject;
		this.touchBehaviorVec = touchBehaviorVec;
	}
	
	public function ParseTouchBegins(touch:Touch):Void
	{
		var i:Int = 0;
		while (i < touchBehaviorVec.onBegin.length) 
		{
			touchBehaviorVec.onBegin[i](touch);
			i++;
		}
	}
	
	public function ParseTouchMoves(touch:Touch):Void
	{
		for (i in 0...touchBehaviorVec.onMove.length) 
			touchBehaviorVec.onMove[i](touch);
	}
	
	public function ParseTouchEnds(touch:Touch):Void
	{
		var i:Int = touchBehaviorVec.onEnd.length - 1;
		while (i >= 0) 
		{
			touchBehaviorVec.onEnd[i](touch);
			i--;
		}
	}
	
	public function ParseTouchOvers(touch:Touch):Void 
	{
		for (i in 0...touchBehaviorVec.onOver.length)
			touchBehaviorVec.onOver[i](touch);
	}
	
	public function ParseTouchOuts(touch:Touch):Void 
	{
		for (i in 0...touchBehaviorVec.onOut.length)
			touchBehaviorVec.onOut[i](touch);
	}
	
	public function ParseTouchHovers(touch:Touch):Void 
	{
		for (i in 0...touchBehaviorVec.onHover.length)
			touchBehaviorVec.onHover[i](touch);
	}
	
	public function ParseTouchStationary(touch:Touch):Void 
	{
		for (i in 0...touchBehaviorVec.onStationary.length)
			touchBehaviorVec.onStationary[i](touch);
	}
	
	#if swc @:getter(isRolledOver) #end
	public function get_isRolledOver():Bool 
	{
		return _isRolledOver;
	}
	
	#if swc @:setter(isRolledOver) #end
	public function set_isRolledOver(value:Bool):Bool 
	{
		if (_isRolledOver == value) return value;
		_isRolledOver = value;
		
		if (_isRolledOver) {
			for (i in 0...touchBehaviorVec.onOver.length)
				touchBehaviorVec.onOver[i](null);
		}
		else {
			for (j in 0...touchBehaviorVec.onOut.length) 
				touchBehaviorVec.onOut[j](null);
		}
		return value;
	}
}