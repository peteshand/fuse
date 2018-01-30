package fuse.utils.tick;

import lime.app.Application;

#if air
	import flash.Lib;
	import flash.events.Event;
#else
	import haxe.Timer;
#end
/**
 * ...
 * @author P.J.Shand
 */
class Tick
{
	private static var tickObjects = new Array<TickObject>();
	private static var _running:Bool = false;
	private static var running(get, set):Bool;
	
	public function new() 
	{
		
	}
	
	private static function OnTick():Void
	{
		for (i in 0...tickObjects.length) 
		{
			tickObjects[i].tick(cast 1000 / Application.current.frameRate); // passing fake delta
		}
		
		#if !air
			if (running) Timer.delay(OnTick, Std.int(1000 / Application.current.frameRate));
		#end
	}
	
	static public function add(callback:Int->Void):Void 
	{
		running = true;
		var tickObject:TickObject = getTickObject(callback);
		if (tickObject == null) {
			tickObject = new TickObject(callback);
			tickObjects.push(tickObject);
		}
		tickObject.start();
	}
	
	static public function addAt(callback:Int->Void, index:Int):Void 
	{
		var currentTickObject:TickObject = getTickObject(callback);
		if (currentTickObject != null) {
			remove(callback);
		}
		if (tickObjects.length > index) {
			var newTickObjects = new Array<TickObject>();
			for (i in 0...tickObjects.length) 
			{
				if (i == index) {
					var tickObject:TickObject = new TickObject(callback);
					newTickObjects.push(tickObject);
					tickObject.start();
				}
				newTickObjects.push(tickObjects[i]);
			}
			tickObjects = newTickObjects;
		}
		else {
			add(callback);
		}
	}
	
	static public function remove(callback:Int->Void):Void 
	{
		var i:Int = tickObjects.length - 1;
		while (i >= 0) 
		{
			if (tickObjects[i].callback == callback) {
				var tickObject:TickObject = tickObjects[i];
				tickObject.stop();
				tickObject = null;
				tickObjects.splice(i, 1);
			}
			i--;
		}
		if (tickObjects.length == 0) running = false;
	}
	
	static private function getTickObject(callback:Int->Void):TickObject
	{
		for (i in 0...tickObjects.length) 
		{
			if (tickObjects[i].callback == callback) {
				return tickObjects[i];
			}
		}
		return null;
	}
	
	private static function get_running():Bool
	{
		return _running;
	}
	
	private static function set_running(value:Bool):Bool
	{
		if (_running == value) return value;
		_running = value;
		if (_running) {
			#if air
				Lib.current.stage.addEventListener(Event.ENTER_FRAME, Update);
			#else
				OnTick();
			#end
		}
		else {
			#if air
				Lib.current.stage.removeEventListener(Event.ENTER_FRAME, Update);
			#end
		}
		return _running;
	}
	
	#if air
	static private function Update(e:Event):Void 
	{
		OnTick();
	}
	#end
}