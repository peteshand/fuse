package fuse.utils;

/**
 * ...
 * @author P.J.Shand
 */
class DoubleNotifier<T1, T2>
{
	var v1:Notifier<T1>;
	var v2:Notifier<T2>;
	
	private var changed1:Bool = false;
	private var _value1:T1;
	public var value1(get, set):Null<T1>;
	private var changed2:Bool = false;
	private var _value2:T2;
	public var value2(get, set):Null<T2>;
	
	private var callbacks:Array<Void -> Void>;
	
	public function new(?default1:T1, ?default2:T2) 
	{
		v1 = new Notifier<T1>(default1);
		v2 = new Notifier<T2>(default2);
		
	}
	
	private inline function get_value1():Null<T1> 
	{
		return _value1;
	}
	
	private inline function set_value1(v:Null<T1>):Null<T1> 
	{
		if (_value1 == v) return v;
		_value1 = v;
		changed1 = true;
		checkDispatch();
		return v;
	}
	
	private inline function get_value2():Null<T2> 
	{
		return _value2;
	}
	
	private inline function set_value2(v:Null<T2>):Null<T2> 
	{
		if (_value2 == v) return v;
		_value2 = v;
		changed2 = true;
		checkDispatch();
		return v;
	}

	function checkDispatch() 
	{
		if (changed1 && changed2) {
			dispatch();
			changed1 = false;
			changed2 = false;
		}
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