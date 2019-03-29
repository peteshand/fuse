package mantle.util;

import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.DisplayObject;

using Logger;

/**
 * ...
 * @author Pete Shand
 */

/**
 * Dimension Calculator.
 * This class is used to calculate the aspect ratio to use to best fit a Display Object 
 * into a specified area while maintaining the correct aspect ratio.
 */
class Dimensions
{
	public static var LETTERBOX:Int = 0;
	public static var ZOOM:Int = 1;
	public static var ORIGINAL:Int = 2;
	public static var STRETCH:Int = 3;
	
	public static var displayRatio:Float;
	public static var objectRatio:Float;
	
	private static var _rectangle:Rectangle = new Rectangle();
	
	public static var width(get, null):Float;
	public static var height(get, null):Float;
	public static var x(get, null):Float;
	public static var y(get, null):Float;
	public static var rectangle(get, null):Rectangle; 
	
	static public function calcMatrix(boundWidth:Float, boundHeight:Float, objectWidth:Float, objectHeight:Float, zoomType:Int=0):Matrix
	{
		var rect:Rectangle = calculate(boundWidth, boundHeight, objectWidth, objectHeight, zoomType);
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
	
	public static function calculate(boundWidth:Float, boundHeight:Float, objectWidth:Float, objectHeight:Float, zoomType:Int=0):Rectangle 
	{
		Dimensions.displayRatio = boundWidth / boundHeight;
		Dimensions.objectRatio = objectWidth / objectHeight;
		
		if (zoomType == Dimensions.LETTERBOX)
		{
			if (objectRatio < displayRatio) {
				Dimensions.rectangle.width = Math.round(boundHeight * objectRatio);	
				Dimensions.rectangle.height = Math.round(boundHeight);
				Dimensions.rectangle.x = Math.round((boundWidth - Dimensions.rectangle.width) / 2);
				Dimensions.rectangle.y = 0;
			}
			else {
				Dimensions.rectangle.width = Math.round(boundWidth);	
				Dimensions.rectangle.height = Math.round(boundWidth / objectRatio);
				Dimensions.rectangle.x = 0;
				Dimensions.rectangle.y = Math.round((boundHeight - Dimensions.rectangle.height) / 2);
			}
		}
		else if (zoomType == Dimensions.ZOOM)
		{
			if (objectRatio < displayRatio) {
				Dimensions.rectangle.width = Math.round(boundWidth);	
				Dimensions.rectangle.height = Math.round(boundWidth / objectRatio);
				Dimensions.rectangle.x = 0;
				Dimensions.rectangle.y = Math.round((boundHeight - Dimensions.rectangle.height) / 2);
			}
			else {
				Dimensions.rectangle.width = Math.round(boundHeight * objectRatio);	
				Dimensions.rectangle.height = Math.round(boundHeight);
				Dimensions.rectangle.x = Math.round((boundWidth - Dimensions.rectangle.width) / 2);
				Dimensions.rectangle.y = 0;
			}
		}
		else if (zoomType == Dimensions.ORIGINAL) {
			Dimensions.rectangle.width = Math.round(objectWidth);
			Dimensions.rectangle.height = Math.round(objectHeight);
			Dimensions.rectangle.x = Math.round((boundWidth - Dimensions.rectangle.width) / 2);
			Dimensions.rectangle.y = Math.round((boundHeight - Dimensions.rectangle.height) / 2);
		}
		else if (zoomType == Dimensions.STRETCH) {
			Dimensions.rectangle.width = Math.round(boundWidth);	
			Dimensions.rectangle.height = Math.round(boundHeight);
			Dimensions.rectangle.x = Math.round((boundWidth - Dimensions.rectangle.width) / 2);
			Dimensions.rectangle.y = Math.round((boundHeight - Dimensions.rectangle.height) / 2);
		}
		
		
		
		return Dimensions.rectangle;
	}
	
	public static function get_width():Float
	{
		return Dimensions.rectangle.width;
	}
	
	public static function get_height():Float
	{
		return Dimensions.rectangle.height;
	}
	
	public static function get_x():Float
	{
		return Dimensions.rectangle.x;
	}
	
	public static function get_y():Float
	{
		return Dimensions.rectangle.y;
	}
	
	static public function get_rectangle():Rectangle 
	{
		return _rectangle;
	}
	
	public static function setObject(object:DisplayObject):Void
	{
		object.width = Dimensions.width;
		object.height = Dimensions.height;
		object.x = Dimensions.x;
		object.y = Dimensions.y;
	}
}