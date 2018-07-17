package mantle.managers.layout2;
import mantle.managers.layout2.items.ITransformObject;
import mantle.managers.layout2.items.TransformObject;
import mantle.managers.layout2.settings.LayoutSettings;
import flash.display.Stage;
import openfl.geom.Rectangle;
import openfl.Lib;
import starling.display.Image;

/**
 * ...
 * @author P.J.Shand
 */
class LayoutManager
{
	private static var transformObjects = new Array<TransformObject>();
	private static var _assetDimensions:Rectangle = new Rectangle(0, 0, 1920, 1080);
	
	/* assetDimensions defines the width and height of the assets used within the application. Default is 1920x1080 */
	public static var assetDimensions(get, set):Rectangle;
	public static var stage:Stage;
	
	public function new() 
	{
		
	}
	
	/* Adds a Starling or Displaylist display object to be controlled by the layout manager */
	public static function add(displayObject:Dynamic, layoutSettings:LayoutSettings=null):ITransformObject 
	{
		var transformObject = new TransformObject(displayObject, layoutSettings);
		transformObjects.push(transformObject);
		return transformObject;
	}
	
	public static function remove(displayObject:Dynamic):Void 
	{
		for (i in 0...transformObjects.length) 
		{
			if (transformObjects[i].displayObject == displayObject) {
				transformObjects[i].dispose();
				transformObjects.splice(i, 1);
			}
		}
	}
	
	#if swc @:getter(assetDimensions) #end
	public static function get_assetDimensions():Rectangle 
	{
		if (_assetDimensions == null) {
			_assetDimensions = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		}
		return _assetDimensions;
	}
	
	#if swc @:setter(assetDimensions) #end
	public static function set_assetDimensions(value:Rectangle):Rectangle 
	{
		return _assetDimensions = value;
	}
	
	public static function assetDimensionsRatio():Float 
	{
		if (assetDimensions == null) return 1;
		return assetDimensions.width / assetDimensions.height;
	}
}