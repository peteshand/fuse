package fuse.display.geometry;

/**
 * ...
 * @author P.J.Shand
 */
//@:forward(length)
class QuadData
{
	public var bottomLeftX:Float;
	public var bottomLeftY:Float;
	public var topLeftX:Float;
	public var topLeftY:Float;
	public var topRightX:Float;
	public var topRightY:Float;
	public var bottomRightX:Float;
	public var bottomRightY:Float;
	
	public var middleX(get, never)		:Float;
	public var middleY(get, never)		:Float;
	
	public function new()
	{
		//this = [0, 0, 0, 0, 0, 0, 0, 0];
	}
	
	//@:arrayAccess
	//public inline function get(index:Int):Float
	//{
		//return this[index];
	//}
	
	//@:arrayAccess
	//public inline function arrayWrite(index:Int, value:Float):Float
	//{
		//this[index] = value;
		//return value;
	//}
	
	//inline function get_bottomLeftX():Float 
	//{
		//return this[0];
	//}
	//
	//inline function get_bottomLeftY():Float 
	//{
		//return this[1];
	//}
	//
	//inline function get_topLeftX():Float 
	//{
		//return this[2];
	//}
	//
	//inline function get_topLeftY():Float 
	//{
		//return this[3];
	//}
	//
	//inline function get_topRightX():Float 
	//{
		//return this[4];
	//}
	//
	//inline function get_topRightY():Float 
	//{
		//return this[5];
	//}
	//
	//inline function get_bottomRightX():Float 
	//{
		//return this[6];
	//}
	//
	//inline function get_bottomRightY():Float 
	//{
		//return this[7];
	//}
	
	inline function get_middleX():Float 
	{
		return topLeftX + ((topRightX - topLeftX) * 0.5);
	}
	
	inline function get_middleY():Float 
	{
		return topLeftY + ((bottomLeftY - topLeftY) * 0.5);
	}
	
	
	
	
	
	//inline function set_bottomLeftX(value:Float):Float 
	//{
		//return this[0] = value;
	//}
	//
	//inline function set_bottomLeftY(value:Float):Float 
	//{
		//return this[1] = value;
	//}
	//
	//inline function set_topLeftX(value:Float):Float 
	//{
		//return this[2] = value;
	//}
	//
	//inline function set_topLeftY(value:Float):Float 
	//{
		//return this[3] = value;
	//}
	//
	//inline function set_topRightX(value:Float):Float 
	//{
		//return this[4] = value;
	//}
	//
	//inline function set_topRightY(value:Float):Float 
	//{
		//return this[5] = value;
	//}
	//
	//inline function set_bottomRightX(value:Float):Float 
	//{
		//return this[6] = value;
	//}
	//
	//inline function set_bottomRightY(value:Float):Float 
	//{
		//return this[7] = value;
	//}
	
	function toString():String
	{
		return bottomLeftX + ", " + bottomLeftY + ", " + topLeftX + ", " + topLeftY + ", " + topRightX + ", " + topRightY + ", " + bottomRightX + ", " + bottomRightY;
	}
}