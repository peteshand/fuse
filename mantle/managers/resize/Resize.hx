package mantle.managers.resize;

import notifier.Signal;
import mantle.time.EnterFrame;
//import msignal.Signal.Signal0;
import msignal.Slot.Slot0;
import openfl.display.Stage;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class Resize
{
	private static var repeatResizeForXFrames:Int = 4;
	private static var resizeCount:Int = 0;
	private static var onResize:Signal = new Signal();
	static var stage:Stage;
	
	public function new(stage:Stage) 
	{
		if (Resize.stage != null) return;
		Resize.stage = stage;
		
		OnStageResize(null);
		
		EnterFrame.addAt(OnTick, 0);
		OnTick();
		
		stage.addEventListener(Event.RESIZE, OnStageResize);
	}
	
	private static function OnStageResize(e:Event):Void 
	{
		resizeCount = 0;
	}
	
	private static function OnTick():Void 
	{
		resizeCount++;
		if (resizeCount < repeatResizeForXFrames) {
			onResize.dispatch();
		}
	}
	
	public static function add(callback:Void -> Void, fireOnce:Bool=false, priority:Int = 0):Void
	{
		onResize.add(callback, fireOnce, priority);
		callback();
	}
	
	public static function dispatch():Void
	{
		onResize.dispatch();
	}
	
	public static function remove(listener:Void -> Void):Void
	{
		onResize.remove(listener);
	}
	
	public static function removeAll():Void
	{
		onResize.removeAll();
	}
}

