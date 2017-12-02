




package fuse.core.assembler.batches.batch;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;

/**
 * ...
 * @author P.J.Shand
 */
class CacheDrawBatch extends BaseBatch implements IBatch
{
	public var vertexData:IVertexData = new VertexData();
	
	public function new() 
	{
		super();
	}
	
	override public function add(renderable:ICoreRenderable, renderTarget:Int, batchType:BatchType):Bool
	{
		if (batchType != BatchType.CACHE_DRAW) return false;
		return super.add(renderable, renderTarget, batchType);
	}
	
	public function writeVertex() 
	{
		setBatchProps();
		
		for (i in 0...renderables.length) 
		{
			VertexWriter.VERTEX_COUNT += VertexData.BYTES_PER_ITEM;
			writeLayerVertex(renderables[i]);
		}
	}
	
	function writeLayerVertex(renderable:ICoreRenderable) 
	{
		//trace("draw cache to back buffer");
		vertexData.setTexture(renderable.textureIndex);
		vertexData.setMaskTexture( -1);
		
		vertexData.setUV(0, 0, maxY());	// bottom left
		vertexData.setUV(1, 0, 0);	// top left
		vertexData.setUV(2, maxX(), 0);	// top right
		vertexData.setUV(3, maxX(), maxY());	// bottom right
		
		//vertexData.setXY(0, -1, minY());
		//vertexData.setXY(1, -1, 1);
		//vertexData.setXY(2, maxX(), 1);
		//vertexData.setXY(3, maxX(), minY());
		
		vertexData.setXY(0, -1, -1);
		vertexData.setXY(1, -1, 1);
		vertexData.setXY(2, 1, 1);
		vertexData.setXY(3, 1, -1);
		
		vertexData.setColor(0, 0x0);
		vertexData.setColor(1, 0x0);
		vertexData.setColor(2, 0x0);
		vertexData.setColor(3, 0x0);
		
		vertexData.setAlpha(1);
		
		//image.isStatic = 1;
		//image.drawIndex = VertexData.OBJECT_POSITION;
		VertexData.OBJECT_POSITION++;
		//image.parentNonStatic = false;
	}
	
	inline function maxX():Float
	{
		return Fuse.current.stage.stageWidth / Fuse.MAX_TEXTURE_SIZE;
	}
	
	inline function maxY():Float
	{
		return Fuse.current.stage.stageHeight / Fuse.MAX_TEXTURE_SIZE;
	}
	
	//inline function maxX():Float
	//{
		//return -1 + ((Fuse.MAX_TEXTURE_SIZE / Fuse.current.stage.stageWidth) * 2);
	//}
	//
	//inline function minY():Float
	//{
		//return 1 - ((Fuse.MAX_TEXTURE_SIZE / Fuse.current.stage.stageHeight) * 2);
	//}
}