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
	
	var bottomLeft:Point;
	var topLeft:Point;
	var topRight:Point;
	var bottomRight:Point;
	
	//var textureIds:Notifier<Int>;
	var textureData:ITextureData;
	
	
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
	
	var mulX:Float;
	var mulY:Float;
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
	
	
	public function new(displayData:IDisplayData) 
	{
		bottomLeft = new Point();
		topLeft = new Point();
		topRight = new Point();
		bottomRight = new Point();
		
		this.displayData = displayData;
		this.vertexData = new VertexData();
		
		super();
	}
	
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
		readDisplayData();
		
		//trace(["pushTransform", objectId, VertexData.OBJECT_POSITION]);
		
		if (isStatic == WorkerDisplay.FALSE){
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
			
		}
		
		if (WorkerCore.hierarchyBuildRequired) {
			WorkerCore.workerDisplayList.hierarchy.push(this);
			WorkerCore.workerDisplayList.hierarchyAll.push(this);
			if (renderId != -1) {
				//WorkerCore.workerDisplayList.numberOfRenderables++;
				//trace("this.numberOfRenderables = " + Conductor.conductorDataAccess.numberOfRenderables);
			}
		}
	}
	
	public function updateInternalData() 
	{
		if (isStatic == WorkerDisplay.FALSE){
			//updateUVData();
			updatePositionData();
			
			opacity = 1;
			if (color != Color.Green) {
				color = Color.Green;
				updateColour = true;
			}
			
			isStatic = WorkerDisplay.TRUE;
		}
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
	
	inline function readDisplayData() 
	{
		isStatic = displayData.isStatic;
		if (isStatic == WorkerDisplay.FALSE){
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
		else {
			
		}
	}
	
	public function setAtlasTextures() 
	{
		if (textureId == -1) return;
		
		this.renderTarget = RenderTexture.currentRenderTargetId;
		
		//WorkerCore.textureOrder.setValues(textureData);
		WorkerCore.atlasTextureDrawOrder.setValues(textureData);
	}
	
	public function setTextures() 
	{
		if (textureId == -1 || textureData.textureAvailable == 0) return;
		
		RenderTexture.currentRenderTargetId = renderTarget;
		
		//trace("atlasTextureId = " + textureData.atlasTextureId);
		WorkerCore.textureOrder.setValues(textureData.atlasTextureId, textureData);
		//WorkerCore.atlasTextureDrawOrder.setValues(textureData);
	}
	
	public function setVertexData() 
	{
		if (textureId == -1) return;
		
		//trace(["setVertexData", objectId, VertexData.OBJECT_POSITION]);
		
		if (drawIndex == VertexData.OBJECT_POSITION && isStatic == WorkerDisplay.TRUE) {
			finishSetVertexData();
			return;
		}
		
		if (textureData.textureAvailable == 0) return;
		//trace("setVertexData: renderTextureId = " + renderTextureId);
		
		//vertexData.textureId = textureId;
		
		var atlasBatchTextureIndex:Int = textureData.atlasBatchTextureIndex;
		vertexData.batchTextureIndex = atlasBatchTextureIndex;
		
		//var renderBatchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(atlasBatchTextureIndex);
		//var renderBatchDef:RenderBatchDef = WorkerCore.textureRenderBatch.getRenderBatchDef(renderBatchIndex);
		//vertexData.renderBatchIndex = renderBatchIndex;
		//var textureDef:TextureDef = renderBatchDef.textureDefs[renderBatchIndex];
		//trace("key = " + textureDef.textureData.partition.value.key);
		
		//var renderBatchDef:RenderBatchDef = WorkerCore.textureRenderBatch.getRenderBatchDef(VertexData.OBJECT_POSITION);
		/*for (i in 0...renderBatchDef.textureIdArray.length) 
		{
			if (renderBatchDef.textureIdArray[i] == textureId) vertexData.batchTextureIndex = i;
		}*/
		
		//if (renderBatchDef.renderTargetId == -1) {
			mulX = WorkerCore.STAGE_WIDTH / 2;// Kea.current.stage.stageWidth / 2;
			mulY = WorkerCore.STAGE_HEIGHT / 2;// Kea.current.stage.stageHeight / 2;	
		//}
		//else {
		//	mulX = 512 / 2;
		//	mulY = 512 / 2;
		//}
		offsetX = -mulX;
		offsetY = -mulY;
		
		//vertexData.textureId = textureId;
		//trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		//trace("mulX = " + mulX);
		
		updateUVData();
		/*left = textureData.partition.value.x / textureData.atlasWidth;
		top = textureData.partition.value.y / textureData.atlasHeight;
		right = (textureData.partition.value.x + textureData.partition.value.width) / textureData.atlasWidth;
		bottom = (textureData.partition.value.y + textureData.partition.value.height) / textureData.atlasHeight;*/
		
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
			vertexData.x1 = (bottomLeft.x + offsetX) / mulX;
			vertexData.y1 = (-bottomLeft.y - offsetY) / mulY;
			//vertexData.z1 = 0;
			
			vertexData.x2 = (topLeft.x + offsetX) / mulX;
			vertexData.y2 = (-topLeft.y - offsetY) / mulY;
			//vertexData.z2 = 0;
			
			vertexData.x3 = (topRight.x + offsetX) / mulX;
			vertexData.y3 = (-topRight.y - offsetY) / mulY;
			//vertexData.z3 = 0;
			
			vertexData.x4 = (bottomRight.x + offsetX) / mulX;
			vertexData.y4 = (-bottomRight.y - offsetY) / mulY;
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
		
		finishSetVertexData();
		
	}
	
	inline function finishSetVertexData() 
	{
		updateUVs = false;
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
				if (textureId > 65000) {
					trace("textureId = " + textureId);
				}
				textureData = WorkerCore.atlasPacker.registerTexture(textureId);
			}
			
			updateUVData();
			isStatic = WorkerDisplay.FALSE;
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