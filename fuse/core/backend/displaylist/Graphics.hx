package fuse.core.backend.displaylist;

import fuse.utils.GcoArray;
import fuse.math.FastMatrix3;

/**
 * ...
 * @author P.J.Shand
 */
class Graphics
{
	public static var transformation(get, set):FastMatrix3;
	static public var alpha:Float = 1;
	static var transformations:GcoArray<FastMatrix3>;
	static var alphas:GcoArray<Float>;
	
	static var count:Int = 0;
	
	static function __init__():Void
	{
		transformations = new GcoArray<FastMatrix3>([]);
		transformations.push(FastMatrix3.identity());
		
		alphas = new GcoArray<Float>([]);
		alphas.push(1);
	}
	
	public function new() { }
	
	public static inline function pushTransformation(transformation:FastMatrix3/*, renderId:Int*/): Void {
		transformations.push(transformation);
	}
	
	public static inline function popTransformation(): FastMatrix3 {
		var ret = transformations.pop();
		return ret;
	}
	
	static public function pushAlpha(alpha:Float) 
	{
		Graphics.alpha = alpha;
		alphas.push(alpha);
	}
	
	static public function popAlpha() 
	{
		alphas.length = alphas.length - 1;
		Graphics.alpha = alphas[alphas.length - 1];
	}
	
	private static inline function set_transformation(transformation: FastMatrix3): FastMatrix3 {
		return transformations[transformations.length - 1] = transformation;
	}
	
	private static inline function get_transformation(): FastMatrix3 {
		return transformations[transformations.length - 1];
	}
}