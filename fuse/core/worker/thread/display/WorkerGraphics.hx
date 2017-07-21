package fuse.core.worker.thread.display;

import fuse.utils.GcoArray;
import fuse.math.FastMatrix3;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerGraphics
{
	public static var transformation(get, set): FastMatrix3;
	static var transformations: GcoArray<FastMatrix3>;
	
	static function __init__():Void
	{
		transformations = new GcoArray<FastMatrix3>([]);
		transformations.push(FastMatrix3.identity());
	}
	
	public function new() { }
	
	public static inline function pushTransformation(transformation:FastMatrix3, renderId:Int): Void {
		transformations.push(transformation);
	}
	
	public static inline function popTransformation(): FastMatrix3 {
		var ret = transformations.pop();
		return ret;
	}
	
	private static inline function set_transformation(transformation: FastMatrix3): FastMatrix3 {
		return transformations[transformations.length - 1] = transformation;
	}
	
	private static inline function get_transformation(): FastMatrix3 {
		return transformations[transformations.length - 1];
	}
}