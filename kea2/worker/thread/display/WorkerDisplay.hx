package kea2.worker.thread.display;
import kea2.core.memory.data.batchData.BatchData;
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
import kea2.worker.thread.texture.ObjectPool;
import kea2.worker.thread.util.transform.WorkerTransformHelper;
import kha.Color;
import kha.math.FastMatrix3;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.math.FastVector4;
import openfl.utils.ByteArray;

//import avm2.intrinsics.memory.
/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
class WorkerDisplay extends PrivateDisplayBase
{
	@:isVar public var x(default, set):Float = 0;
	@:isVar public var y(default, set):Float = 0;
	@:isVar public var width(default, set):Float = 0;
	@:isVar public var height(default, set):Float = 0;
	@:isVar public var pivotX(default, set):Float = 0;
	@:isVar public var pivotY(default, set):Float = 0;
	@:isVar public var rotation(default, set):Float = 0;
	@:isVar public var scaleX(default, set):Float = 0;
	@:isVar public var scaleY(default, set):Float = 0;
	@:isVar public var color(default, set):Color = 0x0;
	@:isVar public var alpha(default, set):Float = 0;
	
	public var isStatic:Bool;
	//public var objectId:Int;
	//public var parentId:Int;
	//public var renderId:Int;
	@:isVar public var textureId(default, set):Int = -1;
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
	
	var bottomLeft:FastVector2;
	var topLeft:FastVector2;
	var topRight:FastVector2;
	var bottomRight:FastVector2;
	
	//var textureIds:Notifier<Int>;
	//var workerDisplayList:WorkerDisplayList;
	var textureData:TextureData;
	
	//var workerEntryPoint:WorkerEntryPoint;
	/*var textureOrder:TextureOrder;
	var atlasPacker:AtlasPacker;
	var textureRenderBatch:TextureRenderBatch;*/
	
