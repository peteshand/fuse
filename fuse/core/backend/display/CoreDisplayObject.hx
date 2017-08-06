package fuse.core.backend.display;

import fuse.Color;
import fuse.core.backend.Core;
import fuse.core.backend.displaylist.Graphics;
import fuse.core.backend.layerCache.LayerCache;
import fuse.core.backend.layerCache.groups.LayerGroup;
import fuse.core.backend.layerCache.groups.LayerGroup.LayerGroupState;
import fuse.core.backend.texture.TextureOrder.TextureDef;
import fuse.core.backend.util.transform.WorkerTransformHelper;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.communication.data.indices.IIndicesData;
import fuse.core.communication.data.indices.IndicesData;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.math.FastMatrix3;
import fuse.pool.Pool;
import fuse.texture.RenderTexture;
import openfl.geom.Point;

/**
 * ...
 * @author P.J.Shand
 */
@:keep
@:access(fuse)
class CoreDisplayObject
{
	static var FALSE:Int = 0;
	static var TRUE:Int = 1;
	
	@:isVar var applyPosition(get, set):Int;
	@:isVar var applyRotation(get, set):Int;
	@:isVar public var isStatic(get, set):Int = 0;
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
	@:isVar public var textureId(get, set):Int = -1;
	@:isVar var textureIndex(get, set):Int;
	
	public var objectId:Int;
	public var vertexData:IVertexData;
	public var indicesData:IIndicesData;
	public var displayData:IDisplayData;
	public var parent:CoreDisplayObject;
	public var bottomLeft:Point;
	public var topLeft:Point;
	public var topRight:Point;
	public var bottomRight:Point;
	public var textureData:ITextureData;
	
	
	var transformData:TransformData;
	var drawIndex:Int = -1;
	var children:Array<CoreDisplayObject> = [];
	//var popAlpha:Bool = true;
	
	var targetWidth:Float;
	var targetHeight:Float;
	
	var left:Float;
	var top:Float;
	var right:Float;
	var bottom:Float;
	
	var updateUVs:Int = 0;
	//var updatePosition:Bool = true;
	//var updateColour:Bool = false;
	var renderTarget:Int = -1;
	var staticDef:StaticDef;
	public var layerGroup:LayerGroup;
	
	var textureDef:TextureDef;
	var layerCache:LayerCache;
	var transformXMul:Float = 0;
	var transformYMul:Float = 0;
	var parentNonStatic:Bool;
	var combinedAlpha:Float = 1;
	
	public function new() 
	{
		staticDef = { 
			index:-1,
			layerCacheRenderTarget:0,
			state:LayerGroupState.DRAW_TO_LAYER
		};
		
		bottomLeft = new Point();
		topLeft = new Point();
		topRight = new Point();
		bottomRight = new Point();
		
		vertexData = new VertexData();
		
		this.indicesData = new IndicesData();
		transformData = new TransformData();
	}
	
	/*function OnLayerCacheRenderTargetChange() 
	{
		if (layerCacheRenderTarget.value == -1 && layerCacheRenderTarget2.value != -1){
			WorkerCore.layerCache.drawLayer(layerCacheRenderTarget2.value);
		}
		
		layerCacheRenderTarget2.value = layerCacheRenderTarget.value;
	}*/
	
	public function addChildAt(child:CoreDisplayObject, index:Int):Void
	{
		if (index == -1){
			children.push(child);
		}
		else {
			children.insert(index, child);
		}
		child.parent = this;
	}
	
	public function removeChild(child:CoreDisplayObject):Void
	{
		children.remove(child);
		child.parent = null;
	}
	
	public function buildHierarchy() 
	{
		Core.displayListBuilder.hierarchyApplyTransform.push(pushTransform);
		for (i in 0...children.length) children[i].buildHierarchy();
		Core.displayListBuilder.hierarchyApplyTransform.push(popTransform);
	}
	
	function pushTransform() 
	{
		updateIsStatic();
		
		if (textureId != -1) {
			Core.layerCaches.build(this);	
		}
		
		//trace(["pushTransform", objectId, VertexData.OBJECT_POSITION]);
		if (isStatic == CoreDisplayObject.FALSE) {
			
			readDisplayData();
			
			combinedAlpha = Graphics.alpha * this.alpha;
			
			Graphics.pushAlpha(combinedAlpha);
			WorkerTransformHelper.update(this);
			
			updateInternalData();
		}
		
		if (Core.hierarchyBuildRequired) {
			Core.displayListBuilder.hierarchy.push(this);
			Core.displayListBuilder.hierarchyAll.push(this);
			
			if (textureId != -1) {
				Core.displayListBuilder.visHierarchy.push(this);
				Core.displayListBuilder.visHierarchyAll.push(this);
			}
			
			//if (renderId != -1) {
				//WorkerCore.displayListBuilder.numberOfRenderables++;
				//trace("this.numberOfRenderables = " + Conductor.conductorData.numberOfRenderables);
			//}
		}
	}
	
