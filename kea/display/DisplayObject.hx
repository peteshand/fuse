package kea.display;

import kea.display._private.PrivateDisplayBase;
import kea.logic.buffers.atlas.items.AtlasItem;
import kea.logic.displaylist.DisplayList;
import kea.logic.layerConstruct.LayerConstruct;
import kea.texture.Texture;
import kea.util.transform.TransformHelper;

import kea.logic.renderer.Renderer;
import kea.logic.layerConstruct.LayerConstruct.LayerDefinition;
import kea.display.BlendMode.BlendModeUtil;
import kea.display.DisplayObject;
import kea.util.MatrixUtils;
import kha.Color;
import kha.FastFloat;
import kea.display.Stage;
import kea.notify.Notifier;
import kha.graphics2.Graphics;
import kha.graphics4.PipelineState;
import kha.math.FastMatrix3;
import msignal.Signal.Signal0;

import kea.Kea;

@:access(kea)
class DisplayObject extends PrivateDisplayBase implements IDisplay
{
	public var name:String;
	
	public var parent:Sprite;
	public var base:Texture;
	public var onAdd = new Signal0();
	//public var previous:IDisplay;
	public var totalNumChildren(get, null):Int;
	//public var renderIndex(get, null):Null<Int>;
	public var children:Array<IDisplay>;
	
	//@:isVar public var isStatic(default, set):Null<Bool>;
	public var isStatic:Null<Bool>;
	public var isStatic2 = new Notifier<Null<Bool>>(false);
	public var layerDefinition:LayerDefinition;
	public var calcTransform:Graphics -> Void;
	var renderable:Bool = false;
	
	@:isVar public var stage(get, set):Stage;
	//@:isVar public var atlas(default, set):AtlasObject;
	@:isVar public var atlasItem(default, set):AtlasItem;
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
	@:isVar public var blendMode(default, set):BlendMode;
	@:isVar public var layerIndex(default, set):Null<Int> = null;
	
	var _totalNumChildren:Int;
	var _renderIndex:Null<Int> = 0x3FFFFFFF;
	var renderPath:Graphics -> Void;
	var applyPosition:Bool = false;
	var popAlpha:Bool = false;
	var applyRotation:Bool = false;
	var drawWidth:Float;
	var drawHeight:Float;
	var shaderPipeline:PipelineState;
	
	public function new()
	{
		super();
		
		layerIndex = 0;
		renderPath = renderImage;
		isStatic = false;
		
		if (base != null){
			drawWidth = base.width;
			drawHeight = base.height;
		}
		
		calcTransform = calcTransformDirect;
		isStatic2.add(OnStaticStateChange);
		
		Renderer.layerStateChangeAvailable = true;
	}
	
	public function update():Void
	{
		
	}
	
	public inline function checkStatic():Void
	{
		isStatic2.value = isStatic;
		isStatic = true;
	}
	
	public function buildHierarchy():Void
	{
		if (renderable) {
			Kea.current.logic.displayList.add(this);
		}
		if (children != null) {
			for (i in 0...children.length) 
			{
				children[i].buildHierarchy();
			}
		}
	}
	
	function OnStaticStateChange() 
	{
		if (isStatic2.value)	calcTransform = calcTransformCache;
		else 					calcTransform = calcTransformDirect;
		Renderer.layerStateChangeAvailable = true;
	}
	
	public function calcTransformCache(graphics:Graphics) 
	{
		//trace("Cache" + Kea.calcTransformIndex);
		
		/*if (renderable) {
			Kea.current.logic.displayList.renderList.push(this);
		}*/
		Kea.calcTransformIndex++;
		if (children != null) {
			var i:Int = 0;
			/*trace("Kea.calcTransformIndex   = " + Kea.calcTransformIndex);
			trace("children.length          = " + children.length);
			trace("layerDefinition.endIndex = " + layerDefinition.endIndex);
			trace("layerDefinition.length = " + layerDefinition.length);*/
			
			// TODO, fix this.. as it actually probably isn't going to work when dealing with complex nested objects
			/*if (Kea.calcTransformIndex + children.length > layerDefinition.endIndex) {
				i = layerDefinition.endIndex - Kea.calcTransformIndex;//layerDefinition.length;
				Kea.calcTransformIndex = i;
			}
			else if (Kea.calcTransformIndex + children.length >= layerDefinition.endIndex) {
				i = children.length - 1;// layerDefinition.endIndex - 2;
				Kea.calcTransformIndex = i;
			}*/
			
			while (i < children.length) 
			{
				//trace("i = " +i);
				children[i].calcTransform(graphics);
				i++;
			}
		}
	}
	
