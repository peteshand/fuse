package mantle.managers.resize;

import mantle.time.EnterFrame;
import msignal.Signal.Signal0;
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
	private static var onResize:Signal0;
	static var stage:Stage;
	
	public function new(stage:Stage) 
	{
		if (Resize.stage != null) return;
		Resize.stage = stage;
		
		if (onResize == null) onResize = new Signal0();
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
	
	public static function add(listener:Void -> Void):Slot0
	{
		return onResize.add(listener);
	}
	
	public static function addOnce(listener:Void -> Void):Slot0
	{
		return onResize.addOnce(listener);
	}
	
	public static function addOnceWithPriority(listener:Void -> Void, ?priority:Int=0):Slot0
	{
		return onResize.addOnceWithPriority(listener, priority);
	}
	
	public static function addWithPriority(listener:Void -> Void, ?priority:Int=0):Slot0
	{
		return onResize.addWithPriority(listener, priority);
	}
	
	public static function dispatch():Void
	{
		onResize.dispatch();
	}
	
	public static function remove(listener:Void -> Void):Slot0
	{
		return onResize.remove(listener);
	}
	
	public static function removeAll():Void
	{
		onResize.removeAll();
	}
}

