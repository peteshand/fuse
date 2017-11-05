package fuse.core.backend.display;

import fuse.core.backend.layerCache.LayerCache;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.backend.texture.TextureOrder.TextureDef;
import fuse.core.communication.data.indices.IIndicesData;
import fuse.core.communication.data.indices.IndicesData;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.pool.Pool;
import fuse.texture.RenderTexture;

/**
 * ...
 * @author P.J.Shand
 */
@:keep
@:access(fuse.texture.RenderTexture)
class CoreImage extends CoreDisplayObject
{
	@:isVar public var textureId(get, set):Int = -1;
	public var vertexData	:IVertexData;
	public var indicesData	:IIndicesData;
	public var coreTexture	:CoreTexture;
	public var mask			:CoreImage;
	public var renderLayer	:Int = 0;
	
	var color				:Color = 0x0;
	
	var targetWidth			:Float;
	var targetHeight		:Float;
	var drawIndex			:Int = -1;
	/*var uvLeft				:Float = 0;
	var uvTop				:Float = 0;
	var uvRight				:Float = 1;
	var uvBottom			:Float = 1;*/
	var updateUVs			:Int = 0;
	var renderTarget		:Int = -1;
	var textureDef			:TextureDef;
	var layerCache			:LayerCache;
	var transformXMul		:Float = 0;
	var transformYMul		:Float = 0;
	
	public function new() 
	{
		super();
		vertexData = new VertexData();
		indicesData = new IndicesData();
	}
	
	override function pushTransform() 
	{
		super.pushTransform();
		
		if (Core.hierarchyBuildRequired) {
			Core.displayListBuilder.visHierarchy.push(this);
		}
	}
	
	public function buildLayerCache():Void
	{
		Core.layerCaches.build(this);
	}
	
	inline function get_textureId():Int { return textureId; }
	
	function set_textureId(value:Int):Int { 
		if (textureId != value){
			textureId = value;
			
			if (coreTexture != null && textureId == -1) {
				//Core.atlasPacker.removeTexture(textureData.textureId);
				Core.textures.deregister(coreTexture.textureData.textureId);
				coreTexture = null;
			}
			
			if (coreTexture == null || coreTexture.textureData.textureId != textureId) {
				//textureData = Core.atlasPacker.registerTexture(textureId);
				coreTexture = Core.textures.register(textureId);
				
			}
			
			updateUVs = 0;
			//updateUVData();
			//isStatic = WorkerDisplay.FALSE;
		}
		return value;
	}
	
	override function readDisplayData() 
	{
		super.readDisplayData();
		
		// TODO: add ability to update textureID after Image creation
		/*trace("CHECK THIS ISN'T CAUSING ISSUES");
		if (coreTexture.textureData.placed == 0) {
			coreTexture.textureData.placed = 1;
		}*/
		
		if (isStatic == 0 || parentNonStatic) {
			color = displayData.color;
			renderLayer = displayData.renderLayer;
			textureId = displayData.textureId;
		}
	}
	
	override function updateIsStatic() 
	{
		super.updateIsStatic();
		
		
		if (isStatic == 1 && coreTexture.textureHasChanged) {
			// If texture has change then set isStatic to false
			isStatic = 0;
		}
	}
	
	public function setAtlasTextures() 
	{
		this.renderTarget = RenderTexture.currentRenderTargetId;
		Core.atlasDrawOrder.setValues(coreTexture.textureData);
	}
	
	public function checkLayerCache() 
	{
		layerCache = Core.layerCaches.checkRenderTarget(staticDef);
		
		/*if (layerGroup != null){
			staticDef = layerGroup.staticDef;
			trace("staticDef.index = " + staticDef.index);
		}*/
	}
	
	override public function buildHierarchy() 
	{
		Core.displayListBuilder.hierarchyApplyTransform.push(pushTransform);
		Core.displayListBuilder.hierarchyApplyTransform.push(popTransform);
	}
	
	public function setTexturesMove() 
	{
		//trace(["setTexturesMove OBJECT_POSITION = " + VertexData.OBJECT_POSITION, this.objectId]);
		//trace("setTexturesMove");
		// Draw Into Screen Buffer
		RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
		//trace("setTexturesMove layerCacheRenderTarget = " + staticDef.layerCacheRenderTarget);
		textureDef = Core.textureOrder.setValues(coreTexture.textureData.atlasTextureId, coreTexture.textureData, visible == 1);
	}
	
