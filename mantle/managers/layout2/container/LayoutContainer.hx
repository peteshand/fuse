package mantle.managers.layout2.container;

import mantle.managers.layout2.settings.LayoutSettings;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import starling.display.DisplayObject;
import starling.display.Sprite;

/**
 * ...
 * @author P.J.Shand
 */
class LayoutContainer implements ILayoutContainer
{
	private var displayObject:DisplayObject;
	private var spacer:Sprite;
	private var layoutSettings:LayoutSettings;
	public var bounds(get, null):Rectangle;
	public var transform(get, set):Matrix;
	
	private var _nested:Bool = false;
	public var nested(get, set):Bool;
	
	public var nestSprite:Sprite;
	private var target:DisplayObject;
	
	public function new(displayObject:DisplayObject, layoutSettings:LayoutSettings) 
	{
		this.layoutSettings = layoutSettings;
		this.displayObject = displayObject;
		nestSprite = new Sprite();
		this.target = displayObject;
		this.nested = layoutSettings.nest;
	}
	
	private function get_bounds():Rectangle 
	{
		return target.getBounds(target);
	}
	
	private function get_transform():Matrix 
	{
		return target.transformationMatrix;
	}
	
	private function set_transform(value:Matrix):Matrix 
	{
		return target.transformationMatrix = value;
	}
	
	private function get_nested():Bool 
	{
		return _nested;
	}
	
	private function set_nested(value:Bool):Bool 
	{
		if (_nested == value) return value;
		_nested = value;
		var index:Int;
		if (_nested) {
			target = nestSprite;
			if (displayObject.parent != null) {
				index = displayObject.parent.getChildIndex(displayObject);
				displayObject.parent.addChildAt(nestSprite, index);
				nestSprite.addChild(displayObject);
			}
		}
		else {
			target = displayObject;
			if (nestSprite.parent != null) {
				index = nestSprite.parent.getChildIndex(nestSprite);
				nestSprite.parent.addChildAt(displayObject, 0);
				nestSprite.parent.removeChild(nestSprite);
			}
		}
		return _nested;
	}
}