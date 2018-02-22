package fuse.core.assembler.batches.batch;

import fuse.core.assembler.atlas.sheet.partition.AtlasPartition;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import openfl.geom.Point;

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
			
			left = textureData.baseX;
			top = textureData.baseY;
			right = textureData.baseWidth / textureData.baseP2Width;
			bottom = textureData.baseHeight / textureData.baseP2Height;
		}
		else {
			//trace([partition.x, partition.y, partition.width, partition.height]);
			//trace([partition.lastFramePairPartition.x, partition.lastFramePairPartition.y, partition.lastFramePairPartition.width, partition.lastFramePairPartition.height]);
			textureData = partition.lastFramePairPartition.coreTexture.textureData;
			
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
		
		var bottomLeftX:Float = partition.x;
		var bottomLeftY:Float = partition.y + partition.height;
		
		var topLeftX:Float = partition.x;
		var topLeftY:Float = partition.y;
		
		var topRightX:Float = partition.x + partition.width;
		var topRightY:Float = partition.y;
		
		var bottomRightX:Float = partition.x + partition.width;
		var bottomRightY:Float = partition.y + partition.height;
		
		//trace([(bottomLeft.x + offsetX) / mulX,	(-bottomLeft.y - offsetY) / mulY]);
		//trace([(topLeft.x + offsetX) / mulX,		(-topLeft.y - offsetY) / mulY]);
		//trace([(topRight.x + offsetX) / mulX,		(-topRight.y - offsetY) / mulY]);
		//trace([(bottomRight.x + offsetX) / mulX,	(-bottomRight.y - offsetY) / mulY]);
		
		vertexData.setXY(0, (bottomLeftX + offsetX) / mulX,		(-bottomLeftY - offsetY) / mulY);
		vertexData.setXY(1, (topLeftX + offsetX) / mulX,		(-topLeftY - offsetY) / mulY);
		vertexData.setXY(2, (topRightX + offsetX) / mulX,		(-topRightY - offsetY) / mulY);
		vertexData.setXY(3, (bottomRightX + offsetX) / mulX,	(-bottomRightY - offsetY) / mulY);
		
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