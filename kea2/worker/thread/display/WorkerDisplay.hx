package kea2.worker.thread.display;
import kea2.core.memory.data.batchData.BatchData;
import kea2.core.memory.data.displayData.IDisplayData;
import kea2.core.memory.data.textureData.ITextureData;
import kea2.pool.Pool;
import kea2.texture.RenderTexture;
import kea2.utils.Notifier;
import kea2.core.memory.data.displayData.DisplayData;
import kea2.core.memory.data.textureData.TextureData;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.display._private.PrivateDisplayBase;
import kea2.worker.thread.atlas.AtlasPacker;
import kea2.worker.thread.display.TextureOrder.TextureDef;
import kea2.worker.thread.display.TextureRenderBatch.RenderBatchDef;
import kea2.worker.thread.display.WorkerDisplay;
import kea2.worker.thread.display.WorkerDisplayList;
import kea2.pool.ObjectPool;
import kea2.worker.thread.layerCache.LayerCache;
import kea2.worker.thread.layerCache.groups.LayerGroup;
import kea2.worker.thread.layerCache.groups.LayerGroup.LayerGroupState;
import kea2.worker.thread.util.transform.WorkerTransformHelper;
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
@:access(kea2)
class WorkerDisplay extends PrivateDisplayBase
{
	static var FALSE:Int = 0;
	static var TRUE:Int = 1;
	
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
	
	@:isVar var applyPosition(default, set):Bool = false;
	@:isVar var applyRotation(default, set):Bool = false;
	
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
	var offsetX:Float;
	var offsetY:Float;
	
	var left:Float;
	var top:Float;
	var right:Float;
	var bottom:Float;
	
	var updateUVs:Bool = true;
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
	var textureDefIndex:Int;
	var textureIndex:Int;
	var layerCache:LayerCache;
	
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
		
		//trace(["pushTransform", objectId, VertexData.OBJECT_POSITION]);
		
		if (isStatic == WorkerDisplay.FALSE) {
			
			readDisplayData();
			
			/*if (alpha != WorkerGraphics.opacity) {
				WorkerGraphics.pushOpacity(WorkerGraphics.opacity * alpha);
				popAlpha = true;
			}*/
			//WorkerGraphics.color = color.value;
			
			WorkerTransformHelper.clear(localTransform);
			
			//WorkerTransformHelper.setScale(localTransform, scaleX, scaleY, base, width, height);
			WorkerTransformHelper.setScale(localTransform, scaleX, scaleY, width, height, width, height);
			
			/*if (atlasItem != null && atlasItem.rotation == 90) {
				WorkerTransformHelper.setPosition(applyPosition, positionMatrix, localTransform, x + atlasItem.height, y);
				WorkerTransformHelper.setRotation(applyRotation, applyPosition, localTransform, rotMatrix, rotMatrix1, rotMatrix2, rotMatrix3, rotation + atlasItem.rotation);
			}
			else {*/
				WorkerTransformHelper.setPosition(applyPosition, positionMatrix, localTransform, x, y);
				
				
				WorkerTransformHelper.setRotation(applyRotation, applyPosition, localTransform, rotMatrix, rotMatrix1, rotMatrix2, rotMatrix3, rotation);
			//}
			
			WorkerGraphics.pushTransformation(localTransform, renderId);
			globalTransform.setFrom(localTransform);
			
			//WorkerGraphics.pushTransformation(WorkerGraphics.transformation.multmat(localTransform), objectId);
			//globalTransform.setFrom(WorkerGraphics.transformation);
			
			updateInternalData();
		}
		
