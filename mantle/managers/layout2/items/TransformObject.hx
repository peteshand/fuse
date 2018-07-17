package mantle.managers.layout2.items;
import mantle.managers.layout2.settings.AnchorSettings;
import mantle.managers.layout2.container.DLLayoutContainer;
import mantle.managers.layout2.container.ILayoutContainer;
import mantle.managers.layout2.container.LayoutContainer;
import mantle.managers.layout2.settings.AnchorSettings.Fraction;
import mantle.managers.layout2.settings.LayoutSettings;
import mantle.managers.layout2.settings.LayoutScale;
import mantle.managers.layout2.LayoutManager;
import mantle.managers.resize.Resize;
import mantle.delay.Delay;
import openfl.display.DisplayObject;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import starling.display.DisplayObject;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.Lib;


/**
 * ...
 * @author P.J.Shand
 */
class TransformObject implements ITransformObject implements IInternetTransformObject
{
	public var _scaleX:Float;
	public var _scaleY:Float;
	
	private var layoutContainer:ILayoutContainer;
	private var layoutSettings:LayoutSettings;
	private var stageRatio:Float = 1;
	private var transformationMatrix:Matrix;
	
	private var frameWidth:Float;
	private var frameHeight:Float;
	public var displayObject:Dynamic;
	private var stage:Stage;
	var anchorBounds:RectDef;
	
	private var transformAnchor(get, null):Bool;
	private var transformScale(get, null):Bool;
	private var transformAlign(get, null):Bool;
	
	
	public var _scaleContainerScaleX:Float = 1;
	public var _scaleContainerScaleY:Float = 1;
	public var _alignX:Float;
	public var _alignY:Float;
	public var _anchorX:Float;
	public var _anchorY:Float;
	
	public var scaleContainerScaleX(null, set):Float;
	public var scaleContainerScaleY(null, set):Float;
	public var alignX(null, set):Float;
	public var alignY(null, set):Float;
	public var anchorX(null, set):Float;
	public var anchorY(null, set):Float;
	
	private function set_scaleContainerScaleX(value:Float):Float
	{
		return _scaleContainerScaleX = value;
	}
	
	private function set_scaleContainerScaleY(value:Float):Float
	{
		return _scaleContainerScaleY = value;
	}
	
	private function set_alignX(value:Float):Float
	{
		return _alignX = value;
	}
	
	private function set_alignY(value:Float):Float
	{
		return _alignY = value;
	}
	
	private function set_anchorX(value:Float):Float
	{
		return _anchorX = value;
	}
	
	private function set_anchorY(value:Float):Float
	{
		return _anchorY = value;
	}
	
	
	public function new(_displayObject:Dynamic, _layoutSettings:LayoutSettings=null) 
	{
		displayObject = _displayObject;
		layoutSettings = _layoutSettings;
		if (layoutSettings == null) layoutSettings = new LayoutSettings();
		
		transformationMatrix = new Matrix();
		stage = LayoutManager.stage;
		
		if (Std.is(displayObject, openfl.display.DisplayObject)) {
			layoutContainer = new DLLayoutContainer(displayObject, layoutSettings);
			transformationMatrix = layoutContainer.transform;
		}
		else if (Std.is(displayObject, starling.display.DisplayObject)) {
			layoutContainer = new LayoutContainer(displayObject, layoutSettings);
			transformationMatrix = layoutContainer.transform;
		}
		
		Resize.remove(OnStageResize);
		Resize.add(OnStageResize);
		
		TriggerResize();
	}
	
	function TriggerResize() 
	{
		OnStageResize();
		Delay.killDelay(OnStageResize);
		Delay.nextFrame(OnStageResize);
	}
	
