package kea2.display.containers;

import kea.display.BlendMode;
import kea2.core.memory.data.conductorData.ConductorData;
import kea2.core.memory.data.displayData.DisplayData;
import kea2.display._private.PrivateDisplayBase;
import kea.logic.buffers.atlas.items.AtlasItem;
import kea.logic.displaylist.DisplayList;
import kea.logic.layerConstruct.LayerConstruct;
import kea.texture.Texture;
import kea.util.transform.TransformHelper;

import kea.logic.renderer.Renderer;
import kea.logic.layerConstruct.LayerConstruct.LayerDefinition;
import kea.display.BlendMode.BlendModeUtil;
import kea.util.MatrixUtils;
import kha.Color;
import kha.FastFloat;
import kea2.display.containers.Stage;
import kea2.utils.Notifier;
import kha.graphics2.Graphics;
import kha.graphics4.PipelineState;
import kha.math.FastMatrix3;
import msignal.Signal.Signal0;

import kea2.Kea;

@:access(kea2)
class DisplayObject extends PrivateDisplayBase implements IDisplay
{
	public var name:String;
	
	@:isVar public var parent(default, set):IDisplay;
	public var base:Texture;
	public var onAdd = new Signal0();
	//public var previous:IDisplay;
	public var totalNumChildren(get, null):Int;
	//public var renderIndex(get, null):Null<Int>;
	public var children:Array<IDisplay>;
	
	//@:isVar public var isStatic(default, set):Null<Bool>;
	//public var isStatic2 = new Notifier<Null<Bool>>(false);
	public var layerDefinition:LayerDefinition;
	public var calcTransform:Graphics -> Void;
	var renderable:Bool = false;
	
	@:isVar public var stage(get, set):Stage;
	//@:isVar public var atlas(default, set):AtlasObject;
	@:isVar public var atlasItem(default, set):AtlasItem;
	
	@:isVar public var x(get, set):Float = 0;
	@:isVar public var y(get, set):Float = 0;
	@:isVar public var width(get, set):Float = 0;
	@:isVar public var height(get, set):Float = 0;
	@:isVar public var pivotX(get, set):Float = 0;
	@:isVar public var pivotY(get, set):Float = 0;
	@:isVar public var rotation(get, set):Float = 0;
	@:isVar public var scaleX(get, set):Float = 0;
	@:isVar public var scaleY(get, set):Float = 0;
	@:isVar public var color(get, set):Color = 0x0;
	@:isVar public var alpha(get, set):Float = 0;
	@:isVar public var blendMode(get, set):BlendMode;
	@:isVar public var layerIndex(get, set):Null<Int> = null;
	@:isVar public var isStatic(get, set):Int;
	
	@:isVar var applyPosition(get, set):Bool = false;
	@:isVar var applyRotation(get, set):Bool = false;
	
	var _totalNumChildren:Int;
	var _renderIndex:Null<Int> = 0x3FFFFFFF;
	var renderPath:Graphics -> Void;
	var popAlpha:Bool = false;
	var drawWidth:Float;
	var drawHeight:Float;
	var shaderPipeline:PipelineState;
	
	public function new()
	{
		super();
		var id:Int = PrivateDisplayBase.objectIdCount++;
		displayData = new DisplayData(id);
		objectId = id;
		
		
		scaleX = 1;
		scaleY = 1;
		color = 0xFFFFFFFF;
		alpha = 1;
		
		displayData.textureId = -1;
		//displayData.parentId = -1;
		//displayData.renderId = -1;
		
		layerIndex = 0;
		renderPath = renderImage;
		isStatic = 0;
		
		if (base != null){
			drawWidth = base.width;
			drawHeight = base.height;
		}
		
		calcTransform = calcTransformDirect;
		//isStatic2.add(OnStaticStateChange);
		
		Renderer.layerStateChangeAvailable = true;
	}
	
	public function update():Void
	{
		
	}
	
	public inline function checkStatic():Void
	{
		//isStatic2.value = isStatic;
		isStatic = 1;
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
	
	/*function OnStaticStateChange() 
	{
		if (isStatic2.value)	calcTransform = calcTransformCache;
		else 					calcTransform = calcTransformDirect;
		Renderer.layerStateChangeAvailable = true;
	}*/
	
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
		isStatic = 0;
	}
	
