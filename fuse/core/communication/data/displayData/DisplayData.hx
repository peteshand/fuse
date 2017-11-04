package fuse.core.communication.data.displayData;
import fuse.Fuse;
import fuse.core.communication.data.MemoryBlock;

/**
 * ...
 * @author P.J.Shand
 */
class DisplayData implements IDisplayData
{
	@:isVar public var x(get, set):Float = 0;
	@:isVar public var y(get, set):Float = 0;
	@:isVar public var width(get, set):Float = 0;
	@:isVar public var height(get, set):Float = 0;
	@:isVar public var pivotX(get, set):Float = 0;
	@:isVar public var pivotY(get, set):Float = 0;
	@:isVar public var scaleX(get, set):Float = 0;
	@:isVar public var scaleY(get, set):Float = 0;
	@:isVar public var rotation(get, set):Float = 0;
	@:isVar public var alpha(get, set):Float = 0;
	@:isVar public var color(get, set):Int = 0;
	@:isVar public var textureId(get, set):Int = 0;
	@:isVar public var renderLayer(get, set):Int = 0;
	
	@:isVar public var isStatic(get, set):Int = 0;
	@:isVar public var visible(get, set):Int = 0;
	
	private var _objectId:Int;
	public var objectId(get, null):Int;
	
	public function new(objectOffset:Null<Int>) 
	{
		_objectId = objectOffset;
	}
	
	inline function get_x():Float { 
		return x;
	}
	
	inline function get_y():Float { 
		return y;
	}
	
	inline function get_width():Float { 
		return width;
	}
	
	inline function get_height():Float { 
		return height;
	}
	
	inline function get_pivotX():Float { 
		return pivotX;
	}
	
	inline function get_pivotY():Float { 
		return pivotY;
	}
	
	inline function get_scaleX():Float { 
		return scaleX;
	}
	
	inline function get_scaleY():Float { 
		return scaleY;
	}
	
	inline function get_rotation():Float { 
		return rotation;
	}
	
	inline function get_alpha():Float { 
		return alpha;
	}
	
	inline function get_color():Int { 
		return color;
	}
	
	inline function get_textureId():Int { 
		return textureId;
	}
	
	inline function get_renderLayer():Int { 
		return renderLayer;
	}
	
	
	inline function get_isStatic():Int { 
		return isStatic;
	}
	
	inline function get_visible():Int { 
		return visible;
	}
	
	
	inline function get_objectId():Int
	{
		return _objectId;
	}
	
	
	inline function set_x(value:Float):Float { 
		return x = value;
	}
	
	inline function set_y(value:Float):Float { 
		return y = value;
	}
	
	inline function set_width(value:Float):Float { 
		return width = value;
	}
	
	inline function set_height(value:Float):Float { 
		return height = value;
	}
	
	inline function set_pivotX(value:Float):Float { 
		return pivotX = value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		return pivotY = value;
	}
	
	inline function set_scaleX(value:Float):Float { 
		return scaleX = value;
	}
	
	inline function set_scaleY(value:Float):Float { 
		return scaleY = value;
	}
	
	inline function set_rotation(value:Float):Float { 
		return rotation = value;
	}
	
	inline function set_alpha(value:Float):Float { 
		return alpha = value;
	}
	
	inline function set_color(value:Int):Int { 
		return color = value;
	}
	
	inline function set_textureId(value:Int):Int { 
		return textureId = value;
	}
	
	inline function set_renderLayer(value:Int):Int { 
		return renderLayer = value;
	}
	
	inline function set_isStatic(value:Int):Int { 
		return isStatic = value;
	}
	
	inline function set_visible(value:Int):Int { 
		return visible = value;
	}
}