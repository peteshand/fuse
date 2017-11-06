package fuse.utils;

/**
 * ...
 * @author P.J.Shand
 */
@:expose
@:dox(show)
abstract Color(Int) from Int from UInt to Int to UInt 
{
	public var red(get, set):Int;
	public var green(get, set):Int;
	public var blue(get, set):Int;
	public var alpha(get, set):Int;
	
	private function new(value:Int) {
		this = value;
	}
	
	inline function get_red():Int 
	{
		return (this & 0x00ff0000) >>> 16;
	}
	
	inline function get_green():Int 
	{
		return (this & 0x0000ff00) >>> 8;
	}
	
	inline function get_blue():Int 
	{
		return this & 0x000000ff;
	}
	
	inline function get_alpha():Int 
	{
		return this >>> 24;
	}
	
	
	inline function set_red(value:Int):Int 
	{
		this = (alpha << 24) | (value << 16) | (green << 8) | blue;
		return value;
	}
	
	inline function set_green(value:Int):Int 
	{
		this = (alpha << 24) | (red << 16) | (value << 8) | blue;
		return value;
	}
	
	inline function set_blue(value:Int):Int 
	{
		this = (alpha << 24) | (red << 16) | (green << 8) | value;
		return value;
	}
	
	inline function set_alpha(value:Int):Int 
	{
		this = (value << 24) | (red << 16) | (green << 8) | blue;
		return value;
	}
}