package mantle.managers.touch; 

import starling.display.DisplayObject;
import starling.events.Touch;

#if swc
	import flash.errors.Error;
#else
	import openfl.errors.Error;
#end

/**
 * ...
 * @author P.J.Shand
 */
class TouchManager 
{
	static private var _instance:TouchManager;
	static private var touchBehaviorVecs = new Array<TouchBehaviorVec>();
	static private var currentObject:TouchBehaviorVec;
	
	private var instance(get, null):TouchManager;
	private static var staticInstance(get, null):TouchManager;
	
	public function new() 
	{
		
	}
	
	static public function add(touchObject:DisplayObject, buttonMode:Bool=true):TouchManager 
	{
		if (_instance == null) _instance = new TouchManager();
		TouchManager.currentObject = touchBehaviorObject(touchObject, buttonMode);
		return staticInstance;
	}
	
	static public function remove(touchObject:DisplayObject):Void 
	{
		if (TouchManager.currentObject == touchBehaviorObject(touchObject)) {
			TouchManager.currentObject = null;
		}
		var i = 0;
		while (i < touchBehaviorVecs.length) 
		{
			var touchBehaviourVec = touchBehaviorVecs[i];
			if (touchBehaviourVec.touchObject == touchObject) {
				touchBehaviourVec.dispose();
				touchBehaviorVecs.splice(i, 1);
			}else{
				i++;
			}
		}
	}
	
	static private function touchBehaviorObject(touchObject:DisplayObject, buttonMode:Bool=true):TouchBehaviorVec 
	{
		for (i in 0...touchBehaviorVecs.length) 
		{
			if (touchBehaviorVecs[i].touchObject == touchObject) {
				return touchBehaviorVecs[i];
			}
		}
		var touchBehaviorObject:TouchBehaviorVec = new TouchBehaviorVec(touchObject, buttonMode);
		touchBehaviorVecs.push(touchBehaviorObject);
		return touchBehaviorObject;
	}
	
	// Add functions
	public function setBegin(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onBegin.push(callback);
		return _instance;
	}
	
	public function setMove(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onMove.push(callback);
		return _instance;
	}
	
	public function setEnd(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onEnd.push(callback);
		return _instance;
	}
	
	public function setOver(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onOver.push(callback);
		return _instance;
	}
	
	public function setOut(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onOut.push(callback);
		return _instance;
	}
	
	public function setHover(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onHover.push(callback);
		return _instance;
	}
	
	public function setStationary(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onStationary.push(callback);
		return _instance;
	}
	
	
	// Remove functions
	public function removeBegin(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onBegin.remove(callback);
		return _instance;
	}
	
	public function removeMove(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onMove.remove(callback);
		return _instance;
	}
	
	public function removeEnd(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onEnd.remove(callback);
		return _instance;
	}
	
	public function removeOver(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onOver.remove(callback);
		return _instance;
	}
	
	public function removeOut(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onOut.remove(callback);
		return _instance;
	}
	
	public function removeHover(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onHover.remove(callback);
		return _instance;
	}
	
	public function removeStationary(callback:Touch->Void):TouchManager
	{
		if (TouchManager.currentObject == null) return _instance;
		TouchManager.currentObject.onStationary.remove(callback);
		return _instance;
	}
	
	private function get_instance():TouchManager 
	{
		if (_instance == null) _instance = new TouchManager();
		return _instance;
	}
	
	private static function get_staticInstance():TouchManager 
	{
		if (_instance == null) _instance = new TouchManager();
		return _instance;
	}
}