		if (WorkerCore.hierarchyBuildRequired) {
			WorkerCore.workerDisplayList.hierarchy.push(this);
			WorkerCore.workerDisplayList.hierarchyAll.push(this);
			
			if (textureId != -1) {
				WorkerCore.workerDisplayList.visHierarchy.push(this);
				WorkerCore.workerDisplayList.visHierarchyAll.push(this);
			}
			
			if (renderId != -1) {
				//WorkerCore.workerDisplayList.numberOfRenderables++;
				//trace("this.numberOfRenderables = " + Conductor.conductorDataAccess.numberOfRenderables);
			}
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
	
	inline function updateUVData() 
	{
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
	
	inline function updateIsStatic() 
	{
		isStatic = displayData.isStatic;
		
		if (textureId != -1) {
			WorkerCore.layerCaches.build(this);	
		}
	}
	
	inline function readDisplayData() 
	{
		x = displayData.x;
		y = displayData.y;
		width = displayData.width;
		height = displayData.height;
		pivotX = displayData.pivotX;
		pivotY = displayData.pivotY;
		scaleX = displayData.scaleX;
		scaleY = displayData.scaleY;
		rotation = displayData.rotation;
		alpha = displayData.alpha;
		color = displayData.color;
		textureId = displayData.textureId;
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
		RenderTexture.currentRenderTargetId = renderTarget;
		// Draw Into Screen Buffer
		RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
		textureDefIndex = WorkerCore.textureOrder.setValues(textureData.atlasTextureId, textureData);
		//WorkerCore.textureOrder.addWorkerDisplay(this);
	}
	
	public function setTexturesDraw() 
	{
		RenderTexture.currentRenderTargetId = renderTarget;
		// Draw Into LayerCache Texture
		RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
		textureDefIndex = WorkerCore.textureOrder.setValues(textureData.atlasTextureId, textureData);
		//WorkerCore.textureOrder.addWorkerDisplay(this);
		layerCache.setTextures();
	}
	
	public function setTexturesAlreadyAdded() 
	{
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
			//textureDefIndex = WorkerCore.textureOrder.setValues(textureData.atlasTextureId, textureData);
			////WorkerCore.textureOrder.addWorkerDisplay(this);
			//layerCache.setTextures(staticDef/*, this*/);
		//}
		//else if (staticDef.state == LayerGroupState.MOVING) {
			//// Draw Into Screen Buffer
			//RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
			//textureDefIndex = WorkerCore.textureOrder.setValues(textureData.atlasTextureId, textureData);
			////WorkerCore.textureOrder.addWorkerDisplay(this);
		//}
	//}
	
	public function setTextureIndexMove():Void
	{
		var batchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDefIndex);
		textureIndex = WorkerCore.textureRenderBatch.findTextureIndex(batchIndex, textureData.atlasTextureId);
	}
	
	public function setTextureIndexDraw():Void
	{
		var batchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDefIndex);
		textureIndex = WorkerCore.textureRenderBatch.findTextureIndex(batchIndex, textureData.atlasTextureId);
	}
	
	public function setTextureIndexAlreadyAdded():Void
	{
		var batchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDefIndex);
		textureIndex = WorkerCore.textureRenderBatch.findTextureIndex(batchIndex, staticDef.layerCacheRenderTarget);
	}
	
	/*public function setTextureIndex():Void
	{
		if (textureId == -1) return;
		var batchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDefIndex);
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
		if (textureData.textureAvailable == 0) return;
		vertexData.batchTextureIndex = this.textureIndex;
		writeVertexData();
	}
	
	public function setVertexDataDraw() 
	{
		if (textureData.textureAvailable == 0) return;
		vertexData.batchTextureIndex = this.textureIndex;
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
		if (isStatic == WorkerDisplay.FALSE || drawIndex != VertexData.OBJECT_POSITION){
			vertexData.batchTextureIndex = this.textureIndex;
			
			//vertexData.textureId = textureId;
			//trace("staticDef.layerCacheRenderTarget = " + staticDef.layerCacheRenderTarget);
			
			var atlasBatchTextureIndex:Int = textureData.atlasTextureId;
			//trace("atlasBatchTextureIndex = " + atlasBatchTextureIndex);
			
			
			//WorkerCore.textureRenderBatch.find
			//trace("this.textureIndex = " + this.textureIndex);
			
			/*trace("textureDefIndex = " + textureDefIndex);
			var batchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(textureDefIndex);
			trace("batchIndex = " + batchIndex);
			trace("textureData.atlasTextureId = " + textureData.atlasTextureId);
			var batchTextureIndex:Int = WorkerCore.textureRenderBatch.findIndex(batchIndex, textureData.atlasTextureId);
			trace("batchTextureIndex = " + batchTextureIndex);*/
			
			
			//var renderBatchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(atlasBatchTextureIndex);
			//trace("renderBatchIndex = " + renderBatchIndex);
			//var renderBatchDef:RenderBatchDef = WorkerCore.textureRenderBatch.getRenderBatchDef(renderBatchIndex);
			//vertexData.renderBatchIndex = renderBatchIndex;
			//var textureDef:TextureDef = renderBatchDef.textureDefs[renderBatchIndex];
			//trace("key = " + textureDef.textureData.partition.value.key);
			
			
			//var renderBatchDef:RenderBatchDef = WorkerCore.textureRenderBatch.getRenderBatchDef(VertexData.OBJECT_POSITION);
			/*for (i in 0...renderBatchDef.textureIdArray.length) 
			{
				if (renderBatchDef.textureIdArray[i] == textureId) vertexData.batchTextureIndex = i;
			}*/
			
			
			
