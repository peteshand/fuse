package fuse.utils;

import fuse.utils.tick.Tick;
import fuse.signal.Signal0;
import openfl.Lib;
import openfl.display.Stage;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
class Resize
{
	static var stage:Stage;
	static var repeatResizeForXFrames:Int = 1;
	static var resizeCount:Int = 0;
	static var _change:Signal0;
	public static var change(get, null):Signal0;
	
	static function init() 
	{
		if (stage != null) return;
		
		stage = Lib.current.stage;
		stage.addEventListener(Event.RESIZE, OnStageResize);
		stage.addEventListener(Event.FULLSCREEN, OnEnterFullscreen);
		OnStageResize(null);
		
		Tick.addAt(OnTick, 0);
		OnTick(0);
	}
	
	static private function OnEnterFullscreen(e:Event):Void 
	{
		resizeCount = 0;
	}
	
	private static function get_change():Signal0
	{
		init();
		if (_change == null) _change = new Signal0();
		return _change;
	}
	
	private static function OnStageResize(e:Event):Void 
	{
		resizeCount = 0;
	}
	
	private static function OnTick(delta:Int):Void 
	{
		resizeCount++;
		if (resizeCount < repeatResizeForXFrames) {
			change.dispatch();
		}
	}
}