	public function setTexturesDraw() 
	{
		// Draw Into LayerCache Texture
		//trace("setTexturesDraw");
		RenderTexture.currentRenderTargetId = staticDef.layerCacheRenderTarget;
		//trace("setTexturesDraw layerCacheRenderTarget = " + staticDef.layerCacheRenderTarget);
		textureDef = Core.textureOrder.setValues(coreTexture.textureData.atlasTextureId, coreTexture.textureData, visible == 1);
		layerCache.setTextures();
	}
	
	public function setTexturesAlreadyAdded() 
	{
		RenderTexture.currentRenderTargetId = renderTarget;
		// skip draw because it's already in a static layer
		layerCache.setTextures();
	}
	
	public function setVertexDataMove() 
	{
		targetWidth = Core.STAGE_WIDTH;
		targetHeight = Core.STAGE_HEIGHT;
		
		transformXMul = 2 * (Core.STAGE_WIDTH / targetWidth);
		transformYMul = 2 * (Core.STAGE_HEIGHT / targetHeight);
		
		writeVertexData();
	}
	
	public function setVertexDataDraw() 
	{
		targetWidth = Fuse.MAX_TEXTURE_SIZE;
		targetHeight = Fuse.MAX_TEXTURE_SIZE;
		
		transformXMul = 2 * (Core.STAGE_WIDTH / targetWidth);
		transformYMul = 2 * (Core.STAGE_HEIGHT / targetHeight);
		
		isStatic = 0;
		
		updateUVs = 0;
		writeVertexData();
	}
	
	inline function writeVertexData() 
	{
		if (visible == 0) return;
		
		
		if (isStatic == 0 || drawIndex != VertexData.OBJECT_POSITION) {
			
			//trace(["CoreImage VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION]);
			
			vertexData.setTexture(textureDef.textureIndex);
			
			if (mask == null) vertexData.setMaskTexture(-1);
			else {
				// TODO: update value to point to correct batch textureIndex
				vertexData.setMaskTexture(0);
			}
			
			//if (updateUVs < 5) {
				//trace([coreTexture.uvTop, coreTexture.uvBottom]);
				
				updateUVData();
				vertexData.setUV(0, coreTexture.uvLeft, coreTexture.uvBottom);	// bottom left
				vertexData.setUV(1, coreTexture.uvLeft, coreTexture.uvTop);		// top left
				vertexData.setUV(2, coreTexture.uvRight, coreTexture.uvTop);	// top right
				vertexData.setUV(3, coreTexture.uvRight, coreTexture.uvBottom);	// bottom right
				
				if (mask != null) {
					mask.updateUVData();
					vertexData.setMaskUV(0, mask.coreTexture.uvLeft, mask.coreTexture.uvBottom);	// bottom left
					vertexData.setMaskUV(1, mask.coreTexture.uvLeft, mask.coreTexture.uvTop);		// top left
					vertexData.setMaskUV(2, mask.coreTexture.uvRight, mask.coreTexture.uvTop);		// top right
					vertexData.setMaskUV(3, mask.coreTexture.uvRight, mask.coreTexture.uvBottom);	// bottom right
				}
				
				updateUVs++;
			//}
			
			vertexData.setXY(0, transformX(bottomLeft.x),	transformY(bottomLeft.y));
			vertexData.setXY(1, transformX(topLeft.x),		transformY(topLeft.y));
			vertexData.setXY(2, transformX(topRight.x),		transformY(topRight.y));
			vertexData.setXY(3, transformX(bottomRight.x),	transformY(bottomRight.y));
			
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
		isStatic = 1;
		drawIndex = VertexData.OBJECT_POSITION;
		VertexData.OBJECT_POSITION++;
		//IndicesData.OBJECT_POSITION++;
		parentNonStatic = false;
	}
	
	function updateUVData() 
	{
		coreTexture.updateUVData();
		/*uvLeft = textureData.x / textureData.p2Width;
		uvTop = textureData.y / textureData.p2Height;
		uvRight = (textureData.x + textureData.width) / textureData.p2Width;
		uvBottom = (textureData.y + textureData.height) / textureData.p2Height;*/
	}
	
	inline function transformX(x:Float):Float 
	{
		return ((x / Core.STAGE_WIDTH) * transformXMul) - 1;
	}
	
	inline function transformY(y:Float):Float
	{
		return 1 - ((y / Core.STAGE_HEIGHT) * transformYMul);
	}
	
	
	override public function clone():CoreDisplayObject
	{
		var _clone:CoreDisplayObject = Pool.images.request();
		_clone.displayData = displayData;
		_clone.objectId = objectId;
		return _clone;
	}
	
	override public function recursiveReleaseToPool()
	{
		Pool.images.release(this);
	}
}