	private function OnStageResize() 
	{
		if (transformAnchor == true || transformScale == true || transformAlign == true) {
			transformationMatrix.identity();
			
			calculateScale();
			calcAlignment();
			calcAnchor();
			
			if (transformAnchor == true) transformationMatrix.translate(_anchorX, _anchorY);
			if (transformScale == true) transformationMatrix.scale(_scaleContainerScaleX, _scaleContainerScaleY);
			if (transformAlign == true) transformationMatrix.translate(_alignX, _alignY);
			layoutContainer.transform = transformationMatrix;
		}
	}
	
	private function calculateScale():Void 
	{
		stageRatio = stage.stageWidth / stage.stageHeight;
		
		var _hScale = layoutSettings.hScale;
		var _vScale = layoutSettings.vScale;
		
		if (_hScale == LayoutScale.NONE) {
			hScaleNone();
		}
		else if (_hScale == LayoutScale.STRETCH) {
			hStretch();
		}
		else if (_hScale == LayoutScale.LETTERBOX) {
			hLetterbox();
		}
		else if (_hScale == LayoutScale.CROP) {
			hCrop();
		}
		else if (_hScale == LayoutScale.HORIZONTAL) {
			hScaleToHorizontal();
		}
		else if (_hScale == LayoutScale.VERTICAL) {
			hScaleToVertical();
		}
		else {
			if (_hScale == LayoutScale.MAXIMUM) {
				if (stageRatio > LayoutManager.assetDimensionsRatio()) { // Width is max, Height is min
					hScaleToHorizontal();
				}
				else { // Height is max, Width is min
					hScaleToVertical();
				}
			}
			else if (_hScale == LayoutScale.MINIMUM) {
				if (stageRatio > LayoutManager.assetDimensionsRatio()) { // Width is max, Height is min
					hScaleToVertical();
				}
				else { // Height is max, Width is min
					hScaleToHorizontal();
				}
			}
		}
		
		if (_vScale == LayoutScale.NONE) {
			vScaleNone();
		}
		else if (_vScale == LayoutScale.STRETCH) {
			vStretch();
		}
		else if (_vScale == LayoutScale.LETTERBOX) {
			vLetterbox();
		}
		else if (_vScale == LayoutScale.CROP) {
			vCrop();
		}
		else if (_vScale == LayoutScale.HORIZONTAL) {
			vScaleToHorizontal();
		}
		else if (_vScale == LayoutScale.VERTICAL) {
			vScaleToVertical();
		}
		else {
			if (_vScale == LayoutScale.MAXIMUM) {
				if (stageRatio > LayoutManager.assetDimensionsRatio()) { // Width is max, Height is min
					vScaleToHorizontal();
				}
				else { // Height is max, Width is min
					vScaleToVertical();
				}

			}
			else if (_vScale == LayoutScale.MINIMUM) {
				if (stageRatio > LayoutManager.assetDimensionsRatio()) { // Width is max, Height is min
					vScaleToVertical();
				}
				else { // Height is max, Width is min
					vScaleToHorizontal();
				}
			}
		}
		
		if (layoutSettings.scaleRounding != -1) {
			_scaleContainerScaleX = round(_scaleContainerScaleX, layoutSettings.scaleRounding);
			_scaleContainerScaleY = round(_scaleContainerScaleY, layoutSettings.scaleRounding);
		}
	}
	
	function round(scaleContainerScaleX:Float, r:Float):Float
	{
		var returnVal = Math.round((scaleContainerScaleX) / r) * r;
		if (returnVal < r) returnVal = r;
		return returnVal;
	}
	
	public static function getNextPowerOfTwo(number:Int):Int
	{
		if (number > 0 && (number & (number - 1)) == 0) // see: http://goo.gl/D9kPj
			return number;
		else
		{
			var result:Int = 1;
			while (result < number) result <<= 1;
			return result;
		}
	}
	
	private function hScaleNone():Void 
	{
		scaleContainerScaleX = 1;
	}
	
	private function hStretch():Void 
	{
		var bounds:RectDef = layoutSettings.bounds;
		if (bounds == null) bounds = layoutContainer.bounds;
		scaleContainerScaleX = stage.stageWidth / bounds.width;
	}
	
