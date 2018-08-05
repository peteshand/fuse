package mantle.time;

import haxe.Timer;
import lime.app.Application;
import mantle.notifier.Notifier;

#if openfl
import openfl.Lib;
import openfl.display.Stage;
import openfl.events.Event;
#end
/**
 * ...
 * @author P.J.Shand
 */
class EnterFrame
{
	private static var callbacks:Array<Void->Void>;
	private static var running:Notifier<Bool>;
	static private var application:Application;
	static var fps:Float = 60;

	static function __init__() 
	{
		callbacks = new Array<Void->Void>();
		running = new Notifier<Bool>(false);
		
		Timer.delay(function() {
			running.add(OnRunningChange);
			OnRunningChange();
		}, 1);
	}
	
	static function OnRunningChange() 
	{
		#if openfl
			var stage:Stage = Lib.current.stage;
			if (running.value) {
				stage.addEventListener(Event.ENTER_FRAME, Update);
			} else {
				stage.removeEventListener(Event.ENTER_FRAME, Update);
			}
		#else 
			if (running.value) {
				OnTick();
			}
		#end
	}
	
	#if openfl
	static private inline function Update(e:Event):Void 
	{
		OnTick();
	} 
	#end
	
	private static function OnTick():Void
	{
		for (i in 0...callbacks.length) 
		{
			callbacks[i]();
		}
		
		#if (!openfl)
			if (running.value) {
				Timer.delay(OnTick, Std.int(1000 / fps));
			}
		#end
	}
	
	static public function add(callback:Void->Void):Void 
	{
		running.value = true;
		callbacks.push(callback);
	}
	
	static public function addAt(callback:Void->Void, index:Int):Void 
	{
		running.value = true;
		callbacks.insert(index, callback);
	}
	
	static public function remove(callback:Void->Void):Void 
	{
		var i:Int = callbacks.length - 1;
		while (i >= 0) 
		{
			if (callbacks[i] == callback) {
				callbacks.splice(i, 1);
			}
			i--;
		}
		if (callbacks.length == 0){
			running.value = false;
		}
	}
}