			if (staticDef.state == LayerGroupState.DRAW_TO_LAYER) {
				targetWidth = 2048;
				targetHeight = 2048;
				/*mulX = 1;// WorkerCore.STAGE_WIDTH / 2048;
				mulY = 1;//WorkerCore.STAGE_HEIGHT / 2048;
				
				trace("mulX = " + mulX);
				trace("mulY = " + mulY);
				trace(bottomLeft);
				trace(bottomLeft);*/
				
			}
			else {
				targetWidth = WorkerCore.STAGE_WIDTH;
				targetHeight = WorkerCore.STAGE_HEIGHT;
				//mulX = 1;
				//mulY = 1;
			}
			//if (renderBatchDef.renderTargetId == -1) {
				//targetWidth = WorkerCore.STAGE_WIDTH / 2;// Kea.current.stage.stageWidth / 2;
				//targetHeight = WorkerCore.STAGE_HEIGHT / 2;// Kea.current.stage.stageHeight / 2;	
			//}
			//else {
			//	targetWidth = 512 / 2;
			//	targetHeight = 512 / 2;
			//}
			offsetX = -targetWidth;
			offsetY = -targetHeight;
			
			//vertexData.textureId = textureId;
			//trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
			//trace("targetWidth = " + targetWidth);
			
			updateUVData();
			/*left = textureData.partition.value.x / textureData.atlasWidth;
			top = textureData.partition.value.y / textureData.atlasHeight;
			right = (textureData.partition.value.x + textureData.partition.value.width) / textureData.atlasWidth;
			bottom = (textureData.partition.value.y + textureData.partition.value.height) / textureData.atlasHeight;*/
			
			//trace(["Write Vertex: " + VertexData.OBJECT_POSITION]);
			
			//if (updateUVs) {
				vertexData.u1 = left;
				vertexData.v1 = bottom;
				
				vertexData.u2 = left;
				vertexData.v2 = top;
				
				vertexData.u3 = right;
				vertexData.v3 = top;
				
				vertexData.u4 = right;
				vertexData.v4 = bottom;
			//}
			
			//if (updatePosition) {
				//vertexData.x1 = (bottomLeft.x + offsetX) / targetWidth * mulX;
				//vertexData.y1 = (-bottomLeft.y - offsetY) / targetHeight * mulY;
				////vertexData.z1 = 0;
				//
				//vertexData.x2 = (topLeft.x + offsetX) / targetWidth * mulX;
				//vertexData.y2 = (-topLeft.y - offsetY) / targetHeight * mulY;
				////vertexData.z2 = 0;
				//
				//vertexData.x3 = (topRight.x + offsetX) / targetWidth * mulX;
				//vertexData.y3 = (-topRight.y - offsetY) / targetHeight * mulY;
				////vertexData.z3 = 0;
				//
				//vertexData.x4 = (bottomRight.x + offsetX) / targetWidth * mulX;
				//vertexData.y4 = ( -bottomRight.y - offsetY) / targetHeight * mulY;
				//
				
				//trace([bottomLeft, topLeft, topRight, bottomRight]);
				vertexData.x1 = transformX(bottomLeft.x);
				vertexData.y1 = transformY(bottomLeft.y);
				//vertexData.z1 = 0;
				
				vertexData.x2 = transformX(topLeft.x);
				vertexData.y2 = transformY(topLeft.y);
				//vertexData.z2 = 0;
				
				vertexData.x3 = transformX(topRight.x);
				vertexData.y3 = transformY(topRight.y);
				//vertexData.z3 = 0;
				
				vertexData.x4 = transformX(bottomRight.x);
				vertexData.y4 = transformY(bottomRight.y);
				
				/*trace([vertexData.x1, vertexData.y1]);
				trace([vertexData.x2, vertexData.y2]);
				trace([vertexData.x3, vertexData.y3]);
				trace([vertexData.x4, vertexData.y4]);*/
				
				//vertexData.z4 = 0;
			//}
			
			
			
			/*if (updateColour) {
				//VertexData.blockIndex = BlockIndex.COLOUR;
				//vertexData.updatePosition();
				vertexData.red = r;
				vertexData.green = g;
				vertexData.blue = b;
				vertexData.alpha = a;
			}
			else vertexData.move(4);*/
			
			////////////////////////////////////////////////////////
			
			if (updateUVs) {
				
			}
			
			if (updatePosition) {
				
			}
			
			/*if (updateColour) {
				//VertexData.blockIndex = BlockIndex.COLOUR;
				//vertexData.updatePosition();	
				vertexData.red = r;
				vertexData.green = g;
				vertexData.blue = b;
				vertexData.alpha = a;
			}
			else vertexData.move(4);*/
			
