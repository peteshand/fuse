package fuse.core.backend.displaylist;

import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.display.CoreImage;
import fuse.utils.GcoArray;
import fuse.math.FastMatrix3;

/**
 * ...
 * @author P.J.Shand
 */

class Graphics
{
	public static var transformation(get, never):FastMatrix3;
	//public static var isStatic(get, never):Int;
	//public static var isMoving(get, never):Int;
	static public var parent(get, never):CoreDisplayObject;
	//static public var alpha:Float = 1;
	//static public var visible:Bool = true;
	
	static var displays:GcoArray<CoreDisplayObject>;
	
	static var transformations:GcoArray<FastMatrix3>;
	//static var isStatics:GcoArray<Int>;
	//static var isMovings:GcoArray<Int>;
	//static var alphas:GcoArray<Float>;
	//static var visibles:GcoArray<Bool>;
	
	static var count:Int = 0;
	
	static function __init__():Void
	{
		var rootImage:CoreImage = new CoreImage();
		rootImage.updateAny = false;
		rootImage.updateAlpha = false;
		rootImage.updateColour = false;
		rootImage.updatePosition = false;
		rootImage.updateVisible = false;
		rootImage.updateRotation = false;
		rootImage.updateTexture = false;
		
		displays = new GcoArray<CoreDisplayObject>();
		displays.push(rootImage);
		
		transformations = new GcoArray<FastMatrix3>();
		transformations.push(FastMatrix3.identity());
		
		//isStatics = new GcoArray<Int>();
		//isStatics.push(1);
		
		//isMovings = new GcoArray<Int>();
		//isMovings.push(0);
		
		//alphas = new GcoArray<Float>();
		//alphas.push(1);
		
		//visibles = new GcoArray<Bool>();
		//visibles.push(true);
	}
	
	public function new() { }
	
	public static inline function push(displayObject:CoreDisplayObject): Void {
		displays.push(displayObject);
	}
	
	public static inline function pop(): Void {
		displays.pop();
	}
	
	//public static inline function pushTransformation(transformation:FastMatrix3, isStatic:Int, isMoving:Int): Void {
		//transformations.push(transformation);
		//isStatics.push(isStatic);
		//isMovings.push(isMoving);
	//}
	//
	//public static inline function popTransformation(): FastMatrix3 {
		//var ret = transformations.pop();
		//isStatics.pop();
		//isMovings.pop();
		//return ret;
	//}
	
	//static public function pushAlpha(alpha:Float, visible:Bool) 
	//{
		//Graphics.alpha = alpha;
		//alphas.push(alpha);
		//
		//Graphics.visible = visible;
		//visibles.push(visible);
	//}
	//
	//static public function popAlpha() 
	//{
		//alphas.length = alphas.length - 1;
		//Graphics.alpha = alphas[alphas.length - 1];
		//
		//visibles.length = visibles.length - 1;
		//Graphics.visible = visibles[visibles.length - 1];
	//}
	
	private static inline function set_transformation(transformation: FastMatrix3): FastMatrix3 {
		
		return parent.transformData.localTransform = transformation;
		//return transformations[transformations.length - 1] = transformation;
	}
	
	private static inline function get_transformation(): FastMatrix3 {
		return parent.transformData.localTransform;
		//return transformations[transformations.length - 1];
	}
	
	//private static inline function get_isStatic():Int {
		//return parent.isStatic;
	//}
	//
	//static inline function get_isMoving():Int {
		//return parent.isMoving;
	//}
	
	static inline function get_parent():CoreDisplayObject 
	{
		return displays[displays.length - 1];
	}
}