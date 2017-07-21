package fuse.core.worker.thread.atlas.partition;
import fuse.core.worker.thread.WorkerCore;
import fuse.core.worker.thread.atlas.SheetPacker;
import fuse.core.worker.thread.display.TextureRenderBatch;
import fuse.core.front.memory.data.textureData.ITextureData;
import fuse.core.front.atlas.packer.AtlasPartition;
import fuse.core.front.memory.data.vertexData.IVertexData;
import fuse.core.front.memory.data.vertexData.VertexData;
import fuse.texture.RenderTexture;
import openfl.geom.Point;
import fuse.core.worker.thread.display.TextureRenderBatch.RenderBatchDef;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class PartitionRenderable
{
	var partition:AtlasPartition;
	var textureData:ITextureData;
	var vertexData:IVertexData;
	
	public function new(partition:AtlasPartition, textureData:ITextureData) 
	{
		this.textureData = textureData;
		this.partition = partition;
		vertexData = new VertexData();
		
		//trace("partition = " + partition);
		//trace("textureData = " + textureData);
		//trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		
		RenderTexture.currentRenderTargetId = textureData.atlasTextureId;
		
		/*
		WorkerCore.workerDisplayList.process(workerDisplay);
		
		workerDisplay.releaseToPool();*/
		
		//WorkerCore.textureOrder.setValues(textureData);
		
		var left:Float = textureData.baseX;
		var top:Float = textureData.baseY;
		var right:Float = textureData.baseWidth / textureData.baseP2Width;
		var bottom:Float = textureData.baseHeight / textureData.baseP2Height;
		
		// Where to sample from source texture
		// BOTTOM LEFT
		vertexData.u1 = left;
		vertexData.v1 = bottom;
		
		// TOP LEFT
		vertexData.u2 = left;
		vertexData.v2 = top;
		
		// TOP RIGHT
		vertexData.u3 = right;
		vertexData.v3 = top;
		
		// BOTTOM RIGHT
		vertexData.u4 = right;
		vertexData.v4 = bottom;
		
		
		
		
		
		
		var mulX:Float = SheetPacker.bufferWidth / 2;
		var mulY:Float = SheetPacker.bufferHeight / 2;
		
		var offsetX:Float = -mulX;
		var offsetY:Float = -mulY;
		
		var bottomLeft:Point = new Point(partition.x, partition.y + partition.height);
		var topLeft:Point = new Point(partition.x, partition.y);
		var topRight:Point = new Point(partition.x + partition.width, partition.y);
		var bottomRight:Point = new Point(partition.x + partition.width, partition.y + partition.height);
		
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
		
		/*trace([vertexData.u1, vertexData.v1]);
		trace([vertexData.u2, vertexData.v2]);
		trace([vertexData.u3, vertexData.v3]);
		trace([vertexData.u4, vertexData.v4]);
		
		trace([vertexData.x1, vertexData.y1]);
		trace([vertexData.x2, vertexData.y2]);
		trace([vertexData.x3, vertexData.y3]);
		trace([vertexData.x4, vertexData.y4]);*/
		
		//textureData.atlasTextureId
		//trace("textureData.textureId = " + textureData.textureId);
		vertexData.batchTextureIndex = 0;// textureData.textureId;
		//vertexData.renderBatchIndex = 0;
		
		WorkerCore.textureOrder.setValues(textureData.textureId, textureData);
		//VertexData.OBJECT_POSITION++;
	}
	
	public function setVertexData() 
	{
		//trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		
		var renderBatchIndex:Int = WorkerCore.textureRenderBatch.getRenderBatchIndex(VertexData.OBJECT_POSITION);
		var renderBatchDef:RenderBatchDef = WorkerCore.textureRenderBatch.getRenderBatchDef(renderBatchIndex);
		
		for (i in 0...renderBatchDef.textureIdArray.length) 
		{
			if (renderBatchDef.textureIdArray[i] == textureData.textureId) {
				//trace("i = " + i);
				vertexData.batchTextureIndex = i;
			}
		}
		
		VertexData.OBJECT_POSITION++;
	}
	
}