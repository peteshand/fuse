package kea.display;

import kea.core.render.Renderer;
import kea.display.DisplayObject;
import kha.Color;
import kha.FastFloat;
import kea.display.Stage;
import kea.notify.Notifier;
import kea.atlas.AtlasObject;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;
import msignal.Signal.Signal0;
//import kea.util.RenderUtils;

import kea.core.Kea;


class DisplayObject implements IDisplay
{
	static var objectIdCount:Int = 0;
	public var objectId:Int;
	public var stage:Stage;
	public var parent:DisplayObject;
	
	public var renderable:Bool;
	public var onAdd = new Signal0();
	//private static var atlases = new Map<kha.Image,AtlasObject>();
	//@:isVar public var atlas(get, null):AtlasObject;
	public var atlas(default, set):AtlasObject;
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

	var renderLine:Graphics -> Void;
	public var name:String;

	public var children:Array<IDisplay>;
	//public var changeAvailable:Bool;
	//public var transformAvailable = new Notifier<Bool>(null);
	//@:isVar public var changeAvailable(get, null):Bool;
	//public var staticCount = new Notifier<Int>(1);
	public var isStatic:Null<Bool> = false;
	public var isStatic2 = new Notifier<Null<Bool>>(false);
	
	//public var alwaysRender:Bool = false;

	var scaleMatrix:FastMatrix3;
	var rotationMatrix:FastMatrix3;
	var translateMatrix:FastMatrix3;
	var matrix:FastMatrix3;
	
	var applyPosition:Bool = false;
	var popAlpha:Bool = false;
	var applyRotation:Bool = false;
	
	var drawWidth:Float;
	var drawHeight:Float;
	
	var _matrix:FastMatrix3;
	var positionMatrix:FastMatrix3;
	var rotMatrix:FastMatrix3;
	var rotMatrix1:FastMatrix3;
	var rotMatrix2:FastMatrix3;
	var rotMatrix3:FastMatrix3;
	
	static var clearMatrix:FastMatrix3;
	static function __init__():Void
	{
		clearMatrix = FastMatrix3.identity();
	}
	
	@:access(kea.core.render.Renderer)
	public function new()
	{
		renderLine = renderImage;
		
		objectId = objectIdCount++;
		Kea.current.textureAtlas.setTexture(objectId, this);
		
		_matrix = FastMatrix3.empty();
		positionMatrix = FastMatrix3.identity();
		rotMatrix = FastMatrix3.identity();
		rotMatrix1 = FastMatrix3.identity();
		rotMatrix2 = FastMatrix3.identity();
		rotMatrix3 = FastMatrix3.identity();
		
		if (base != null){
			drawWidth = base.width;
			drawHeight = base.height;
		}
		
		isStatic2.add(OnStaticStateChange);
		
		//staticCount.add(onStaticCountChange);
		
		Renderer.layerStateChangeAvailable = true;
	}
	
	@:access(kea.core.render.Renderer)
	function OnStaticStateChange() 
	{
		//trace("isStatic2 = " + isStatic2.value);
		//if (isStatic2.value == false) {
			Renderer.layerStateChangeAvailable = true;
		//}
	}
	
	/*function onStaticCountChange():Void
	{
		if (staticCount.value == 0){
			//RenderUtils.addToChangeList(this);
			Kea.current.layerDef.add(this);
		}
	}*/

	public function prerender(graphics:Graphics):Void
	{
		//fastMatrix3._00 = scaleX;
		//fastMatrix3._11 = scaleY;
		
		//Kea.current.textureAtlas.setTexture(objectId, this);
		
		if (alpha != graphics.opacity) {
			graphics.pushOpacity(graphics.opacity * alpha);
			popAlpha = true;
		}
		graphics.color = color.value;
		
		clear();
		setScale();
		setPosition();
		setRotation();
		pushTransform(graphics);
	}
	
