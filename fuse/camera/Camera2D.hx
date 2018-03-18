package fuse.camera;

/**
 * ...
 * @author P.J.Shand
 */
class Camera2D
{
	@:isVar public var x(get, set):Float = 0;
	@:isVar public var y(get, set):Float = 0;
	public var hasUpdate:Bool = false;
	
	public function new() 
	{
		
	}
	
	function get_x():Float 
	{
		return x;
	}
	
	function set_x(value:Float):Float 
	{
		hasUpdate = true;
		return x = value;
	}
	
	function get_y():Float 
	{
		return y;
	}
	
	function set_y(value:Float):Float 
	{
		hasUpdate = true;
		return y = value;
	}
	
}