			////////////////////////////////////////////////////////
			
			if (updateUVs) {
				
			}
			
			if (updatePosition) {
				
			}
			
			/*if (updateColour) {
				//VertexData.blockIndex = BlockIndex.COLOUR;
				//vertexData.updatePosition();
				vertexData.red = r;
				vertexData.green = g;
				vertexData.blue = b;
				vertexData.alpha = a;
			}
			else vertexData.move(4);*/
			
			////////////////////////////////////////////////////////
			
			if (updateUVs) {
				
			}
			
			if (updatePosition) {
				
			}
			
			/*if (updateColour) {
				//VertexData.blockIndex = BlockIndex.COLOUR;
				//vertexData.updatePosition();	
				vertexData.red = r;
				vertexData.green = g;
				vertexData.blue = b;
				vertexData.alpha = a;
			}
			else vertexData.move(4);*/
		}
		finishSetVertexData();
	}
	
	function transformX(x:Float):Float 
	{
		return ((x / WorkerCore.STAGE_WIDTH) * 2 * (WorkerCore.STAGE_WIDTH / targetWidth)) - 1;
	}
	
	function transformY(y:Float):Float
	{
		return 1 - ((y / WorkerCore.STAGE_HEIGHT) * 2 * (WorkerCore.STAGE_HEIGHT / targetHeight));
	}
	
	inline function finishSetVertexData() 
	{
		updateUVs = false;
		isStatic = WorkerDisplay.TRUE;
		drawIndex = VertexData.OBJECT_POSITION;
		VertexData.OBJECT_POSITION++;
	}
	
	//public function checkAtlas() 
	//{
		////textureData
	//}
	
	public inline function multvec(output:Point, localTransform:FastMatrix3, x: Float, y:Float):Void
	{
		var w = localTransform._02 * x + localTransform._12 * y + localTransform._22 * 1;
		output.x = (localTransform._00 * x + localTransform._10 * y + localTransform._20 * 1) / w;
		output.y = (localTransform._01 * x + localTransform._11 * y + localTransform._21 * 1) / w;
	}
	
	function popTransform() 
	{
		if (isStatic == WorkerDisplay.FALSE){
			WorkerGraphics.popTransformation();
			/*if (popAlpha) WorkerGraphics.popOpacity();
			
			popAlpha = false;*/
			
			applyPosition = false;
			applyRotation = false;
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
	
	
	
	inline function set_isStatic(value:Int):Int { 
		if (isStatic != value){
			displayData.isStatic = isStatic = value;
		}
		return value;
	}
	inline function set_x(value:Float):Float { 
		if (x != value){
			/*displayData.x = */x = value;
			applyPosition = true;
		}
		return value;
	}
	inline function set_y(value:Float):Float { 
		if (y != value){
			/*displayData.y = */y = value;
			applyPosition = true;
		}
		return value;
	}
	
	inline function set_width(value:Float):Float { 
		if (width != value){
			/*displayData.width = */width = value;
			applyPosition = true;
		}
		return value;
	}
	
	inline function set_height(value:Float):Float { 
		if (height != value){
			/*displayData.height = */height = value;
			applyPosition = true;
		}
		return value;
	}
	
	inline function set_pivotX(value:Float):Float { 
		if (pivotX != value){
			/*displayData.pivotX = */pivotX = value;
			applyPosition = true;
		}
		return value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		if (pivotY != value){
			/*displayData.pivotY = */pivotY = value;
			applyPosition = true;
		}
		return value;
	}
	
	inline function set_rotation(value:Float):Float { 
		if (rotation != value){
			/*displayData.rotation = */rotation = value;
			applyRotation = true;
		}
		return value;
	}
	
	inline function set_scaleX(value:Float):Float { 
		if (scaleX != value){
			/*displayData.scaleX = */scaleX = value;
			applyPosition = true;
		}
		return value;
	}
	
	inline function set_scaleY(value:Float):Float { 
		if (scaleY != value){
			/*displayData.scaleY = */scaleY = value;
			applyPosition = true;
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
			
			updateUVData();
			//isStatic = WorkerDisplay.FALSE;
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
	
	
	
	inline function set_applyPosition(value:Bool):Bool 
	{
		if (applyPosition != value) {
			applyPosition = value;
			//isStatic = false;
		}
		return applyPosition;
	}
	
	inline function set_applyRotation(value:Bool):Bool 
	{
		if (applyRotation != value) {
			applyRotation = value;
			//isStatic = false;
		}
		return applyRotation;
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