	public function new(displayData:DisplayData/*, vertexData:VertexData*/) 
	{
		bottomLeft = new FastVector2();
		topLeft = new FastVector2();
		topRight = new FastVector2();
		bottomRight = new FastVector2();
		
		this.displayData = displayData;
		this.vertexData = new VertexData();
		//this.workerEntryPoint = workerEntryPoint;
		//this.textureRenderBatch = textureRenderBatch;
		//this.atlasPacker = atlasPacker;
		
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
	
	public function buildHierarchy(hierarchyBuildRequired:Bool, workerDisplayList:WorkerDisplayList, graphics:WorkerGraphics) 
	{
		pushTransform(hierarchyBuildRequired, workerDisplayList, graphics);
		
		for (i in 0...children.length) 
		{
			children[i].buildHierarchy(hierarchyBuildRequired, workerDisplayList, graphics);
		}
		popTransform(graphics);
	}
	
	function pushTransform(hierarchyBuildRequired:Bool, workerDisplayList:WorkerDisplayList, graphics:WorkerGraphics) 
	{
		readDisplayData();
		
		/*if (alpha != graphics.opacity) {
			graphics.pushOpacity(graphics.opacity * alpha);
			popAlpha = true;
		}*/
		//graphics.color = color.value;
		
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
		
		graphics.pushTransformation(localTransform, renderId);
		globalTransform.setFrom(localTransform);
		
		//graphics.pushTransformation(graphics.transformation.multmat(localTransform), objectId);
		//globalTransform.setFrom(graphics.transformation);
		
		
		if (hierarchyBuildRequired) {
			workerDisplayList.hierarchy.push(this);
			workerDisplayList.hierarchyAll.push(this);
			if (renderId != -1) {
				//workerDisplayList.numberOfRenderables++;
				//trace("this.numberOfRenderables = " + Conductor.conductorDataAccess.numberOfRenderables);
			}
		}
	}
	
	
	
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
	var a:Float;// color.A * opacity;
	
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
	var renderTextureId:Int;
	
	
	public function updateVertexData() 
	{
		//updateUVData();
		updatePositionData();
		
		opacity = 1;
		if (color != Color.Green) {
			color = Color.Green;
			updateColour = true;
		}
	}
	
	inline function updateUVData() 
	{
		//if (updateUVs) {
		
		
		//textureData
		//var x:Float = -pivotX;
		//var y:Float = -pivotY;
		//sx = 0;// pivotX;
		//sy = 0;//pivotY;
		//var width:Float = width;
		//var height:Float = height;
		
		//textureWidth = textureData.width;
		//textureHeight = textureData.height;
		
		//sx = sx;
		//sy = sy;
		//sw = width;
		//sh = height;
		
		//left = 0;//sx / textureWidth;// tex.realWidth;
		//top = 0;//sy / textureHeight;// tex.realHeight;
		//right = 1;//(sx + sw) / textureWidth;//tex.realWidth;
		//bottom = 1;//(sy + sh) / textureHeight;//tex.realHeight;
		
		
		left = textureData.x;
		top = textureData.y;
		right = textureData.width / textureData.p2Width;
		bottom = textureData.height / textureData.p2Height;
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
	
	public function setTextures() 
	{
		if (textureId == -1) return;
		
		WorkerCore.textureOrder.textureEndIndex = VertexData.basePosition + VertexData.BYTES_PER_ITEM;
		WorkerCore.textureOrder.textureStartIndex = VertexData.basePosition;
		renderTextureId = RenderTexture.currentRenderTextureId;
		//trace("setTextures:   renderTextureId = " + renderTextureId);
		
		WorkerCore.textureOrder.setValues(VertexData.OBJECT_POSITION, textureId, renderTextureId, textureData);
		
		VertexData.OBJECT_POSITION++;
	}
	
	public function setVertexData() 
	{
		if (textureId == -1) return;
		//trace("setVertexData: renderTextureId = " + renderTextureId);
		
		vertexData.textureId = textureId;
		
		var renderBatchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(VertexData.OBJECT_POSITION);
		var renderBatchDef:RenderBatchDef = WorkerCore.textureRenderBatch.getRenderBatchDef(renderBatchIndex);
		vertexData.renderBatchIndex = renderBatchIndex;
		//var textureDef:TextureDef = renderBatchDef.textureDefs[renderBatchIndex];
		//trace("key = " + textureDef.textureData.partition.value.key);
		
		//var renderBatchDef:RenderBatchDef = WorkerCore.textureRenderBatch.getRenderBatchDef(VertexData.OBJECT_POSITION);
		for (i in 0...renderBatchDef.textureIdArray.length) 
		{
			if (vertexData.textureId == renderBatchDef.textureIdArray[i]) vertexData.textureId = i;
		}
		
		if (renderBatchDef.renderTargetId == -1) {
			mulX = 1600 / 2;// Kea.current.stage.stageWidth / 2;
			mulY = 900 / 2;// Kea.current.stage.stageHeight / 2;	
		}
		else {
			mulX = 512 / 2;
			mulY = 512 / 2;
		}
		offsetX = -mulX;
		offsetY = -mulY;
		
		//vertexData.textureId = textureId;
		
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
		
		updateUVs = false;
		
		VertexData.OBJECT_POSITION++;
	}
	
	public function checkAtlas() 
	{
		//textureData
	}
	
	public inline function multvec(output:FastVector2, localTransform:FastMatrix3, x: Float, y:Float):Void
	{
		var w = localTransform._02 * x + localTransform._12 * y + localTransform._22 * 1;
		output.x = (localTransform._00 * x + localTransform._10 * y + localTransform._20 * 1) / w;
		output.y = (localTransform._01 * x + localTransform._11 * y + localTransform._21 * 1) / w;
	}
	
	function popTransform(graphics:WorkerGraphics) 
	{
		graphics.popTransformation();
		/*if (popAlpha) graphics.popOpacity();
		
		popAlpha = false;*/
		
		applyPosition = false;
		applyRotation = false;
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
			isStatic = false;
		}
		return value;
	}
	
	inline function set_alpha(value:Float):Float { 
		if (alpha != value){
			/*displayData.alpha = */alpha = value;
			isStatic = false;
		}
		return value;
	}
	
	inline function set_textureId(value:Int):Int { 
		if (textureId != value){
			textureId = value;
			
			if (textureData != null && textureId == -1) {
				WorkerCore.atlasPacker.removeTexture(textureData.textureId);
				textureData = null;
			}
			else if (textureData == null || textureData.textureId != textureId){
				textureData = WorkerCore.atlasPacker.registerTexture(textureId);
			}
			
			updateUVData();
			isStatic = false;
		}
		return value;
	}
	
	/*inline function set_renderTargetId(value:Int):Int { 
		if (renderTargetId != value){
			renderTargetId = value;
			updateUVData();
			isStatic = false;
		}
		return value;
	}*/
	
	
	
	inline function set_applyPosition(value:Bool):Bool 
	{
		if (applyPosition != value) {
			applyPosition = value;
			isStatic = false;
		}
		return applyPosition;
	}
	
	inline function set_applyRotation(value:Bool):Bool 
	{
		if (applyRotation != value) {
			applyRotation = value;
			isStatic = false;
		}
		return applyRotation;
	}
	
	public function clone():WorkerDisplay
	{
		var _clone:WorkerDisplay = new WorkerDisplay(displayData);
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
			var clonedChild:WorkerDisplay = ObjectPool.request();
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
		ObjectPool.release(this);
	}
}