	private function hLetterbox():Void 
	{
		var bounds:RectDef = layoutSettings.bounds;
		if (bounds == null) bounds = layoutContainer.bounds;
		if (stage.stageWidth / stage.stageHeight > bounds.width / bounds.height) {
			scaleContainerScaleX = stage.stageHeight / bounds.height;
		}
		else {
			scaleContainerScaleX = stage.stageWidth / bounds.width;
		}
	}
	
	private function hCrop():Void 
	{
		var bounds:RectDef = layoutSettings.bounds;
		if (bounds == null) bounds = layoutContainer.bounds;
		if (stage.stageWidth / stage.stageHeight > bounds.width / bounds.height) {
			scaleContainerScaleX = stage.stageWidth / bounds.width;
		}
		else {
			scaleContainerScaleX = stage.stageHeight / bounds.height;
		}
	}
	
	private function hScaleToVertical():Void 
	{
		scaleContainerScaleX = stage.stageHeight / LayoutManager.assetDimensions.height;
	}
	
	private function hScaleToHorizontal():Void 
	{
		scaleContainerScaleX = stage.stageWidth / LayoutManager.assetDimensions.width;
	}
	
	private function vScaleNone():Void 
	{
		scaleContainerScaleY = 1;
	}
	
	private function vStretch():Void 
	{
		var bounds:RectDef = layoutSettings.bounds;
		if (bounds == null) bounds = layoutContainer.bounds;
		scaleContainerScaleY = stage.stageHeight / bounds.height;
	}
	
	private function vLetterbox():Void 
	{
		var bounds:RectDef = layoutSettings.bounds;
		if (bounds == null) bounds = layoutContainer.bounds;
		if (stage.stageWidth / stage.stageHeight > bounds.width / bounds.height) {
			scaleContainerScaleY = stage.stageHeight / bounds.height;
		}
		else {
			scaleContainerScaleY = stage.stageWidth / bounds.width;
		}
	}
	
	private function vCrop():Void 
	{
		var bounds:RectDef = layoutSettings.bounds;
		if (bounds == null) bounds = layoutContainer.bounds;
		if (stage.stageWidth / stage.stageHeight > bounds.width / bounds.height) {
			scaleContainerScaleY = stage.stageWidth / bounds.width;
		}
		else {
			scaleContainerScaleY = stage.stageHeight / bounds.height;
		}
	}
	
	private function vScaleToVertical():Void 
	{
		scaleContainerScaleY = stage.stageHeight / LayoutManager.assetDimensions.height;
	}
	
	private function vScaleToHorizontal():Void 
	{
		scaleContainerScaleY = stage.stageWidth / LayoutManager.assetDimensions.width;
	}
	
	private function calcAlignment():Void 
	{
		var frame = layoutSettings.frame;
		if (frame == null) {
			frameWidth = stage.stageWidth;
			frameHeight = stage.stageHeight;
		}
		else {
			frameWidth = Reflect.getProperty(frame, "width");
			frameHeight = Reflect.getProperty(frame, "height");
		}
		
		var _alignX:Float = 0;
		var _alignY:Float = 0;
		if (layoutSettings.align.fraction.x != null) _alignX += (layoutSettings.align.fraction.x * frameWidth);
		if (layoutSettings.align.fraction.y != null) _alignY += (layoutSettings.align.fraction.y * frameHeight);
		if (layoutSettings.align.pixels.x != null) _alignX += layoutSettings.align.pixels.x;
		if (layoutSettings.align.pixels.y != null) _alignY += layoutSettings.align.pixels.y;
		
		alignX = Math.round(_alignX);
		alignY = Math.round(_alignY);
	}
	
