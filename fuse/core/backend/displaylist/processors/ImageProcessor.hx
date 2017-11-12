package fuse.core.backend.displaylist.processors;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.layerCache.LayerCaches;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.backend.texture.TextureOrder.TextureDef;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.texture.RenderTexture;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.backend.display)
@:access(fuse.texture.RenderTexture)
class ImageProcessor
{

	public function new() 
	{
		
	}
	
	static public function buildLayerCache(coreImage:CoreImage) 
	{
		LayerCaches.build(coreImage);
	}
	
	static public function setAtlasTextures(coreImage:CoreImage) 
	{
		coreImage.renderTarget = RenderTexture.currentRenderTargetId;
		Core.atlasDrawOrder.setValues(coreImage.coreTexture.textureData);
	}
	
	static public function checkLayerCache(coreImage:CoreImage) 
	{
		coreImage.layerCache = LayerCaches.checkRenderTarget(coreImage.staticDef);
	}
	
	static public function setTexturesMove(coreImage:CoreImage) 
	{
		//trace(["setTexturesMove OBJECT_POSITION = " + VertexData.OBJECT_POSITION, this.objectId]);
		//trace("setTexturesMove");
		// Draw Into Screen Buffer
		RenderTexture.currentRenderTargetId = coreImage.staticDef.layerCacheRenderTarget;
		//trace("setTexturesMove layerCacheRenderTarget = " + staticDef.layerCacheRenderTarget);
		coreImage.textureDef = Core.textureOrder.setValues(
			coreImage.coreTexture.textureData.atlasTextureId, 
			coreImage.coreTexture.textureData, 
			coreImage.visible == 1
		);
	}
	
	static public function setTexturesDraw(coreImage:CoreImage) 
	{
		// Draw Into LayerCache Texture
		//trace("setTexturesDraw");
		RenderTexture.currentRenderTargetId = coreImage.staticDef.layerCacheRenderTarget;
		//trace("setTexturesDraw layerCacheRenderTarget = " + staticDef.layerCacheRenderTarget);
		coreImage.textureDef = Core.textureOrder.setValues(
			coreImage.coreTexture.textureData.atlasTextureId, 
			coreImage.coreTexture.textureData, 
			coreImage.visible == 1
		);
		coreImage.layerCache.setTextures();
	}
	
	static public function setTexturesAlreadyAdded(coreImage:CoreImage) 
	{
		RenderTexture.currentRenderTargetId = coreImage.renderTarget;
		// skip draw because it's already in a static layer
		coreImage.layerCache.setTextures();
	}
	
	static public function setVertexDataMove(coreImage:CoreImage) 
	{
		coreImage.targetWidth = Core.STAGE_WIDTH;
		coreImage.targetHeight = Core.STAGE_HEIGHT;
		
		coreImage.transformXMul = 2 * (Core.STAGE_WIDTH / coreImage.targetWidth);
		coreImage.transformYMul = 2 * (Core.STAGE_HEIGHT / coreImage.targetHeight);
		
		writeVertexData(coreImage);
	}
	
	static public function setVertexDataDraw(coreImage:CoreImage) 
	{
		coreImage.targetWidth = Fuse.MAX_TEXTURE_SIZE;
		coreImage.targetHeight = Fuse.MAX_TEXTURE_SIZE;
		
		coreImage.transformXMul = 2 * (Core.STAGE_WIDTH / coreImage.targetWidth);
		coreImage.transformYMul = 2 * (Core.STAGE_HEIGHT / coreImage.targetHeight);
		
		coreImage.isStatic = 0;
		
		coreImage.updateUVs = 0;
		writeVertexData(coreImage);
	}
	