	public function calcTransformDirect(graphics:Graphics) 
	{
		pushTransform(graphics);
		
		/*if (renderable) {
			Kea.current.logic.displayList.renderList.push(this);
		}*/
		Kea.calcTransformIndex++;
		
		//trace("Direct" + Kea.calcTransformIndex);
		if (children != null) {
			for (i in 0...children.length) 
			{
				children[i].calcTransform(graphics);
			}
		}
		popTransform(graphics);
		
		
	}
	
	public function pushTransform(graphics:Graphics):Void
	{
		if (alpha != graphics.opacity) {
			graphics.pushOpacity(graphics.opacity * alpha);
			popAlpha = true;
		}
		//graphics.color = color.value;
		
		TransformHelper.clear(localTransform);
		setScale();
		
		if (atlasItem != null && atlasItem.rotation == 90) {
			TransformHelper.setPosition(applyPosition, positionMatrix, localTransform, x + atlasItem.height, y);
			TransformHelper.setRotation(applyRotation, applyPosition, localTransform, rotMatrix, rotMatrix1, rotMatrix2, rotMatrix3, rotation + atlasItem.rotation);
		}
		else {
			TransformHelper.setPosition(applyPosition, positionMatrix, localTransform, x, y);
			TransformHelper.setRotation(applyRotation, applyPosition, localTransform, rotMatrix, rotMatrix1, rotMatrix2, rotMatrix3, rotation);
		}
		
		graphics.pushTransformation(graphics.transformation.multmat(localTransform));
		globalTransform.setFrom(graphics.transformation);
	}
	
	function setScale() 
	{
		TransformHelper.setScale(localTransform, scaleX, scaleY, base, width, height);
	}
	
	
	
	
	
	///////////////////////////////////////////////////////////////
	
	public function render(graphics:Graphics): Void
	{
		graphics.pushTransformation(globalTransform);
		if (graphics.pipeline != shaderPipeline) {
			graphics.pipeline = shaderPipeline;
		}
		renderPath(graphics);
		graphics.popTransformation();
	}
	
	function renderImage(graphics:Graphics): Void
	{
		if (base != null) {
			graphics.color = color.value;
			graphics.drawImage(base, -pivotX, -pivotY);
			graphics.color = 0xFFFFFFFF;
		}
	}
	
	function renderAtlas(graphics:Graphics): Void
	{
		if (atlasItem.partition.value == null) return;
		/*if (atlasItem.partition == null) {
			renderImage(graphics);
			return;
		}*/
		graphics.color = color.value;
		graphics.drawSubImage(atlasItem.atlasTexture, 
			-pivotX, -pivotY,
			atlasItem.partition.value.x, atlasItem.partition.value.y,
			drawWidth, drawHeight
		);
		graphics.color = 0xFFFFFFFF;
	}
	
	///////////////////////////////////////////////////////////////
	
	public function popTransform(graphics:Graphics):Void
	{
		graphics.popTransformation();
		if (popAlpha) graphics.popOpacity();
		
		applyPosition = false;
		popAlpha = false;
		applyRotation = false;
	}
	
	///////////////////////////////////////////////////////////////
	
	/*inline function set_atlas(value:AtlasObject):AtlasObject 
	{
		atlas = value;
		if (atlas == null) renderPath = renderImage;
		else renderPath = renderAtlas;
		return atlas;
	}*/
	
