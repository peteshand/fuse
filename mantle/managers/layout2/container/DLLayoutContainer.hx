package mantle.managers.layout2.container;
import mantle.managers.layout2.settings.LayoutSettings;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

/**
 * ...
 * @author P.J.Shand
 */
class DLLayoutContainer implements ILayoutContainer
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
		return target.transform.matrix;
	}
	
	private function set_transform(valeu:Matrix):Matrix 
	{
		return target.transform.matrix = valeu;
	}
	
	function get_nested():Bool 
	{
		return _nested;
	}
	
	function set_nested(value:Bool):Bool 
	{
		if (_nested == value) return value;
		_nested = value;
		if (_nested) {
			target = nestSprite;
			if (displayObject.parent != null){
				displayObject.parent.addChild(nestSprite);
				nestSprite.addChild(displayObject);
			}
		}
		else {
			target = displayObject;
			if (nestSprite.parent != null){
				nestSprite.parent.addChild(displayObject);
				nestSprite.parent.removeChild(nestSprite);
			}
		}
		return _nested;
	}
}