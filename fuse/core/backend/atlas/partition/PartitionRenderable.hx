package fuse.core.backend.atlas.partition;
import fuse.core.communication.data.indices.IIndicesData;
import fuse.core.communication.data.indices.IndicesData;
import fuse.core.backend.Core;
import fuse.core.backend.atlas.SheetPacker;
import fuse.core.backend.texture.TextureRenderBatch;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.front.atlas.packer.AtlasPartition;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.texture.RenderTexture;
import openfl.geom.Point;
import fuse.core.backend.texture.TextureRenderBatch.RenderBatchDef;

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
	var indicesData:IIndicesData;
	
	public function new(partition:AtlasPartition, textureData:ITextureData) 
	{
		this.textureData = textureData;
		this.partition = partition;
		vertexData = new VertexData();
		indicesData = new IndicesData();
		
		//trace("partition = " + partition);
		//trace("textureData = " + textureData);
		//trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		
		RenderTexture.currentRenderTargetId = textureData.atlasTextureId;
		
		/*
		WorkerCore.displayListBuilder.process(coreDisplay);
		
		coreDisplay.releaseToPool();*/
		
		//WorkerCore.textureOrder.setValues(textureData);
		
		var left:Float = textureData.baseX;
		var top:Float = textureData.baseY;
		var right:Float = textureData.baseWidth / textureData.baseP2Width;
		var bottom:Float = textureData.baseHeight / textureData.baseP2Height;
		
		// Where to sample from source texture
		// BOTTOM LEFT
		vertexData.setU(0, left);
		vertexData.setV(0, bottom);
		
		// TOP LEFT
		vertexData.setU(1, left);
		vertexData.setV(1, top);
		
		// TOP RIGHT
		vertexData.setU(2, right);
		vertexData.setV(2, top);
		
		// BOTTOM RIGHT
		vertexData.setU(3, right);
		vertexData.setV(3, bottom);
		
		
		
		
		
		
		var mulX:Float = SheetPacker.bufferWidth / 2;
		var mulY:Float = SheetPacker.bufferHeight / 2;
		
		var offsetX:Float = -mulX;
		var offsetY:Float = -mulY;
		
		var bottomLeft:Point = new Point(partition.x, partition.y + partition.height);
		var topLeft:Point = new Point(partition.x, partition.y);
		var topRight:Point = new Point(partition.x + partition.width, partition.y);
		var bottomRight:Point = new Point(partition.x + partition.width, partition.y + partition.height);
		
		vertexData.setX(0, (bottomLeft.x + offsetX) / mulX);
		vertexData.setY(0, (-bottomLeft.y - offsetY) / mulY);
		//vertexData.z1 = 0;
		
		vertexData.setX(1, (topLeft.x + offsetX) / mulX);
		vertexData.setY(1, (-topLeft.y - offsetY) / mulY);
		//vertexData.z2 = 0;
		
		vertexData.setX(2, (topRight.x + offsetX) / mulX);
		vertexData.setY(2, (-topRight.y - offsetY) / mulY);
		//vertexData.z3 = 0;
		
		vertexData.setX(3, (bottomRight.x + offsetX) / mulX);
		vertexData.setY(3, (-bottomRight.y - offsetY) / mulY);
		//vertexData.z4 = 0;
		
		vertexData.setColor(0x0);
		vertexData.setAlpha(1);
		
		//vertexData.setColor(displayData.color);
		//vertexData.setAlpha(displayData.alpha);
		
		/*trace([vertexData.u1, vertexData.v1]);
		trace([vertexData.u2, vertexData.v2]);
		trace([vertexData.u3, vertexData.v3]);
		trace([vertexData.u4, vertexData.v4]);
		
		trace([vertexData.x1, vertexData.y1]);
		trace([vertexData.x2, vertexData.y2]);
		trace([vertexData.x3, vertexData.y3]);
		trace([vertexData.x4, vertexData.y4]);*/
		
		// TODO: only update when you need to
		indicesData.setIndex(0, 0);
		indicesData.setIndex(1, 1);
		indicesData.setIndex(2, 2);
		indicesData.setIndex(3, 0);
		indicesData.setIndex(4, 2);
		indicesData.setIndex(5, 3);
		
		//textureData.atlasTextureId
		//trace("textureData.textureId = " + textureData.textureId);
		//vertexData.batchTextureIndex = 0;// textureData.textureId;
		vertexData.setT(0, 0);
		vertexData.setT(1, 0);
		vertexData.setT(2, 0);
		vertexData.setT(3, 0);
		
		//vertexData.renderBatchIndex = 0;
		
		Core.textureOrder.setValues(textureData.textureId, textureData);
	}
	
	public function setVertexData() 
	{
		//trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		
		var renderBatchIndex:Int = Core.textureRenderBatch.getRenderBatchIndex(VertexData.OBJECT_POSITION);
		var renderBatchDef:RenderBatchDef = Core.textureRenderBatch.getRenderBatchDef(renderBatchIndex);
		
		for (i in 0...renderBatchDef.textureIdArray.length) 
		{
			if (renderBatchDef.textureIdArray[i] == textureData.textureId) {
				//trace("i = " + i);
				//vertexData.batchTextureIndex = i;
				vertexData.setT(0, i);
				vertexData.setT(1, i);
				vertexData.setT(2, i);
				vertexData.setT(3, i);
			}
		}
		
		VertexData.OBJECT_POSITION++;
		IndicesData.OBJECT_POSITION++;
	}
	
}