	inline function set_atlasItem(value:AtlasItem):AtlasItem 
	{
		atlasItem = value;
		if (atlasItem == null) {
			renderPath = renderImage;
			if (base != null){
				drawWidth = base.width;
				drawHeight = base.height;
			}
		}
		else {
			atlasItem.partition.add(OnPartitionSet);
			renderPath = renderAtlas;
			drawWidth = atlasItem.width;
			drawHeight = atlasItem.height;
			if (atlasItem.rotation == 90) {
				applyRotation = true;
			}
		}
		return atlasItem;
	}
	
	function OnPartitionSet() 
	{
		isStatic = false;
	}
	
	
	
	inline function set_x(value:Float):Float { 
		if (x != value){
			x = value;
			applyPosition = true;
			isStatic = false;
		}
		return value;
	}
	inline function set_y(value:Float):Float { 
		if (y != value){
			y = value;
			applyPosition = true;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_width(value:Float):Float { 
		if (width != value){
			width = value;
			applyPosition = true;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_height(value:Float):Float { 
		if (height != value){
			height = value;
			applyPosition = true;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_pivotX(value:Float):Float { 
		if (pivotX != value){
			pivotX = value;
			applyPosition = true;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		if (pivotY != value){
			pivotY = value;
			applyPosition = true;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_rotation(value:FastFloat):FastFloat { 
		if (rotation != value){
			rotation = value;
			applyRotation = true;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_scaleX(value:FastFloat):FastFloat { 
		if (scaleX != value){
			scaleX = value;
			applyPosition = true;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_scaleY(value:FastFloat):FastFloat { 
		if (scaleY != value){
			scaleY = value;
			applyPosition = true;
			isStatic = false;
		}
		return value;
	}
	
	function set_color(value:Color):Color { 
		if (color != value){
			color = value;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_alpha(value:Float):Float { 
		if (alpha != value){
			alpha = value;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_blendMode(value:BlendMode):BlendMode { 
		if (blendMode != value){
			blendMode = value;
			shaderPipeline = BlendModeUtil.applyBlend(blendMode);
			isStatic = false;
		}
		return value;
	}
	
	function set_layerIndex(value:Null<Int>):Null<Int> { 
		if (layerIndex != value){
			if (layerIndex != null) Kea.current.logic.displayList.removeLayerIndex(layerIndex);
			layerIndex = value;
			Kea.current.logic.displayList.addLayerIndex(layerIndex);
			isStatic = false;
		}
		return value;
	}
	
	///////////////////////////////////////////////////////////////
	
	function get_totalNumChildren():Int
	{ 
		return 0;
	}
	
	function get_stage():Stage 
	{
		return stage;
	}
	
	function set_stage(value:Stage):Stage 
	{
		if (stage != value) {
			DisplayList.updateHierarchy = true;
			stage = value;
		}
		
		// TODO, move this to render loop
		if (value == null) {
			/*if (renderable) {
				Kea.current.logic.displayList.remove(this);
			}*/
			Kea.current.logic.atlasBuffer.remove(this);
		}
		else {
			/*if (renderable) {
				Kea.current.logic.displayList.add(this);
			}*/
			Kea.current.logic.atlasBuffer.add(this);
		}
		
		
		return stage;
	}
	
	/*function set_isStatic(value:Null<Bool>):Null<Bool> 
	{
		if (parent != null) parent.isStatic = false;
		return isStatic = value;
	}*/
	
	//function get_renderIndex():Null<Int> 
	//{
		//if (_renderIndex > Kea.current.logic.displayList.lowestChange){
			//UpdateRenderIndex();
		//}
		//return _renderIndex;
	//}

	//private function UpdateRenderIndex():Void
	//{
		////Kea.current.updateList.lowestChange = _renderIndex = Kea.current.updateList.renderList.indexOf(this);
		//if (previous == null){
			//Kea.current.logic.displayList.lowestChange = _renderIndex = 0;
		//}
		//else {
			//Kea.current.logic.displayList.lowestChange = _renderIndex = previous.renderIndex + 1;
		//}
		////trace("new _renderIndex = " + _renderIndex + " name = " + this.name);
	//}
}

