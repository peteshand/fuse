package fuse.worker.thread.display;
import fuse.worker.thread.WorkerCore;
import fuse.core.memory.data.batchData.BatchData;
import fuse.core.memory.data.displayData.IDisplayData;
import fuse.core.memory.data.textureData.ITextureData;
import fuse.pool.Pool;
import fuse.texture.RenderTexture;
import fuse.utils.Notifier;
import fuse.core.memory.data.displayData.DisplayData;
import fuse.core.memory.data.textureData.TextureData;
import fuse.core.memory.data.vertexData.VertexData;
import fuse.display._private.PrivateDisplayBase;
import fuse.worker.thread.atlas.AtlasPacker;
import fuse.worker.thread.display.TextureOrder.TextureDef;
import fuse.worker.thread.display.TextureRenderBatch.RenderBatchDef;
import fuse.worker.thread.display.WorkerDisplayList;
import fuse.pool.ObjectPool;
import fuse.worker.thread.layerCache.LayerCache;
import fuse.worker.thread.layerCache.groups.LayerGroup;
import fuse.worker.thread.layerCache.groups.LayerGroup.LayerGroupState;
import fuse.worker.thread.util.transform.WorkerTransformHelper;
import kha.Color;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.math.FastVector4;
import openfl.geom.Point;
import openfl.utils.ByteArray;
//import avm2.intrinsics.memory.
/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class WorkerDisplay extends PrivateDisplayBase
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
	
	var drawIndex:Int = -1;
	//public var isStatic:Bool;
	//public var objectId:Int;
	//public var parentId:Int;
	//public var renderId:Int;
	//@:isVar public var renderTargetId(default, set):Int = -1;
	
	/*public var applyPosition:Bool;
	public var applyRotation:Bool;*/
	
	/*@:isVar var applyPosition(default, set):Bool = false;
	@:isVar var applyRotation(default, set):Bool = false;*/
	
	public var parent:WorkerDisplay;
	var children:Array<WorkerDisplay> = [];
	
	//var applyPosition:Bool = true;
	//var applyRotation:Bool = true;
	var popAlpha:Bool = true;
	
	public var bottomLeft:Point;
	public var topLeft:Point;
	public var topRight:Point;
	public var bottomRight:Point;
	
	//var textureIds:Notifier<Int>;
	public var textureData:ITextureData;
	
	
	//var textureWidth:Int;
	//var textureHeight:Int;
	
	//var sx:Float;
	//var sy:Float;
	//var sw:Float;
	//var sh:Float;
	
	var opacity:Float;
	//var color:Color;
	
	
	
	//var r:Float;
	//var g:Float;
	//var b:Float;
	var a:Float;
	
	var targetWidth:Float;
	var targetHeight:Float;
	
	var left:Float;
	var top:Float;
	var right:Float;
	var bottom:Float;
	
	var updateUVs:Int = 0;
	var updatePosition:Bool = true;
	var updateColour:Bool = false;
	var renderTarget:Int = -1;
	//var layerCacheRenderTarget:Int;
	//static var layerCacheRenderTarget:Notifier<Null<Int>>;
	//static var layerCacheRenderTarget2:Notifier<Null<Int>>;
	var staticDef:StaticDef;
	public var layerGroup:LayerGroup;
	
	var mulX:Float;
	var mulY:Float;
	var textureDef:TextureDef;
	@:isVar var textureIndex(get, set):Int;
	var layerCache:LayerCache;
	var transformXMul:Float = 0;
	var transformYMul:Float = 0;
	
	public function new(displayData:IDisplayData) 
	{
		/*if (layerCacheRenderTarget == null) {
			layerCacheRenderTarget = new Notifier<Null<Int>>();
			layerCacheRenderTarget.add(OnLayerCacheRenderTargetChange);
			layerCacheRenderTarget2 = new Notifier<Null<Int>>();
		}*/
		
		staticDef = { 
			index:-1,
			layerCacheRenderTarget:0,
			state:LayerGroupState.DRAW_TO_LAYER
		};
		
		bottomLeft = new Point();
		topLeft = new Point();
		topRight = new Point();
		bottomRight = new Point();
		
		this.displayData = displayData;
		this.vertexData = new VertexData();
		
		super();
	}
	
	/*function OnLayerCacheRenderTargetChange() 
	{
		if (layerCacheRenderTarget.value == -1 && layerCacheRenderTarget2.value != -1){
			WorkerCore.layerCache.drawLayer(layerCacheRenderTarget2.value);
		}
		
		layerCacheRenderTarget2.value = layerCacheRenderTarget.value;
	}*/
	
	public function addChildAt(child:WorkerDisplay, index:Int):Void
	{
		if (index == -1){
			children.push(child);
		}
		else {
			children.insert(index, child);
		}
		child.parent = this;
	}
	
	public function removeChild(child:WorkerDisplay):Void
	{
		children.remove(child);
		child.parent = null;
	}
	
	public function buildHierarchy() 
	{
		WorkerCore.workerDisplayList.hierarchyApplyTransform.push(pushTransform);
		for (i in 0...children.length) children[i].buildHierarchy();
		WorkerCore.workerDisplayList.hierarchyApplyTransform.push(popTransform);
	}
	
	function pushTransform() 
	{
		updateIsStatic();
		
		if (textureId != -1) {
			WorkerCore.layerCaches.build(this);	
		}
		
		//trace(["pushTransform", objectId, VertexData.OBJECT_POSITION]);
		
		if (isStatic == WorkerDisplay.FALSE) {
			
			readDisplayData();
			
			WorkerTransformHelper.update(this);
			
			updateInternalData();
		}
		
		if (WorkerCore.hierarchyBuildRequired) {
			WorkerCore.workerDisplayList.hierarchy.push(this);
			WorkerCore.workerDisplayList.hierarchyAll.push(this);
			
			if (textureId != -1) {
				WorkerCore.workerDisplayList.visHierarchy.push(this);
				WorkerCore.workerDisplayList.visHierarchyAll.push(this);
			}
			
			//if (renderId != -1) {
				//WorkerCore.workerDisplayList.numberOfRenderables++;
				//trace("this.numberOfRenderables = " + Conductor.conductorData.numberOfRenderables);
			//}
		}
	}
	
	inline function updateInternalData() 
	{
		//if (isStatic == WorkerDisplay.FALSE){
			//updateUVData();
			updatePositionData();
			
			/*opacity = 1;
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
		multvec(bottomLeft, localTransform, -pivotX, -pivotY + height);
		multvec(topLeft, localTransform, -pivotX, -pivotY);
		multvec(topRight, localTransform, -pivotX + width, -pivotY);
		multvec(bottomRight, localTransform, -pivotX + width, -pivotY + height);
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
		textureId = displayData.textureId;
		
		//isStatic = displayData.isStatic;
	}
	
	function readDisplayData() 
	{
		if (applyPosition == 1){
			x = displayData.x;
			y = displayData.y;
			width = displayData.width;
			height = displayData.height;
			pivotX = displayData.pivotX;
			pivotY = displayData.pivotY;
			scaleX = displayData.scaleX;
			scaleY = displayData.scaleY;
		}
		if (applyRotation == 1){
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
		WorkerCore.atlasTextureDrawOrder.setValues(textureData);
	}
	
	public function checkLayerCache() 
	{
		if (textureId == -1) return;
		
		layerCache = WorkerCore.layerCaches.checkRenderTarget(staticDef);
		/*if (layerGroup != null){
			staticDef = layerGroup.staticDef;
			trace("staticDef.index = " + staticDef.index);
		}*/
	}
	
	public function setTexturesMove() 
	{
		trace("setTexturesMove");
		//RenderTexture.currentRenderTargetId = renderTarget;
		// Draw Into Screen Buffer
		RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
		trace("textureData.atlasTextureId = " + textureData.atlasTextureId);
		
		textureDef = WorkerCore.textureOrder.setValues(textureData.atlasTextureId, textureData);
		//WorkerCore.textureOrder.addWorkerDisplay(this);
		
		trace("textureDef.drawIndex = " + textureDef.drawIndex);	
		trace("textureDef.textureIndex = " + textureDef.textureIndex);	
		
	}
	
	public function setTexturesDraw() 
	{
		trace("setTexturesDraw");
		//RenderTexture.currentRenderTargetId = renderTarget;
		// Draw Into LayerCache Texture
		RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
		textureDef = WorkerCore.textureOrder.setValues(textureData.atlasTextureId, textureData);
		//WorkerCore.textureOrder.addWorkerDisplay(this);
		layerCache.setTextures();
	}
	
	public function setTexturesAlreadyAdded() 
	{
		trace("setTexturesAlreadyAdded");
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
		
		targetWidth = WorkerCore.STAGE_WIDTH;
		targetHeight = WorkerCore.STAGE_HEIGHT;
		
		transformXMul = 2 * (WorkerCore.STAGE_WIDTH / targetWidth);
		transformYMul = 2 * (WorkerCore.STAGE_HEIGHT / targetHeight);
		
		writeVertexData();
	}
	
	public function setVertexDataDraw() 
	{
		//if (textureData.textureAvailable == 0) return;
		
		targetWidth = 2048;
		targetHeight = 2048;
		
		transformXMul = 2 * (WorkerCore.STAGE_WIDTH / targetWidth);
		transformYMul = 2 * (WorkerCore.STAGE_HEIGHT / targetHeight);
		
		isStatic = 0;
		
		updateUVs = 0;
		writeVertexData();
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
		if (isStatic == WorkerDisplay.FALSE || drawIndex != VertexData.OBJECT_POSITION) {
			vertexData.batchTextureIndex = textureDef.textureIndex;//.textureIndex;
			
			if (updateUVs < 5){
				updateUVData();
				
				vertexData.u1 = left;
				vertexData.v1 = bottom;
				vertexData.u2 = left;
				vertexData.v2 = top;
				vertexData.u3 = right;
				vertexData.v3 = top;
				vertexData.u4 = right;
				vertexData.v4 = bottom;
				updateUVs++;
			}
			
			vertexData.x1 = transformX(bottomLeft.x);
			vertexData.y1 = transformY(bottomLeft.y);
			vertexData.x2 = transformX(topLeft.x);
			vertexData.y2 = transformY(topLeft.y);
			vertexData.x3 = transformX(topRight.x);
			vertexData.y3 = transformY(topRight.y);
			vertexData.x4 = transformX(bottomRight.x);
			vertexData.y4 = transformY(bottomRight.y);
			
		}
		finishSetVertexData();
	}
	
	inline function finishSetVertexData() 
	{
		//updateUVs = false;
		isStatic = WorkerDisplay.TRUE;
		drawIndex = VertexData.OBJECT_POSITION;
		VertexData.OBJECT_POSITION++;
	}
	
	//public function checkAtlas() 
	//{
		////textureData
	//}
	
	inline function multvec(output:Point, localTransform:FastMatrix3, x: Float, y:Float):Void
	{
		var w:Float = localTransform._02 * x + localTransform._12 * y + localTransform._22;
		output.x = (localTransform._00 * x + localTransform._10 * y + localTransform._20) / w;
		output.y = (localTransform._01 * x + localTransform._11 * y + localTransform._21) / w;
	}
	
	inline function transformX(x:Float):Float 
	{
		return ((x / WorkerCore.STAGE_WIDTH) * transformXMul) - 1;
	}
	
	inline function transformY(y:Float):Float
	{
		
		return 1 - ((y / WorkerCore.STAGE_HEIGHT) * transformYMul);
	}
	
	function popTransform() 
	{
		if (isStatic == WorkerDisplay.FALSE){
			WorkerGraphics.popTransformation();
			/*if (popAlpha) WorkerGraphics.popOpacity();
			
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
				WorkerCore.atlasPacker.removeTexture(textureData.textureId);
				textureData = null;
			}
			else if (textureData == null || textureData.textureId != textureId) {
				textureData = WorkerCore.atlasPacker.registerTexture(textureId);
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
		if (applyRotation == 1 || applyPosition == 1) isStatic = 0;
		//else isStatic = 1;
	}
	
	public function clone():WorkerDisplay
	{
		var _clone:WorkerDisplay = Pool.workerDisplay.request();// new WorkerDisplay(displayData);
		_clone.displayData = displayData;
		_clone.objectId = objectId;
		_clone.renderId = renderId;
		_clone.parentId = parentId;
		for (i in 0...children.length) 
		{
			_clone.children.push(children[i].clone());
		}
		return _clone;
	}
	
	public function copyTo(destination:WorkerDisplay) 
	{
		destination.displayData = this.displayData;
		destination.objectId = this.objectId;
		destination.renderId = this.renderId;
		destination.parentId = this.parentId;
		for (i in 0...children.length) 
		{
			var clonedChild:WorkerDisplay = Pool.workerDisplay.request();
			children[i].copyTo(clonedChild);
			destination.addChildAt(clonedChild, destination.children.length);
		}
	}
	
	public function releaseToPool() 
	{
		while (children.length > 0)
		{
			children[0].releaseToPool();
			children.shift();
		}
		Pool.workerDisplay.release(this);
	}
}

typedef StaticDef =
{
	index:Int,
	layerCacheRenderTarget:Int,
	state:LayerGroupState
}