	static inline function writeVertexData(coreImage:CoreImage) 
	{
		if (coreImage.visible == 0) return;
		
		var textureDef:TextureDef = coreImage.textureDef;
		var vertexData:IVertexData = coreImage.vertexData;
		var coreTexture:CoreTexture = coreImage.coreTexture;
		
		if (coreImage.isStatic == 0 || coreImage.drawIndex != VertexData.OBJECT_POSITION) {
			
			//trace(["CoreImage VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION]);
			
			coreImage.vertexData.setTexture(textureDef.textureIndex);
			
			if (coreImage.mask == null) vertexData.setMaskTexture(-1);
			else {
				// TODO: update value to point to correct batch textureIndex
				vertexData.setMaskTexture(0);
			}
			
			//if (updateUVs < 5) {
				//trace([coreTexture.uvTop, coreTexture.uvBottom]);
				
				updateUVData(coreImage);
				vertexData.setUV(0, coreTexture.uvLeft, coreTexture.uvBottom);	// bottom left
				vertexData.setUV(1, coreTexture.uvLeft, coreTexture.uvTop);		// top left
				vertexData.setUV(2, coreTexture.uvRight, coreTexture.uvTop);	// top right
				vertexData.setUV(3, coreTexture.uvRight, coreTexture.uvBottom);	// bottom right
				
				if (coreImage.mask != null) {
					updateUVData(coreImage.mask);
					vertexData.setMaskUV(0, coreImage.mask.coreTexture.uvLeft, coreImage.mask.coreTexture.uvBottom);	// bottom left
					vertexData.setMaskUV(1, coreImage.mask.coreTexture.uvLeft, coreImage.mask.coreTexture.uvTop);		// top left
					vertexData.setMaskUV(2, coreImage.mask.coreTexture.uvRight, coreImage.mask.coreTexture.uvTop);		// top right
					vertexData.setMaskUV(3, coreImage.mask.coreTexture.uvRight, coreImage.mask.coreTexture.uvBottom);	// bottom right
				}
				
				coreImage.updateUVs++;
			//}
			
			vertexData.setXY(0, transformX(coreImage.bottomLeft.x, coreImage),	transformY(coreImage.bottomLeft.y, coreImage));
			vertexData.setXY(1, transformX(coreImage.topLeft.x, coreImage),		transformY(coreImage.topLeft.y, coreImage));
			vertexData.setXY(2, transformX(coreImage.topRight.x, coreImage),	transformY(coreImage.topRight.y, coreImage));
			vertexData.setXY(3, transformX(coreImage.bottomRight.x, coreImage),	transformY(coreImage.bottomRight.y, coreImage));
			
			vertexData.setColor(coreImage.displayData.color);
			vertexData.setAlpha(coreImage.combinedAlpha);
			
			// TODO: only update when you need to
			coreImage.indicesData.setIndex(0, 0);
			coreImage.indicesData.setIndex(1, 1);
			coreImage.indicesData.setIndex(2, 2);
			coreImage.indicesData.setIndex(3, 0);
			coreImage.indicesData.setIndex(4, 2);
			coreImage.indicesData.setIndex(5, 3);
		}
		finishSetVertexData(coreImage);
	}
	
	static inline function finishSetVertexData(coreImage:CoreImage) 
	{
		coreImage.isStatic = 1;
		coreImage.drawIndex = VertexData.OBJECT_POSITION;
		VertexData.OBJECT_POSITION++;
		//IndicesData.OBJECT_POSITION++;
		coreImage.parentNonStatic = false;
	}
	
	static function updateUVData(coreImage:CoreImage) 
	{
		coreImage.coreTexture.updateUVData();
		/*uvLeft = textureData.x / textureData.p2Width;
		uvTop = textureData.y / textureData.p2Height;
		uvRight = (textureData.x + textureData.width) / textureData.p2Width;
		uvBottom = (textureData.y + textureData.height) / textureData.p2Height;*/
	}
	
	static inline function transformX(x:Float, coreImage:CoreImage):Float 
	{
		return ((x / Core.STAGE_WIDTH) * coreImage.transformXMul) - 1;
	}
	
	static inline function transformY(y:Float, coreImage:CoreImage):Float
	{
		return 1 - ((y / Core.STAGE_HEIGHT) * coreImage.transformYMul);
	}
}