	inline function updateInternalData() 
	{
		//if (isStatic == CoreDisplay.FALSE){
			//updateUVData();
			updatePositionData();
			
			/*
			if (color != Color.Green) {
				color = Color.Green;
				updateColour = true;
			}*/
		//}
	}
	
	function updateUVData() 
	{
		//trace("updateUVData");
		//if (updateUVs) {
		left = textureData.x / textureData.p2Width;
		top = textureData.y / textureData.p2Height;
		right = (textureData.x + textureData.width) / textureData.p2Width;
		bottom = (textureData.y + textureData.height) / textureData.p2Height;
		//}
	}
	
	inline function updatePositionData() 
	{
		WorkerTransformHelper.multvec(bottomLeft, transformData.localTransform, -pivotX, -pivotY + height);
		WorkerTransformHelper.multvec(topLeft, transformData.localTransform, -pivotX, -pivotY);
		WorkerTransformHelper.multvec(topRight, transformData.localTransform, -pivotX + width, -pivotY);
		WorkerTransformHelper.multvec(bottomRight, transformData.localTransform, -pivotX + width, -pivotY + height);
	}
	
	function updateIsStatic() 
	{
		/*var tempIsStatic:Int = displayData.isStatic;
		if (isStatic != tempIsStatic) {
			isStatic = tempIsStatic;
			displayData.isStatic = 1;
		}*/
		var tempApplyPosition:Int = displayData.applyPosition;
		if (applyPosition != tempApplyPosition) {
			applyPosition = tempApplyPosition;
			displayData.applyPosition = 0;
		}
		var tempApplyRotation:Int = displayData.applyRotation;
		if (applyRotation != tempApplyRotation) {
			applyRotation = tempApplyRotation;
			//trace("applyRotation = " + applyRotation);
			displayData.applyRotation = 0;
		}
		if (applyPosition == 1 || applyRotation == 1) {
			setChildrenIsStatic(false);
		}
		textureId = displayData.textureId;
		
		//isStatic = displayData.isStatic;
	}
	
	function setChildrenIsStatic(value:Bool) 
	{
		if (value) {
			parentNonStatic = true;
			checkIsStatic();
		}
		for (i in 0...children.length) 
		{
			children[i].setChildrenIsStatic(true);
		}
	}
	
	function readDisplayData() 
	{
		if (applyPosition == 1 || parentNonStatic){
			x = displayData.x;
			y = displayData.y;
			width = displayData.width;
			height = displayData.height;
			pivotX = displayData.pivotX;
			pivotY = displayData.pivotY;
			scaleX = displayData.scaleX;
			scaleY = displayData.scaleY;
		}
		if (applyRotation == 1 || parentNonStatic){
			rotation = displayData.rotation;
		}
		alpha = displayData.alpha;
		color = displayData.color;
		
	}
	
	public function setAtlasTextures() 
	{
		if (textureId == -1) return;
		
		this.renderTarget = RenderTexture.currentRenderTargetId;
		
		//WorkerCore.textureOrder.setValues(textureData);
		Core.atlasTextureDrawOrder.setValues(textureData);
	}
	
	public function checkLayerCache() 
	{
		if (textureId == -1) return;
		
		layerCache = Core.layerCaches.checkRenderTarget(staticDef);
		
		/*if (layerGroup != null){
			staticDef = layerGroup.staticDef;
			trace("staticDef.index = " + staticDef.index);
		}*/
	}
	
	public function setTexturesMove() 
	{
		//trace("setTexturesMove");
		//RenderTexture.currentRenderTargetId = renderTarget;
		// Draw Into Screen Buffer
		RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
		//trace("textureData.atlasTextureId = " + textureData.atlasTextureId);
		
		textureDef = Core.textureOrder.setValues(textureData.atlasTextureId, textureData);
		//WorkerCore.textureOrder.addWorkerDisplay(this);
		
		//trace("textureDef.drawIndex = " + textureDef.drawIndex);	
		//trace("textureDef.textureIndex = " + textureDef.textureIndex);	
		
	}
	
