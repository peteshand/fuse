package fuse.core.assembler.batches.batch;

import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasBatch extends BaseBatch implements IBatch
{
	var vertexData:IVertexData = new VertexData();
	
	public function new() 
	{
		super();
	}
	
	override public function add(renderable:ICoreRenderable, renderTarget:Int, batchType:BatchType):Bool
	{
		if (batchType != BatchType.ATLAS) return false;
		return super.add(renderable, renderTarget, batchType);
	}
	
	public function writeVertex() 
	{
		//trace("hasChanged = " + hasChanged);
		batchData.clearRenderTarget = 1;
		
		setBatchProps();
		
		for (i in 0...renderables.length) 
		{
			VertexWriter.VERTEX_COUNT += VertexData.BYTES_PER_ITEM;
			writePartitionVertex(untyped renderables[i]);
		}
		
		return true;
	}
	
	function writePartitionVertex(partition:AtlasPartition) 
	{
		var textureData:ITextureData = null;
		
		var left:Float = 0;
		var top:Float = 0;
		var right:Float = 0;
		var bottom:Float = 0;
		
		if (partition.lastFramePairPartition == null) {
			textureData = partition.coreTexture.textureData;
			partition.coreTexture.rotate = partition.rotate;

			left = textureData.x;
			top = textureData.y;
			right = textureData.width / textureData.p2Width;
			bottom = textureData.height / textureData.p2Height;
		}
		else {
			textureData = partition.lastFramePairPartition.coreTexture.textureData;
			partition.rotate = false;
			
			left = partition.lastFramePairPartition.x / Fuse.MAX_TEXTURE_SIZE;
			top = partition.lastFramePairPartition.y / Fuse.MAX_TEXTURE_SIZE;
			right = left + (partition.lastFramePairPartition.width / Fuse.MAX_TEXTURE_SIZE);
			bottom = top + (partition.lastFramePairPartition.height / Fuse.MAX_TEXTURE_SIZE);
		}

		
		// Where to sample from source texture
		vertexData.setUV(0, left, bottom);	// BOTTOM LEFT
		vertexData.setUV(1, left, top);		// TOP LEFT
		vertexData.setUV(2, right, top);	// TOP RIGHT
		vertexData.setUV(3, right, bottom); // BOTTOM RIGHT
		
		var mulX:Float = Fuse.MAX_TEXTURE_SIZE / 2;
		var mulY:Float = Fuse.MAX_TEXTURE_SIZE / 2;
		
		var offsetX:Float = -mulX;
		var offsetY:Float = -mulY;
		
		var bottomLeftX:Float = (partition.x + offsetX) / mulX;
		var bottomLeftY:Float = (-partition.y - partition.height - offsetY) / mulY;
		
		var topLeftX:Float = (partition.x + offsetX) / mulX;
		var topLeftY:Float = (-partition.y - offsetY) / mulY;
		
		var topRightX:Float = (partition.x + partition.width + offsetX) / mulX;
		var topRightY:Float = (-partition.y - offsetY) / mulY;
		
		var bottomRightX:Float = (partition.x + partition.width + offsetX) / mulX;
		var bottomRightY:Float = (-partition.y - partition.height - offsetY) / mulY;
		
		//trace([(bottomLeft.x + offsetX) / mulX,	(-bottomLeft.y - offsetY) / mulY]);
		//trace([(topLeft.x + offsetX) / mulX,		(-topLeft.y - offsetY) / mulY]);
		//trace([(topRight.x + offsetX) / mulX,		(-topRight.y - offsetY) / mulY]);
		//trace([(bottomRight.x + offsetX) / mulX,	(-bottomRight.y - offsetY) / mulY]);
		//

		if (partition.rotate) {
			vertexData.setRect(0, bottomRightX,	bottomRightY, partition.width, partition.height);
			vertexData.setRect(1, bottomLeftX,	bottomLeftY, partition.width, partition.height);
			vertexData.setRect(2, topLeftX,		topLeftY, partition.width, partition.height);
			vertexData.setRect(3, topRightX,		topRightY, partition.width, partition.height);
		} else {
			vertexData.setRect(0, bottomLeftX,	bottomLeftY, partition.width, partition.height);
			vertexData.setRect(1, topLeftX,		topLeftY, partition.width, partition.height);
			vertexData.setRect(2, topRightX,		topRightY, partition.width, partition.height);
			vertexData.setRect(3, bottomRightX,	bottomRightY, partition.width, partition.height);
		}
		
		
		vertexData.setColor(0, 0x0);
		vertexData.setColor(1, 0x0);
		vertexData.setColor(2, 0x0);
		vertexData.setColor(3, 0x0);
		//for (i in 0...4) 
		//{
			//vertexData.setR(i, 0);
			//vertexData.setG(i, 0);
			//vertexData.setB(i, 0);
			//vertexData.setA(i, 0);
		//}
		vertexData.setAlpha(1);
		
		// don't draw masks while drawing into atlas //
		vertexData.setMaskTexture(-1);
		///////////////////////////////////////
		
		vertexData.setTexture(partition.textureIndex);
		
		VertexData.OBJECT_POSITION++;

	}
}