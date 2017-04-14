package kea.display;

import kha.Color;
import kha.FastFloat;
import kea.display.Stage;
import kea.notify.Notifier;
import kea.atlas.AtlasObject;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;
//import kea.util.RenderUtils;

import kea.core.Kea;

class DisplayObject implements IDisplay
{
	public var stage:Stage;
	public var parent:DisplayObject;
	
	//private static var atlases = new Map<kha.Image,AtlasObject>();
	//@:isVar public var atlas(get, null):AtlasObject;
	public var atlas:AtlasObject;
	public var base:kha.Image;
	//@:isVar public var base(get, null):kha.Image;
	public var previous:IDisplay;
	
	@:isVar public var x(default, set):Float = 0;
	@:isVar public var y(default, set):Float = 0;
	@:isVar public var width(default, set):Float = 0;
	@:isVar public var height(default, set):Float = 0;
	@:isVar public var pivotX(default, set):Float = 0;
	@:isVar public var pivotY(default, set):Float = 0;
	@:isVar public var rotation(default, set):FastFloat = 0;
	@:isVar public var scaleX(default, set):FastFloat = 1;
	@:isVar public var scaleY(default, set):FastFloat = 1;
	@:isVar public var color(default, set):Color = 0xFFFFFFFF;
	@:isVar public var alpha(default, set):Float = 1;
	
	var _totalNumChildren:Int;
	public var totalNumChildren(get, null):Int;
	
	
	public var _renderIndex:Null<Int> = 0x3FFFFFFF;
	public var renderIndex(get, null):Null<Int>;

	public var name:String;

	public var children:Array<IDisplay>;
	//public var changeAvailable:Bool;
	//public var transformAvailable = new Notifier<Bool>(null);
	//@:isVar public var changeAvailable(get, null):Bool;
	public var staticCount = new Notifier<Int>(1);
	//public var alwaysRender:Bool = false;

	var scaleMatrix:FastMatrix3;
	var rotationMatrix:FastMatrix3;
	var translateMatrix:FastMatrix3;
	var matrix:FastMatrix3;
	
	var applyRotation:Bool = false;

	var _matrix:FastMatrix3;
	var positionMatrix:FastMatrix3;
	var rotMatrix1:FastMatrix3;
	var rotMatrix2:FastMatrix3;
	
	static var clearMatrix:FastMatrix3;
	static function __init__():Void
	{
		clearMatrix = FastMatrix3.identity();
	}
	
	public function new()
	{
		_matrix = FastMatrix3.empty();
		positionMatrix = FastMatrix3.empty();
		rotMatrix1 = FastMatrix3.empty();
		rotMatrix2 = FastMatrix3.empty();
		
		staticCount.add(onStaticCountChange);
	}
	
	function onStaticCountChange():Void
	{
		if (staticCount.value == 0){
			//RenderUtils.addToChangeList(this);
			Kea.current.layerDef.add(this);
		}
	}

	public function prerender(graphics:Graphics):Void
	{
		//fastMatrix3._00 = scaleX;
		//fastMatrix3._11 = scaleY;
		
		graphics.pushOpacity(graphics.opacity * alpha);
		graphics.color = color.value;
		
		clear();
		setScale();
		setPosition();
		setRotation();
		pushTransform(graphics);
		
		
	}
	
	function clear() 
	{
		_matrix.setFrom(clearMatrix);
	}

	function setScale() 
	{
		_matrix._00 = scaleX;
		_matrix._11 = scaleY;
	}
	
	function setPosition() 
	{
		_matrix = translation(positionMatrix, x, y).multmat(_matrix);
	}
	
	function setRotation() 
	{
		if (applyRotation) {
			_matrix = translation(rotMatrix1, _matrix._20, _matrix._21)
					.multmat(rotateMatrix(rotMatrix2, rotation / 180 * Math.PI))
					.multmat(translation(rotMatrix1, -_matrix._20, -_matrix._21))
					.multmat(_matrix);
		}
	}
	
	function pushTransform(graphics:Graphics) 
	{
		graphics.pushTransformation(_matrix);
	}
	
