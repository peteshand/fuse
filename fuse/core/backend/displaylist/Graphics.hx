package fuse.core.backend.displaylist;

import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.display.CoreImage;
import fuse.utils.GcoArray;
import fuse.math.FastMatrix3;

/**
 * ...
 * @author P.J.Shand
 */
class Graphics {
	public static var transformation(get, never):FastMatrix3;
	public static var parent(get, never):CoreDisplayObject;
	static var displays:GcoArray<CoreDisplayObject>;
	static var transformations:GcoArray<FastMatrix3>;
	static var count:Int = 0;

	static function __init__():Void {
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
	}

	public function new() {}

	public static inline function push(displayObject:CoreDisplayObject):Void {
		displays.push(displayObject);
	}

	public static inline function pop():Void {
		displays.pop();
	}

	private static inline function set_transformation(transformation:FastMatrix3):FastMatrix3 {
		return parent.transformData.localTransform = transformation;
	}

	private static inline function get_transformation():FastMatrix3 {
		return parent.transformData.localTransform;
	}

	static inline function get_parent():CoreDisplayObject {
		return displays[displays.length - 1];
	}
}