	public function setTexturesDraw() 
	{
		//trace("setTexturesDraw");
		//RenderTexture.currentRenderTargetId = renderTarget;
		// Draw Into LayerCache Texture
		RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
		textureDef = Core.textureOrder.setValues(textureData.atlasTextureId, textureData);
		//WorkerCore.textureOrder.addWorkerDisplay(this);
		layerCache.setTextures();
	}
	
	public function setTexturesAlreadyAdded() 
	{
		//trace("setTexturesAlreadyAdded");
		RenderTexture.currentRenderTargetId = renderTarget;
		// skip draw because it's already in a static layer
		layerCache.setTextures();
	}
	
	//public function setTextures() 
	//{
		//if (textureId == -1 || textureData.textureAvailable == 0) return;
		//
		//RenderTexture.currentRenderTargetId = renderTarget;
		//
		//if (staticDef.state == LayerGroupState.ALREADY_ADDED) {
			//// skip draw because it's already in a static layer
			//
			//layerCache.setTextures(staticDef/*, this*/);
		//}
		//else if (staticDef.state == LayerGroupState.DRAW_TO_LAYER) {
			//// Draw Into LayerCache Texture
			//RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
			//textureDef = WorkerCore.textureOrder.setValues(textureData.atlasTextureId, textureData);
			////WorkerCore.textureOrder.addWorkerDisplay(this);
			//layerCache.setTextures(staticDef/*, this*/);
		//}
		//else if (staticDef.state == LayerGroupState.MOVING) {
			//// Draw Into Screen Buffer
			//RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
			//textureDef = WorkerCore.textureOrder.setValues(textureData.atlasTextureId, textureData);
			////WorkerCore.textureOrder.addWorkerDisplay(this);
		//}
	//}
	
	//public function setTextureIndexMove():Void
	//{
		////var batchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDef.index);
		//textureIndex = textureDef.textureIndex;// WorkerCore.textureRenderBatch.findTextureIndex(textureDef.renderBatchIndex, textureData.atlasTextureId);
	//}
	//
	//public function setTextureIndexDraw():Void
	//{
		////var batchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDef.index);
		//textureIndex = textureDef.textureIndex;// WorkerCore.textureRenderBatch.findTextureIndex(textureDef.renderBatchIndex, textureData.atlasTextureId);
	//}
	//
	//public function setTextureIndexAlreadyAdded():Void
	//{
		////var batchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDef.index);
		//textureIndex = textureDef.textureIndex;//WorkerCore.textureRenderBatch.findTextureIndex(textureDef.renderBatchIndex, staticDef.layerCacheRenderTarget);
	//}
	
	/*public function setTextureIndex():Void
	{
		if (textureId == -1) return;
		var batchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDef.index);
		if (staticDef.state == LayerGroupState.ALREADY_ADDED) {
			textureIndex = WorkerCore.textureRenderBatch.findTextureIndex(batchIndex, staticDef.layerCacheRenderTarget);
		}
		else if (staticDef.state == LayerGroupState.DRAW_TO_LAYER) {
			textureIndex = WorkerCore.textureRenderBatch.findTextureIndex(batchIndex, textureData.atlasTextureId);
		}
		else if (staticDef.state == LayerGroupState.MOVING) {
			textureIndex = WorkerCore.textureRenderBatch.findTextureIndex(batchIndex, textureData.atlasTextureId);
		}
		//trace("textureIndex = " + textureIndex);
	}*/
	
	public function setVertexDataMove() 
	{
		//if (textureData.textureAvailable == 0) return;
		
		targetWidth = Core.STAGE_WIDTH;
		targetHeight = Core.STAGE_HEIGHT;
		
		transformXMul = 2 * (Core.STAGE_WIDTH / targetWidth);
		transformYMul = 2 * (Core.STAGE_HEIGHT / targetHeight);
		
		writeVertexData();
	}
	
	public function setVertexDataDraw() 
	{
		//if (textureData.textureAvailable == 0) return;
		
		targetWidth = 2048;
		targetHeight = 2048;
		
		transformXMul = 2 * (Core.STAGE_WIDTH / targetWidth);
		transformYMul = 2 * (Core.STAGE_HEIGHT / targetHeight);
		
		isStatic = 0;
		
		updateUVs = 0;
		writeVertexData();
		
		//trace([left, right, bottom, top]);
		//trace([bottomLeft.x, bottomRight.x, topLeft.y, bottomLeft.y]);
		//trace([VertexData.OBJECT_POSITION, IndicesData.OBJECT_POSITION]);
		
		//layerCache.setVertexData(staticDef, textureIndex);
	}
	
