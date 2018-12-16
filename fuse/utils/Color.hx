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
	
	public function new(value:UInt) {
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
	
	static public function random(alpha:Null<Int>=null, red:Null<Int>=null, green:Null<Int>=null, blue:Null<Int>=null):Color
	{
		var randomColor:Color = 0x0;
		if (alpha == null) randomColor.alpha = Math.round(0xFF * Math.random());
		else randomColor.alpha = alpha;
		
		if (red == null) randomColor.red = Math.round(0xFF * Math.random());
		else randomColor.red = red;
		
		if (green == null) randomColor.green = Math.round(0xFF * Math.random());
		else randomColor.green = green;
		
		if (blue == null) randomColor.blue = Math.round(0xFF * Math.random());
		else randomColor.blue = blue;
		
		return randomColor;
	}

	/*public function clone():Color
	{
		var _clone = new Color(0x0);
		_clone.red = red;
		_clone.green = green;
		_clone.blue = blue;
		_clone.alpha = alpha;
		return _clone;
	}*/
}