	inline function clear() 
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
		if (applyPosition) translation(positionMatrix, x, y);
		_matrix = positionMatrix.multmat(_matrix);
	}
	
	inline function setRotation() 
	{
		if (applyRotation) {
			/*rotMatrix = translation(rotMatrix1, _matrix._20, _matrix._21)
					.multmat(rotateMatrix(rotMatrix2, rotation / 180 * Math.PI))
					.multmat(translation(rotMatrix1, -_matrix._20, -_matrix._21));*/
			
			if (applyPosition){
				rotMatrix1 = translation(rotMatrix1, _matrix._20, _matrix._21);
				rotMatrix2 = rotateMatrix(rotMatrix2, rotation / 180 * Math.PI);
				rotMatrix3 = translation(rotMatrix3, -_matrix._20, -_matrix._21);
				multMatrix(rotMatrix1, rotMatrix2, rotMatrix);
				multMatrix(rotMatrix, rotMatrix3, rotMatrix);
			}
			else {
				rotMatrix2 = rotateMatrix(rotMatrix2, rotation / 180 * Math.PI);
				//rotMatrix = rotMatrix1.multmat(rotMatrix2).multmat(rotMatrix3);
				/*trace("rotMatrix1 = " + rotMatrix1);
				trace("rotMatrix2 = " + rotMatrix2);
				trace("rotMatrix3 = " + rotMatrix1);*/
				multMatrix(rotMatrix1, rotMatrix2, rotMatrix);
				multMatrix(rotMatrix, rotMatrix3, rotMatrix);
			}
		}
		_matrix = rotMatrix.multmat(_matrix);
	}
	
	inline function pushTransform(graphics:Graphics) 
	{
		graphics.pushTransformation(_matrix);
	}
	
	
	public inline function multMatrix(m1:FastMatrix3, m2:FastMatrix3, output:FastMatrix3):Void
	{	
		output._00 = m1._00 * m2._00 + m1._10 * m2._01 + m1._20 * m2._02;
		output._10 = m1._00 * m2._10 + m1._10 * m2._11 + m1._20 * m2._12;
		output._20 = m1._00 * m2._20 + m1._10 * m2._21 + m1._20 * m2._22;
		
		output._01 = m1._01 * m2._00 + m1._11 * m2._01 + m1._21 * m2._02;
		output._11 = m1._01 * m2._10 + m1._11 * m2._11 + m1._21 * m2._12;
		output._21 = m1._01 * m2._20 + m1._11 * m2._21 + m1._21 * m2._22;
		
		/*output._02 = m1._02 * m2._00 + m1._12 * m2._01 + m1._22 * m2._02;
		output._12 = m1._02 * m2._10 + m1._12 * m2._11 + m1._22 * m2._12;
		output._22 = m1._02 * m2._20 + m1._12 * m2._21 + m1._22 * m2._22;*/
	}
	
	inline function rotateMatrix(m:FastMatrix3, rotation: FastFloat):FastMatrix3
	{
		return setMatrix(m, 
			Math.cos(rotation), -Math.sin(rotation), 0,
			Math.sin(rotation), Math.cos(rotation), 0,
			0, 0, 1
		);
	}

	inline function translation(m:FastMatrix3, x: FastFloat, y: FastFloat):FastMatrix3
	{
		return setMatrix(m, 
			1, 0, x,
			0, 1, y,
			0, 0, 1
		);
	}

	inline function setMatrix(m:FastMatrix3, _00:FastFloat, _10:FastFloat, _20:FastFloat, _01:FastFloat, _11:FastFloat, _21:FastFloat, _02:FastFloat, _12:FastFloat, _22:FastFloat):FastMatrix3
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
	
	///////////////////////////////////////////////////////////////
	
	public function render(graphics:Graphics): Void
	{
		renderLine(graphics);
	}
	
	function renderImage(graphics:Graphics): Void
	{
		if (base != null) graphics.drawImage(base, -pivotX, -pivotY);
	}
	
	function renderAtlas(graphics:Graphics): Void
	{
		graphics.drawSubImage(atlas.texture, 
			-pivotX, -pivotY,
			atlas.x, atlas.y,
			drawWidth, drawHeight
		);
	}
	
	function set_atlas(value:AtlasObject):AtlasObject 
	{
		atlas = value;
		if (atlas == null) renderLine = renderImage;
		else renderLine = renderAtlas;
		return atlas;
	}
	
	///////////////////////////////////////////////////////////////
	
	public function checkStatic():Void
	{
		isStatic2.value = isStatic;
		isStatic = true;
	}
	
	public function postrender(graphics:Graphics):Void
	{
		graphics.popTransformation();
		if (popAlpha) graphics.popOpacity();
		
		//staticCount.value++;
		/*if (isStatic.value == false) isStatic.value = null;
		else if (isStatic == null) isStatic.value = true;*/
		
		
		//isStatic = true;
		
		applyPosition = false;
		popAlpha = false;
		applyRotation = false;
	}
	
	inline function set_x(value:Float):Float { 
		if (x != value){
			x = value;
			applyPosition = true;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	inline function set_y(value:Float):Float { 
		if (y != value){
			y = value;
			applyPosition = true;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_width(value:Float):Float { 
		if (width != value){
			width = value;
			applyPosition = true;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_height(value:Float):Float { 
		if (height != value){
			height = value;
			applyPosition = true;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_pivotX(value:Float):Float { 
		if (pivotX != value){
			pivotX = value;
			applyPosition = true;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		if (pivotY != value){
			pivotY = value;
			applyPosition = true;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_rotation(value:FastFloat):FastFloat { 
		if (rotation != value){
			rotation = value;
			applyRotation = true;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_scaleX(value:FastFloat):FastFloat { 
		if (scaleX != value){
			scaleX = value;
			applyPosition = true;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_scaleY(value:FastFloat):FastFloat { 
		if (scaleY != value){
			scaleY = value;
			applyPosition = true;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_color(value:Color):Color { 
		if (color != value){
			color = value;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_alpha(value:Float):Float { 
		if (alpha != value){
			alpha = value;
			//staticCount.value = 0;
			isStatic = false;
		}
		return value;
	}
	
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

