package fuse.core.assembler.batches.batch;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.backend.Core;
import fuse.core.backend.display.CoreImage;
import fuse.core.backend.texture.CoreTexture;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.backend.display)
class DirectBatch extends BaseBatch implements IBatch
{
	public function new() 
	{
		super();
	}
	
	override function getTextureIndex(renderable:ICoreRenderable) 
	{
		return batchTextures.getTextureIndex(renderable.coreTexture.textureData.atlasTextureId);
	}
	
	override public function add(renderable:ICoreRenderable, renderTarget:Int, batchType:BatchType):Bool
	{
		if (batchType != BatchType.DIRECT) return false;
		return super.add(renderable, renderTarget, batchType);
	}
	
	public function writeVertex() 
	{
		setBatchProps();
		
		for (i in 0...renderables.length) 
		{
			VertexWriter.VERTEX_COUNT += VertexData.BYTES_PER_ITEM;
			//renderables[i].writeVertex();
			writeLayerVertex(cast renderables[i]);
		}
	}
	
	function writeLayerVertex(image:CoreImage) 
	{
		if (image.displayData.visible == 0) return;
		
		
		var vertexData:IVertexData = image.vertexData;
		var coreTexture:CoreTexture = image.coreTexture;
		
		if (image.isStatic == 0 || image.drawIndex != VertexData.OBJECT_POSITION) {
			
			vertexData.setTexture(image.textureIndex);
			
			if (image.mask == null) vertexData.setMaskTexture(-1);
			else {
				// TODO: update value to point to correct batch textureIndex
				vertexData.setMaskTexture(0);
			}
			
			//if (updateUVs < 5) {
				//trace([coreTexture.uvTop, coreTexture.uvBottom]);
				
				vertexData.setUV(0, coreTexture.uvLeft,		coreTexture.uvBottom);	// bottom left
				vertexData.setUV(1, coreTexture.uvLeft,		coreTexture.uvTop);		// top left
				vertexData.setUV(2, coreTexture.uvRight,	coreTexture.uvTop);		// top right
				vertexData.setUV(3, coreTexture.uvRight,	coreTexture.uvBottom);	// bottom right
				
				if (image.mask != null) {
					vertexData.setMaskUV(0, image.mask.coreTexture.uvLeft,	image.mask.coreTexture.uvBottom);	// bottom left
					vertexData.setMaskUV(1, image.mask.coreTexture.uvLeft,	image.mask.coreTexture.uvTop);	// top left
					vertexData.setMaskUV(2, image.mask.coreTexture.uvRight,	image.mask.coreTexture.uvTop);	// top right
					vertexData.setMaskUV(3, image.mask.coreTexture.uvRight,	image.mask.coreTexture.uvBottom);	// bottom right
				}
				
				image.updateUVs++;
			//}
			
			//if (renderTarget == -1) {
				vertexData.setXY(0, image.quadData.bottomLeftX,	image.quadData.bottomLeftY);
				vertexData.setXY(1, image.quadData.topLeftX,	image.quadData.topLeftY);
				vertexData.setXY(2, image.quadData.topRightX,	image.quadData.topRightY);
				vertexData.setXY(3, image.quadData.bottomRightX,image.quadData.bottomRightY);
			//}
			//else {
				//trace("resize");	
				//vertexData.setXY(0, ResizeX(image.bottomLeft.x),	ResizeY(image.bottomLeft.y));
				//vertexData.setXY(1, ResizeX(image.topLeft.x),	ResizeY(image.topLeft.y));
				//vertexData.setXY(2, ResizeX(image.topRight.x),	ResizeY(image.topRight.y));
				//vertexData.setXY(3, ResizeX(image.bottomRight.x),ResizeY(image.bottomRight.y));
			//}
			vertexData.setColor(0, image.displayData.colorBL);
			vertexData.setColor(1, image.displayData.colorTL);
			vertexData.setColor(2, image.displayData.colorTR);
			vertexData.setColor(3, image.displayData.colorBR);
			
			vertexData.setAlpha(image.combinedAlpha);
		}
		
		image.isStatic = 1;
		image.drawIndex = VertexData.OBJECT_POSITION;
		VertexData.OBJECT_POSITION++;
		image.parentNonStatic = false;
	}
	
	function ResizeX(value:Float):Float
	{
		return ((value + 1) * (Fuse.current.stage.stageWidth / Fuse.MAX_TEXTURE_SIZE)) - 1;
	}
	
	function ResizeY(value:Float):Float
	{
		return ((value - 1) * (Fuse.current.stage.stageHeight / Fuse.MAX_TEXTURE_SIZE)) + 1;
	}
}