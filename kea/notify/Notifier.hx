package kea.notify;


/**
 * A Notifier adds a "change" signal to a value.
 * If the value is of a base type (Int, Float, String, Bool)
 * then the notifier can be treated as a value in expressions.
 * (i.e. the ".value" can be omitted).
 * 
 * @author P.J.Shand
 */

class Notifier<T>
{
	//public var requireChange:Bool = true;
	private var _value:T;
	public var value(get, set):Null<T>;
	private var callbacks:Array<Void -> Void>;
	
	public function new(?v:T) 
	{
		_value = v;
	}
	
	function toString():String
	{
		return cast this.value;
	}
	
	private inline function get_value():Null<T> 
	{
		return _value;
	}
	
	private inline function set_value(v:Null<T>):Null<T> 
	{
		if (_value == v) return v;
		_value = v;
		dispatch();
		return v;
	}

	public inline function dispatch():Void
	{
		initArray();
		for (i in 0...callbacks.length){
			callbacks[i]();
		}
	}
	
	public function add(value:Void -> Void):Void
	{
		initArray();
		for (i in 0...callbacks.length){
			if (callbacks[i] == value) return;
		}
		callbacks.push(value);
	}

	public function remove(value:Void -> Void):Void
	{
		initArray();
		var i:Int = callbacks.length-1;
		while (i >= 0){
			if (callbacks[i] == value){
				callbacks.splice(i, 1);
			}
			i--;
		}
	}
	
	inline function initArray() 
	{
		if (callbacks == null) callbacks = [];
	}
}