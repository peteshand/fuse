package kea2.utils;
import haxe.ds.ObjectMap;

/**
 * ...
 * @author P.J.Shand
 */
abstract GcoArray<T>(GcoArrayBase<T>)
{
	var index(get, never):Int;
	public var length(get, set):Int;
	
	public function new(base:Array<T>=null)
	{
		this = new GcoArrayBase<T>(base);
	}
	
	@:arrayAccess
	public inline function get(i:Int):T
	{	
		return this.base[i];
	}
	
	
	@:arrayAccess
	public inline function set(i:Int, value:T):T
	{	
		if (this.length <= i) this.length = i + 1;
		return this.base[i] = value;
	}
	
	public inline function push(value:T):Void
	{	
		this.base[this.length] = value;
		this.length = this.length + 1;
	}
	
	public function clear() 
	{
		this.length = 0;
	}
	
	function get_index():Int 
	{
		return this.length - 1;
	}
	
	function get_length():Int 
	{
		return this.length;
	}
	
	function set_length(value:Int):Int 
	{
		this.length = value;
		return value;
	}
}

class GcoArrayBase<T>
{
	public var base:Array<T>;
	public var length:Int = 0;
	
	public function new(base:Array<T>=null)
	{
		this.base = base;
	}
}