	/*public function setVertexDataAlreadyAdded() 
	{
		if (textureData.textureAvailable == 0) return;
		layerCache.setVertexData(staticDef, textureIndex);
	}*/
	
	/*public function setVertexData() 
	{
		if (textureId == -1) return;
		if (textureData.textureAvailable == 0) return;
		
		if (staticDef.state == LayerGroupState.MOVING) {
			writeVertexData();
		}
		else if (staticDef.state == LayerGroupState.DRAW_TO_LAYER) {
			writeVertexData();
			layerCache.setVertexData(staticDef, textureIndex);
		}
		else if (staticDef.state == LayerGroupState.ALREADY_ADDED) {
			layerCache.setVertexData(staticDef, textureIndex);
		}
	}*/
	
	inline function writeVertexData() 
	{
		if (isStatic == CoreDisplayObject.FALSE || drawIndex != VertexData.OBJECT_POSITION) {
			//vertexData.batchTextureIndex = textureDef.textureIndex;
			
			vertexData.setT(0, textureDef.textureIndex);
			vertexData.setT(1, textureDef.textureIndex);
			vertexData.setT(2, textureDef.textureIndex);
			vertexData.setT(3, textureDef.textureIndex);
			
			if (updateUVs < 5){
				updateUVData();
				
				vertexData.setU(0, left);
				vertexData.setV(0, bottom);
				vertexData.setU(1, left);
				vertexData.setV(1, top);
				vertexData.setU(2, right);
				vertexData.setV(2, top);
				vertexData.setU(3, right);
				vertexData.setV(3, bottom);
				updateUVs++;
			}
			
			vertexData.setX(0, transformX(bottomLeft.x));
			vertexData.setY(0, transformY(bottomLeft.y));
			vertexData.setX(1, transformX(topLeft.x));
			vertexData.setY(1, transformY(topLeft.y));
			vertexData.setX(2, transformX(topRight.x));
			vertexData.setY(2, transformY(topRight.y));
			vertexData.setX(3, transformX(bottomRight.x));
			vertexData.setY(3, transformY(bottomRight.y));
			
			vertexData.setColor(displayData.color);
			vertexData.setAlpha(combinedAlpha);
			
			// TODO: only update when you need to
			indicesData.setIndex(0, 0);
			indicesData.setIndex(1, 1);
			indicesData.setIndex(2, 2);
			indicesData.setIndex(3, 0);
			indicesData.setIndex(4, 2);
			indicesData.setIndex(5, 3);
			
		}
		finishSetVertexData();
	}
	
	inline function finishSetVertexData() 
	{
		//updateUVs = false;
		isStatic = CoreDisplayObject.TRUE;
		drawIndex = VertexData.OBJECT_POSITION;
		VertexData.OBJECT_POSITION++;
		IndicesData.OBJECT_POSITION++;
		parentNonStatic = false;
	}
	
	inline function transformX(x:Float):Float 
	{
		return ((x / Core.STAGE_WIDTH) * transformXMul) - 1;
	}
	
	inline function transformY(y:Float):Float
	{
		
		return 1 - ((y / Core.STAGE_HEIGHT) * transformYMul);
	}
	
	function popTransform() 
	{
		if (isStatic == CoreDisplayObject.FALSE){
			Graphics.popTransformation();
			
			Graphics.popAlpha();
			/*if (popAlpha) Graphics.popAlpha();
			
			
			popAlpha = false;*/
			
			applyPosition = 0;
			applyRotation = 0;
		}
	}
	
	
	
	inline function get_isStatic():Int { return isStatic; }
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
	inline function get_textureId():Int { return textureId; }
	inline function get_textureIndex():Int { return textureIndex; }
	inline function get_applyPosition():Int { return applyPosition; }
	inline function get_applyRotation():Int { return applyRotation; }
	
	inline function set_isStatic(value:Int):Int { 
		if (isStatic != value){
			/*displayData.isStatic =*/ isStatic = value;
		}
		return value;
	}
	inline function set_x(value:Float):Float { 
		if (x != value){
			/*displayData.x = */x = value;
			//applyPosition = true;
		}
		return value;
	}
	inline function set_y(value:Float):Float { 
		if (y != value){
			/*displayData.y = */y = value;
			//applyPosition = true;
		}
		return value;
	}
	
