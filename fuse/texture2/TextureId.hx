package fuse.texture2;

/**
 * ...
 * @author P.J.Shand
 */
abstract TextureId(Int) from Int to Int from UInt to UInt {
	
	static var count:Int = 0;
	static public var next(get, null):Int;
	
	public inline function new (id:Int = 0) {
		this = id;	
	}
	
	static function get_next():Int 
	{
		return count++;
	}
}