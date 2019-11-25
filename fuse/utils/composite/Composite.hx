package fuse.utils.composite;

import openfl.geom.Matrix;
import fuse.geom.Rectangle;
import fuse.display.DisplayObject;
import fuse.utils.Align;

/**
 * ...
 * @author Pete Shand
 */
/**
 * Dimension Calculator.
 * This class is used to calculate the aspect ratio to use to best fit a Display Object
 * into a specified area while maintaining the correct aspect ratio.
 */
class Composite {
	public static var displayRatio:Float;
	public static var objectRatio:Float;
	private static var _rectangle:Rectangle = new Rectangle();
	public static var width(get, null):Float;
	public static var height(get, null):Float;
	public static var x(get, null):Float;
	public static var y(get, null):Float;
	public static var rectangle(get, null):Rectangle;

	static public function calcMatrix(boundWidth:Float, boundHeight:Float, objectWidth:Float, objectHeight:Float, zoomType:CompositeMode):Matrix {
		var rect:Rectangle = fit(boundWidth, boundHeight, objectWidth, objectHeight, zoomType);
		var m:Matrix = new Matrix();
		var sx:Float = rect.width / objectWidth;
		var sy:Float = rect.height / objectHeight;
		var tx:Float = (boundWidth - rect.width) * 0.5;
		var ty:Float = (boundHeight - rect.height) * 0.5;
		m.scale(sx, sy);
		m.translate(tx, ty);
		return m;
	}

	/**
	 * Calculate the dimensions and aspect ratio to use to fit the object Display.
	 *
	 * @param	boundWidth The width of the display area.
	 * @param	boundHeight The height of the display area.
	 * @param	objectWidth The width of the display object.
	 * @param	objectHeight The height of the display object.
	 * @param	zoomType This defines which display type to use. Possibilities include Normal, Zoom, Original, or Stretch.
	 * @return  newDimensions An array containing the width, height, X position, and Y position to use to best fit the object display.
	 */
	public static function fit(boundWidth:Float, boundHeight:Float, objectWidth:Float, objectHeight:Float, zoomType:CompositeMode = 0, ?alignH:Align,
			?alignV:Align, scale:Float = 1):Rectangle {
		if (alignH == null)
			alignH = Align.CENTER;
		if (alignV == null)
			alignV = Align.CENTER;

		displayRatio = boundWidth / boundHeight;
		objectRatio = objectWidth / objectHeight;

		if (zoomType == CompositeMode.LETTERBOX) {
			// trace("A");
			if (objectRatio < displayRatio)
				letterboxSides(boundWidth, boundHeight, alignH, alignV, scale);
			else
				letterboxTopBottom(boundWidth, boundHeight, alignH, alignV, scale);
		} else if (zoomType == CompositeMode.CROP) {
			// trace("B");
			if (objectRatio < displayRatio)
				letterboxTopBottom(boundWidth, boundHeight, alignH, alignV, scale);
			else
				letterboxSides(boundWidth, boundHeight, alignH, alignV, scale);
		} else if (zoomType == CompositeMode.FIT_WIDTH) {
			// trace("C");
			letterboxTopBottom(boundWidth, boundHeight, alignH, alignV, scale);
		} else if (zoomType == CompositeMode.FIT_HEIGHT) {
			// trace("D");
			letterboxSides(boundWidth, boundHeight, alignH, alignV, scale);
		} else if (zoomType == CompositeMode.ORIGINAL) {
			// trace("E");
			rectangle.width = Math.round(objectWidth);
			rectangle.height = Math.round(objectHeight);
			rectangle.x = Math.round((boundWidth - rectangle.width) * untyped alignH);
			rectangle.y = Math.round((boundHeight - rectangle.height) * untyped alignV);
		} else if (zoomType == CompositeMode.STRETCH) {
			// trace("F");
			rectangle.width = Math.round(boundWidth);
			rectangle.height = Math.round(boundHeight);
			rectangle.x = 0;
			rectangle.y = 0;
		}

		// trace("rectangle.height = " + rectangle.height);

		return rectangle;
	}

	static inline function letterboxTopBottom(boundWidth:Float, boundHeight:Float, alignH:Align, alignV:Align, scale:Float = 1) {
		// trace("1");
		rectangle.width = Math.round(boundWidth * scale);
		rectangle.height = Math.round(boundWidth / objectRatio * scale);
		rectangle.x = Math.round((boundWidth - rectangle.width) * untyped alignH);
		rectangle.y = Math.round((boundHeight - rectangle.height) * untyped alignV);
	}

	static inline function letterboxSides(boundWidth:Float, boundHeight:Float, alignH:Align, alignV:Align, scale:Float = 1) {
		// trace("2");
		rectangle.width = Math.round(boundHeight * objectRatio * scale);
		rectangle.height = Math.round(boundHeight * scale);
		// trace("boundHeight = " + boundHeight);
		rectangle.x = Math.round((boundWidth - rectangle.width) * untyped alignH);
		rectangle.y = Math.round((boundHeight - rectangle.height) * untyped alignV);
	}

	public static function get_width():Float {
		return rectangle.width;
	}

	public static function get_height():Float {
		return rectangle.height;
	}

	public static function get_x():Float {
		return rectangle.x;
	}

	public static function get_y():Float {
		return rectangle.y;
	}

	static public function get_rectangle():Rectangle {
		return _rectangle;
	}

	public static function setObject(display:DisplayObject):Void {
		display.width = width;
		display.height = height;
		display.x = x;
		display.y = y;
	}
}