	inline function get_x():Float { return x; }
	inline function get_y():Float { return y; }
	inline function get_width():Float { return width; }
	inline function get_height():Float { return height; }
	inline function get_pivotX():Float { return pivotX; }
	inline function get_pivotY():Float { return pivotY; }
	inline function get_rotation():Float { return rotation; }
	inline function get_scaleX():Float { return scaleX; }
	inline function get_scaleY():Float { return scaleY; }
	inline function get_color():Color { return color; }
	inline function get_alpha():Float { return alpha; }
	inline function get_blendMode():BlendMode { return blendMode; }
	inline function get_layerIndex():Null<Int> { return layerIndex; }
	inline function get_applyPosition():Bool { return applyPosition; }
	inline function get_applyRotation():Bool { return applyRotation; }
	inline function get_isStatic():Int { return isStatic; }
	
	
	inline function set_x(value:Float):Float { 
		if (x != value){
			displayData.x = x = value;
			applyPosition = true;
			isStatic = 0;
		}
		return value;
	}
	inline function set_y(value:Float):Float { 
		if (y != value){
			displayData.y = y = value;
			applyPosition = true;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_width(value:Float):Float { 
		if (width != value){
			displayData.width = width = value;
			applyPosition = true;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_height(value:Float):Float { 
		if (height != value){
			displayData.height = height = value;
			applyPosition = true;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_pivotX(value:Float):Float { 
		if (pivotX != value){
			displayData.pivotX = pivotX = value;
			applyPosition = true;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		if (pivotY != value){
			displayData.pivotY = pivotY = value;
			applyPosition = true;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_rotation(value:Float):Float { 
		if (rotation != value){
			displayData.rotation = rotation = value;
			applyRotation = true;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_scaleX(value:Float):Float { 
		if (scaleX != value){
			displayData.scaleX = scaleX = value;
			applyPosition = true;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_scaleY(value:Float):Float { 
		if (scaleY != value){
			displayData.scaleY = scaleY = value;
			applyPosition = true;
			isStatic = 0;
		}
		return value;
	}
	
	function set_color(value:Color):Color { 
		if (color != value){
			displayData.color = color = value;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_alpha(value:Float):Float { 
		if (alpha != value){
			displayData.alpha = alpha = value;
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_blendMode(value:BlendMode):BlendMode { 
		if (blendMode != value){
			/*displayData.blendMode =*/ blendMode = value;
			shaderPipeline = BlendModeUtil.applyBlend(blendMode);
			isStatic = 0;
		}
		return value;
	}
	
	//override function set_objectId(value:Int):Int 
	//{
		//return displayData.objectId = value;
	//}
	
	inline function set_layerIndex(value:Null<Int>):Null<Int> { 
		if (layerIndex != value){
			//if (layerIndex != null) Kea.current.logic.displayList.removeLayerIndex(layerIndex);
			layerIndex = value;
			//Kea.current.logic.displayList.addLayerIndex(layerIndex);
			isStatic = 0;
		}
		return value;
	}
	
	inline function set_applyPosition(value:Bool):Bool 
	{
		if (applyPosition = value) {
			applyPosition = value;
		}
		return applyPosition;
	}
	
	inline function set_applyRotation(value:Bool):Bool 
	{
		if (applyRotation = value) {
			applyRotation = value;
		}
		return applyRotation;
	}
	
	inline function set_isStatic(value:Int):Int 
	{
		//if (isStatic != value) {
			isStatic = value;
			//trace("isStatic = " + isStatic);
			displayData.isStatic = isStatic;
			if (value == 0){
				Kea.current.isStatic = 0;
			}
		//}
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
			//Kea.current.logic.atlasBuffer.remove(this);
		}
		else {
			/*if (renderable) {
				Kea.current.logic.displayList.add(this);
			}*/
			//Kea.current.logic.atlasBuffer.add(this);
		}
		
		
		return stage;
	}
	
	function set_parent(value:IDisplay):IDisplay 
	{
		parent = value;
		
		if (parent == null) {
			//displayData.parentId = -1;
			Kea.current.workers.removeChild(this);
		}
		else {
			//displayData.parentId = parent.objectId;
			Kea.current.workers.addChild(this, parent);
		}
		return parent = value;
	}
	
	
	
	/*function set_isStatic(value:Null<Bool>):Null<Bool> 
	{
		if (parent != null) parent.isStatic = 0;
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