	private function calcAnchor():Void 
	{
		var pixels:Fraction = layoutSettings.anchor.pixels;
		var fraction:Fraction = layoutSettings.anchor.fraction;
		if (fraction.x == null) fraction.x = layoutSettings.align.fraction.x;
		if (fraction.y == null) fraction.y = layoutSettings.align.fraction.y;
		
		var _anchorX:Float = 0;
		var _anchorY:Float = 0;
		
		if (layoutSettings.updateBounds || anchorBounds == null) {
			anchorBounds = layoutSettings.bounds;
			if (anchorBounds == null) anchorBounds = layoutContainer.bounds;
		}
		if (anchorBounds != null){
			if (fraction.x != null) _anchorX = (fraction.x * -anchorBounds.width);
			if (fraction.y != null) _anchorY = (fraction.y * -anchorBounds.height);
			
			_anchorX -= anchorBounds.x;
			_anchorY -= anchorBounds.y;
		}
		
		if (pixels.x != null) _anchorX -= pixels.x;
		if (pixels.y != null) _anchorY -= pixels.y;
		
		this.anchorX = Math.round(_anchorX);
		this.anchorY = Math.round(_anchorY);
	}
	
	public function align(fractionX:Float=0, fractionY:Float=0, pixelX:Float=0, pixelY:Float=0):ITransformObject
	{
		layoutSettings.align.fraction.x = fractionX;
		layoutSettings.align.fraction.y = fractionY;
		layoutSettings.align.pixels.x = pixelX;
		layoutSettings.align.pixels.y = pixelY;
		
		TriggerResize();
		return this;
	}
	
	public function anchor(fractionX:Float = 0, fractionY:Float = 0, pixelX:Float = 0, pixelY:Float = 0):ITransformObject
	{
		layoutSettings.anchor.fraction.x = fractionX;
		layoutSettings.anchor.fraction.y = fractionY;
		layoutSettings.anchor.pixels.x = pixelX;
		layoutSettings.anchor.pixels.y = pixelY;
		
		TriggerResize();
		return this;
	}
	
	public function frame(value:Dynamic):ITransformObject
	{
		layoutSettings.frame = value;
		TriggerResize();
		return this;
	}
	
	public function bounds(rectDef:RectDef):ITransformObject
	{
		layoutSettings.bounds = rectDef;
		TriggerResize();
		return this;
	}
	
	public function updateBounds(value:Bool):ITransformObject
	{
		layoutSettings.updateBounds = value;
		TriggerResize();
		return this;
	}
	
	public function scale(value:LayoutScale, scaleRounding:Float=-1):ITransformObject
	{
		layoutSettings.scale = value;
		layoutSettings.scaleRounding = scaleRounding;
		TriggerResize();
		return this;
	}
	
	public function vScale(value:String):ITransformObject
	{
		layoutSettings.vScale = value;
		TriggerResize();
		return this;
	}
	
	public function hScale(value:String):ITransformObject
	{
		layoutSettings.hScale = value;
		TriggerResize();
		return this;
	}
	
	public function nest(value:Bool):ITransformObject
	{
		layoutSettings.nest = value;
		layoutContainer.nested = value;
		if (transformationMatrix != null) {
			transformationMatrix.identity();
		}
		transformationMatrix = layoutContainer.transform;
		TriggerResize();
		return this;
	}
	
	function get_transformAnchor():Bool 
	{
		return layoutSettings.anchor.fraction.x != null 
			|| layoutSettings.anchor.fraction.y != null 
			|| layoutSettings.anchor.pixels.x != null 
			|| layoutSettings.anchor.pixels.y != null;
	}
	
	function get_transformScale():Bool 
	{
		return layoutSettings.hScale != LayoutScale.NONE || layoutSettings.vScale != LayoutScale.NONE;
	}
	
	function get_transformAlign():Bool 
	{
		return layoutSettings.align.fraction.x != null 
			|| layoutSettings.align.fraction.y != null 
			|| layoutSettings.align.pixels.x != null 
			|| layoutSettings.align.pixels.y != null;
	}
	
	public function dispose() 
	{
		Resize.remove(OnStageResize);
	}
	
	public function resize():ITransformObject
	{
		TriggerResize();
		return this;
	}
}