	function rotateMatrix(m:FastMatrix3, rotation: FastFloat):FastMatrix3
	{
		return setMatrix(m, 
			Math.cos(rotation), -Math.sin(rotation), 0,
			Math.sin(rotation), Math.cos(rotation), 0,
			0, 0, 1
		);
	}

	function translation(m:FastMatrix3, x: FastFloat, y: FastFloat):FastMatrix3
	{
		return setMatrix(m, 
			1, 0, x,
			0, 1, y,
			0, 0, 1
		);
	}

	function setMatrix(m:FastMatrix3, _00:FastFloat, _10:FastFloat, _20:FastFloat, _01:FastFloat, _11:FastFloat, _21:FastFloat, _02:FastFloat, _12:FastFloat, _22:FastFloat):FastMatrix3
	{
		m._00 = _00;
		m._10 = _10;
		m._20 = _20;
		
		m._01 = _01;
		m._11 = _11;
		m._21 = _21;
		
		m._02 = _02;
		m._12 = _12;
		m._22 = _22;

		return m;
	}
	
	public function render(graphics:Graphics): Void
	{
		
	}
	
	public function postrender(graphics:Graphics):Void
	{
		graphics.popTransformation();
		graphics.popOpacity();

		staticCount.value++;
	}
	
	inline function set_x(value:Float):Float { 
		if (x != value){
			x = value;
			staticCount.value = 0;
		}
		return value;
	}
	inline function set_y(value:Float):Float { 
		if (y != value){
			y = value;
			staticCount.value = 0;
		}
		return value;
	}
	
	inline function set_width(value:Float):Float { 
		if (width != value){
			width = value;
			staticCount.value = 0;
		}
		return value;
	}
	
	inline function set_height(value:Float):Float { 
		if (height != value){
			height = value;
			staticCount.value = 0;
		}
		return value;
	}
	
	inline function set_pivotX(value:Float):Float { 
		if (pivotX != value){
			pivotX = value;
			staticCount.value = 0;
		}
		return value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		if (pivotY != value){
			pivotY = value;
			staticCount.value = 0;
		}
		return value;
	}
	
	inline function set_rotation(value:FastFloat):FastFloat { 
		if (rotation != value){
			rotation = value;
			applyRotation = true;
			staticCount.value = 0;
		}
		return value;
	}
	
	inline function set_scaleX(value:FastFloat):FastFloat { 
		if (scaleX != value){
			scaleX = value;
			staticCount.value = 0;
		}
		return value;
	}
	
	inline function set_scaleY(value:FastFloat):FastFloat { 
		if (scaleY != value){
			scaleY = value;
			staticCount.value = 0;
		}
		return value;
	}
	
	inline function set_color(value:Color):Color { 
		if (color != value){
			color = value;
			staticCount.value = 0;
		}
		return value;
	}
	
	inline function set_alpha(value:Float):Float { 
		if (alpha != value){
			alpha = value;
			staticCount.value = 0;
		}
		return value;
	}
	
	
	/*inline function get_x():Float { return x; }
	inline function get_y():Float { return y; }
	inline function get_width():Float { return width; }
	inline function get_height():Float { return height; }
	inline function get_pivotX():Float { return pivotX; }
	inline function get_pivotY():Float { return pivotY; }
	inline function get_rotation():FastFloat { return rotation; }
	inline function get_scaleX():FastFloat { return scaleX; }
	inline function get_scaleY():FastFloat { return scaleY; }
	inline function get_color():Color { return color; }
	inline function get_alpha():Float { return alpha; }*/
	
	function get_totalNumChildren():Int
	{ 
		return 0;
	}
	
	function get_renderIndex():Null<Int> 
	{
		if (_renderIndex > Kea.current.updateList.lowestChange){
			UpdateRenderIndex();
		}
		//trace("_renderIndex = " + _renderIndex);
		return _renderIndex;
	}

	private function UpdateRenderIndex():Void
	{
		//Kea.current.updateList.lowestChange = _renderIndex = Kea.current.updateList.renderList.indexOf(this);
		if (previous == null){
			Kea.current.updateList.lowestChange = _renderIndex = 0;
		}
		else {
			Kea.current.updateList.lowestChange = _renderIndex = previous.renderIndex + 1;
		}
		//trace("new _renderIndex = " + _renderIndex + " name = " + this.name);
	}
}

