package fuse.loader;

import openfl.display.BitmapData;
import openfl.events.Event;

/**
 * @author P.J.Shand
 */
interface ILoader {
	var bitmapData:BitmapData;
	var loading:Bool;
	public function load(url:String):Void;
	public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	public function dispatchEvent(event:Event):Bool;
	public function hasEventListener(type:String):Bool;
	public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void;
	public function toString():String;
	public function willTrigger(type:String):Bool;
}
