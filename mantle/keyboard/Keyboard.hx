package mantle.keyboard;

import mantle.keyboard.Key;
import mantle.util.func.FunctionUtil;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author P.J.Shand
 */
class Keyboard
{
	static var pressItems = new Array<KeyboardListener>();
	static var releaseItems = new Array<KeyboardListener>();
	
	public function new() {}
	
	static private function init() 
	{
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
	}
	
	static private function OnKeyDown(e:KeyboardEvent):Void 
	{
		for (i in 0...pressItems.length) pressItems[i].OnKeyDown(e);
	}
	
	static private function OnKeyUp(e:KeyboardEvent):Void 
	{
		for (i in 0...releaseItems.length) releaseItems[i].OnKeyUp(e);
	}
	
	static public function onPress(?key:Key, callback:Dynamic, params:Array<Dynamic>=null):KeyboardListener
	{
		init();
		var keyboardListener = new KeyboardListener(key, callback, params);
		pressItems.push(keyboardListener);
		return keyboardListener;
	}
	
	static public function onRelease(?key:Key, callback:Dynamic, params:Array<Dynamic>=null):KeyboardListener
	{
		init();
		var keyboardListener = new KeyboardListener(key, callback, params);
		releaseItems.push(keyboardListener);
		return keyboardListener;
	}
	
	static public function removePress(callback:Dynamic):Void
	{
		remove(callback, pressItems);
	}
	
	static public function removeRelease(callback:Dynamic):Void
	{
		remove(callback, releaseItems);
	}
	
	static inline function remove(callback:Dynamic, items:Array<KeyboardListener>):Void
	{
		var i:Int = items.length - 1;
		while (i >= 0) 
		{
			if (items[i].callback == callback) {
				items[i].dispose();
				items.splice(i, 1);
			}
		}
	}
}

class KeyboardListener
{
	@:isVar public var key(default, null):Key;
	@:isVar public var callback(default, null):Dynamic;
	
	var params:Array<Dynamic>;
	var _shift:Null<Bool>;
	var _ctrl:Null<Bool>;
	var _alt:Null<Bool>;
	
	public function new(?key:Key, callback:Dynamic, params:Array<Dynamic>) 
	{
		this.key = key;
		this.callback = callback;
		this.params = params;
	}
	
	public function dispose() 
	{
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
	}
	
	public function shift(value:Null<Bool>):KeyboardListener
	{
		_shift = value;
		return this;
	}
	
	public function ctrl(value:Null<Bool>):KeyboardListener
	{
		_ctrl = value;
		return this;
	}
	
	public function alt(value:Null<Bool>):KeyboardListener
	{
		_alt = value;
		return this;
	}
	
	public function OnKeyDown(e:KeyboardEvent):Void 
	{
		if (pass(key, e.keyCode) && pass(_shift, e.shiftKey) && pass(_ctrl, e.ctrlKey) && pass(_alt, e.altKey)) {
			FunctionUtil.dispatch(callback, params);
		}
	}
	
	public function OnKeyUp(e:KeyboardEvent):Void 
	{
		if (pass(key, e.keyCode) && pass(_shift, e.shiftKey) && pass(_ctrl, e.ctrlKey) && pass(_alt, e.altKey)) {
			FunctionUtil.dispatch(callback, params);
		}
	}
	
	inline function pass(value1:Dynamic, value2:Dynamic) 
	{
		if (value1 == value2 || value1 == null) return true;
		return false;
	}
}