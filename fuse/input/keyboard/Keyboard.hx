package fuse.input.keyboard;

import fuse.input.keyboard.Key;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.KeyboardEvent;

/**
 * ...
 * @author P.J.Shand
 */
class Keyboard
{
	static var items = new Array<KeyboardListener>();
	
	public function new() {}
	
	static public function onPress(key:Key, callback:Dynamic, parameter:Array<Dynamic>=null):KeyboardListener
	{
		var keyboardListener = new KeyboardListener(key, callback, parameter, KeyState.PRESS);
		items.push(keyboardListener);
		return keyboardListener;
	}
	
	static public function onRelease(key:Key, callback:Dynamic, parameter:Array<Dynamic>):KeyboardListener
	{
		var keyboardListener = new KeyboardListener(key, callback, parameter, KeyState.RELEASE);
		items.push(keyboardListener);
		return keyboardListener;
	}
}

class KeyboardListener
{
	var callback:Dynamic;
	var key:Key;
	var keyState:KeyState;
	var parameter:Array<Dynamic>;
	var _shift:Bool = false;
	var _ctrl:Bool = false;
	var _alt:Bool = false;
	
	public function new(key:Key, callback:Dynamic, parameter:Array<Dynamic>, keyState:KeyState) 
	{
		this.key = key;
		this.callback = callback;
		this.keyState = keyState;
		this.parameter = parameter;
		
		if (keyState == KeyState.PRESS) Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
		if (keyState == KeyState.RELEASE) Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
	}
	
	public function shift(value:Bool):KeyboardListener
	{
		_shift = value;
		return this;
	}
	
	public function ctrl(value:Bool):KeyboardListener
	{
		_ctrl = value;
		return this;
	}
	
	public function alt(value:Bool):KeyboardListener
	{
		_alt = value;
		return this;
	}
	
	private function OnKeyDown(e:KeyboardEvent):Void 
	{
		if (key == e.keyCode && e.shiftKey == _shift && e.ctrlKey == _ctrl && e.altKey == _alt) {
			execute(parameter);
		}
	}
	
	private function OnKeyUp(e:KeyboardEvent):Void 
	{
		if (key == e.keyCode && e.shiftKey == _shift && e.ctrlKey == _ctrl && e.altKey == _alt) {
			execute(parameter);
		}
	}
	
	private function execute(params:Array<Dynamic>):Void
	{
		switch params.length {
			case 0: untyped callback();
			case 1: untyped callback(params[0]);
			case 2: untyped callback(params[0], params[1]);
			case 3: untyped callback(params[0], params[1], params[2]);
			case 4: untyped callback(params[0], params[1], params[2], params[3]);
			case 5: untyped callback(params[0], params[1], params[2], params[3], params[4]);
			case 6: untyped callback(params[0], params[1], params[2], params[3], params[4], params[5]);
			case 7: untyped callback(params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
			case 8: untyped callback(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);
		}
	}
}

@:enum
abstract KeyState(String) to String
{
    var PRESS = "press";
	var RELEASE = "release";
	var DOWN = "down";
	var UP = "up";
}