package fuse.core.assembler.batches.batch;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.communication.data.vertexData.VertexData;

/**
 * ...
 * @author P.J.Shand
 */
class LayerCacheBatch extends BaseBatch implements IBatch
{
	public function new() 
	{
		super();
	}
	
	public function writeVertex() 
	{
		/*
		//batchData.clearRenderTarget =						// Currently not set anywhere
		//batchData.height = 								// Not sure if this is needed
		//batchData.length = 								// Not sure if this is needed
		batchData.numItems = renderables.length;
		batchData.numTextures = batchTextures.textureIds.length;
		batchData.renderTargetId = renderTarget;
		batchData.startIndex = VertexWriter.VERTEX_COUNT;
		batchData.textureId1 = batchTextures.textureId1;
		batchData.textureId2 = batchTextures.textureId2;
		batchData.textureId3 = batchTextures.textureId3;
		batchData.textureId4 = batchTextures.textureId4;
		//batchData.width = 								// Not sure if this is needed
		*/
		
		
		for (i in 0...renderables.length) 
		{
			VertexWriter.VERTEX_COUNT += VertexData.BYTES_PER_ITEM;
			//renderables[i].writeVertex();
			writeLayerVertex(renderables[i]);
		}
	}
	
	function writeLayerVertex(renderable:ICoreRenderable) 
	{
		
	}
}