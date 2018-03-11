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
	
	public var middleX(get, never)		:Float;
	public var middleY(get, never)		:Float;
	
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
	
	//public inline function clear() 
	//{
		//bottomLeftX = 0;
		//bottomLeftY = 0;
		//bottomRightX = 0;
		//bottomRightY = 0;
		//topLeftX = 0;
		//topLeftY = 0;
		//topRightX = 0;
		//topRightY = 0;
	//}
	
	inline function get_bottomLeftX():Float 
	{
		return this[0];
	}
	
	inline function get_bottomLeftY():Float 
	{
		return this[1];
	}
	
	inline function get_topLeftX():Float 
	{
		return this[2];
	}
	
	inline function get_topLeftY():Float 
	{
		return this[3];
	}
	
	inline function get_topRightX():Float 
	{
		return this[4];
	}
	
	inline function get_topRightY():Float 
	{
		return this[5];
	}
	
	inline function get_bottomRightX():Float 
	{
		return this[6];
	}
	
	inline function get_bottomRightY():Float 
	{
		return this[7];
	}
	
	inline function get_middleX():Float 
	{
		return topLeftX + ((topRightX - topLeftX) * 0.5);
	}
	
	inline function get_middleY():Float 
	{
		return topLeftY + ((bottomLeftY - topLeftY) * 0.5);
	}
	
	
	
	
	
	inline function set_bottomLeftX(value:Float):Float 
	{
		return this[0] = value;
	}
	
	inline function set_bottomLeftY(value:Float):Float 
	{
		return this[1] = value;
	}
	
	inline function set_topLeftX(value:Float):Float 
	{
		return this[2] = value;
	}
	
	inline function set_topLeftY(value:Float):Float 
	{
		return this[3] = value;
	}
	
	inline function set_topRightX(value:Float):Float 
	{
		return this[4] = value;
	}
	
	inline function set_topRightY(value:Float):Float 
	{
		return this[5] = value;
	}
	
	inline function set_bottomRightX(value:Float):Float 
	{
		return this[6] = value;
	}
	
	inline function set_bottomRightY(value:Float):Float 
	{
		return this[7] = value;
	}
}