	inline function set_width(value:Float):Float { 
		if (width != value){
			/*displayData.width = */width = value;
			//applyPosition = true;
		}
		return value;
	}
	
	inline function set_height(value:Float):Float { 
		if (height != value){
			/*displayData.height = */height = value;
			//applyPosition = true;
		}
		return value;
	}
	
	inline function set_pivotX(value:Float):Float { 
		if (pivotX != value){
			/*displayData.pivotX = */pivotX = value;
			//applyPosition = true;
		}
		return value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		if (pivotY != value){
			/*displayData.pivotY = */pivotY = value;
			//applyPosition = true;
		}
		return value;
	}
	
	inline function set_rotation(value:Float):Float { 
		if (rotation != value){
			/*displayData.rotation = */rotation = value;
			//applyRotation = true;
		}
		return value;
	}
	
	inline function set_scaleX(value:Float):Float { 
		if (scaleX != value){
			/*displayData.scaleX = */scaleX = value;
			//applyPosition = true;
		}
		return value;
	}
	
	inline function set_scaleY(value:Float):Float { 
		if (scaleY != value){
			/*displayData.scaleY = */scaleY = value;
			//applyPosition = true;
		}
		return value;
	}
	
	inline function set_color(value:Color):Color { 
		if (color != value){
			/*displayData.color = */color = value;
			//isStatic = false;
		}
		return value;
	}
	
	inline function set_alpha(value:Float):Float { 
		if (alpha != value){
			/*displayData.alpha = */alpha = value;
			//isStatic = false;
		}
		return value;
	}
	
	function set_textureId(value:Int):Int { 
		if (textureId != value){
			textureId = value;
			
			if (textureData != null && textureId == -1) {
				Core.atlasPacker.removeTexture(textureData.textureId);
				textureData = null;
			}
			else if (textureData == null || textureData.textureId != textureId) {
				textureData = Core.atlasPacker.registerTexture(textureId);
			}
			
			updateUVs = 0;
			//updateUVData();
			//isStatic = WorkerDisplay.FALSE;
		}
		return value;
	}
	
	inline function set_textureIndex(value:Int):Int 
	{
		if (textureIndex != value) {
			textureIndex = value;
		}
		return value;
	}
	
	/*inline function set_renderTargetId(value:Int):Int { 
		if (renderTargetId != value){
			renderTargetId = value;
			updateUVData();
			//isStatic = false;
		}
		return value;
	}*/
	
	
	
	inline function set_applyPosition(value:Int):Int 
	{
		if (applyPosition != value) {
			applyPosition = value;
			checkIsStatic();
		}
		return applyPosition;
	}
	
	inline function set_applyRotation(value:Int):Int 
	{
		if (applyRotation != value) {
			applyRotation = value;
			checkIsStatic();
		}
		return applyRotation;
	}
	
	inline function checkIsStatic():Void 
	{
		if (applyRotation == 1 || applyPosition == 1 || parentNonStatic) isStatic = 0;
	}
	
	public function clone():CoreDisplayObject
	{
		var _clone:CoreDisplayObject = requestFromPool();
		_clone.displayData = displayData;
		_clone.objectId = objectId;
		// MOVE INTRO SPRITE //////////////
		for (i in 0...children.length) 
		{
			_clone.children.push(children[i].clone());
		}
		///////////////////////////////////
		return _clone;
	}
	
	public function copyTo(destination:CoreDisplayObject) 
	{
		destination.displayData = this.displayData;
		destination.objectId = this.objectId;
		// MOVE INTRO SPRITE //////////////
		for (i in 0...children.length) 
		{
			var clonedChild:CoreDisplayObject = children[i].clone();
			children[i].copyTo(clonedChild);
			destination.addChildAt(clonedChild, destination.children.length);
		}
		///////////////////////////////////
	}
	
	public function recursiveReleaseToPool() 
	{
		// MOVE INTRO SPRITE //////////////
		while (children.length > 0)
		{
			children[0].recursiveReleaseToPool();
			children.shift();
		}
		////////////////////////////////////
		Pool.displayObjects.release(this);
	}
	
	
	function requestFromPool():CoreDisplayObject
	{
		return Pool.displayObjects.request();
	}
	
	/*function releaseToPool2():Void
	{
		Pool.displayObjects.release(this);
	}*/
	
}

typedef StaticDef =
{
	index:Int,
	layerCacheRenderTarget:Int,
	state:LayerGroupState
}