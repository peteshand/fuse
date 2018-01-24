package fuse.utils;

/**
 * ...
 * @author P.J.Shand
 */
@:expose
@:dox(show)
abstract Color(UInt) from Int from UInt to UInt 
{
	public var red(get, set):UInt;
	public var green(get, set):UInt;
	public var blue(get, set):UInt;
	public var alpha(get, set):UInt;
	
	private function new(value:UInt) {
		this = value;
	}
	
	inline function get_red():UInt 
	{
		return (this & 0x00ff0000) >>> 16;
	}
	
	inline function get_green():UInt 
	{
		return (this & 0x0000ff00) >>> 8;
	}
	
	inline function get_blue():UInt 
	{
		return this & 0x000000ff;
	}
	
	inline function get_alpha():UInt 
	{
		return this >>> 24;
	}
	
	
	inline function set_red(value:UInt):UInt 
	{
		this = (alpha << 24) | (value << 16) | (green << 8) | blue;
		return value;
	}
	
	inline function set_green(value:UInt):UInt 
	{
		this = (alpha << 24) | (red << 16) | (value << 8) | blue;
		return value;
	}
	
	inline function set_blue(value:UInt):UInt 
	{
		this = (alpha << 24) | (red << 16) | (green << 8) | value;
		return value;
	}
	
	inline function set_alpha(value:UInt):UInt 
	{
		this = (value << 24) | (red << 16) | (green << 8) | blue;
		return value;
	}
}