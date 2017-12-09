package fuse.display.geometry;

/**
 * ...
 * @author P.J.Shand
 */
@:forward(length)
abstract QuadData(Array<Float>) 
{
	public var bottomLeftX(get, set)	:Float;
	public var bottomLeftY(get, set)	:Float;
	public var topLeftX(get, set)		:Float;
	public var topLeftY(get, set)		:Float;
	public var topRightX(get, set)		:Float;
	public var topRightY(get, set)		:Float;
	public var bottomRightX(get, set)	:Float;
	public var bottomRightY(get, set)	:Float;
	
	public function new()
	{
		this = [0, 0, 0, 0, 0, 0, 0, 0];
	}
	
	@:arrayAccess
	public inline function get(index:Int):Float
	{
		return this[index];
	}
	
	@:arrayAccess
	public inline function arrayWrite(index:Int, value:Float):Float
	{
		this[index] = value;
		return value;
	}
	
	function get_bottomLeftX():Float 
	{
		return this[0];
	}
	
	function get_bottomLeftY():Float 
	{
		return this[1];
	}
	
	function get_topLeftX():Float 
	{
		return this[2];
	}
	
	function get_topLeftY():Float 
	{
		return this[3];
	}
	
	function get_topRightX():Float 
	{
		return this[4];
	}
	
	function get_topRightY():Float 
	{
		return this[5];
	}
	
	function get_bottomRightX():Float 
	{
		return this[6];
	}
	
	function get_bottomRightY():Float 
	{
		return this[7];
	}
	
	
	
	
	
	function set_bottomLeftX(value:Float):Float 
	{
		return this[0] = value;
	}
	
	function set_bottomLeftY(value:Float):Float 
	{
		return this[1] = value;
	}
	
	function set_topLeftX(value:Float):Float 
	{
		return this[2] = value;
	}
	
	function set_topLeftY(value:Float):Float 
	{
		return this[3] = value;
	}
	
	function set_topRightX(value:Float):Float 
	{
		return this[4] = value;
	}
	
	function set_topRightY(value:Float):Float 
	{
		return this[5] = value;
	}
	
	function set_bottomRightX(value:Float):Float 
	{
		return this[6] = value;
	}
	
	function set_bottomRightY(value:Float):Float 
	{
		return this[7] = value;
	}
}