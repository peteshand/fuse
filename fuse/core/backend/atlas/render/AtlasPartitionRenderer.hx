package fuse.core.backend.atlas.render;

import fuse.core.backend.atlas.partition.AtlasPartition;
import fuse.core.backend.texture.TextureRenderBatch.RenderBatchDef;
import fuse.core.communication.data.indices.IIndicesData;
import fuse.core.communication.data.indices.IndicesData;
import fuse.core.communication.data.textureData.ITextureData;
import fuse.core.communication.data.vertexData.IVertexData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.texture.RenderTexture;
import openfl.geom.Point;

/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse.texture.RenderTexture)
@:access(fuse.core.backend.atlas.SheetPacker)
class AtlasPartitionRenderer
{
	public function new() { }
	
	static public function add(partition:AtlasPartition) 
	{
		if (partition.placed) return;
		
		var textureData:ITextureData = partition.textureData;
		
		//trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		//trace("textureId = " + textureData.textureId);
		
		var vertexData:IVertexData = new VertexData();
		var indicesData:IIndicesData = new IndicesData();
		
		RenderTexture.currentRenderTargetId = textureData.atlasTextureId;
		
		var left:Float = textureData.baseX;
		var top:Float = textureData.baseY;
		var right:Float = textureData.baseWidth / textureData.baseP2Width;
		var bottom:Float = textureData.baseHeight / textureData.baseP2Height;
		
		// Where to sample from source texture
		vertexData.setUV(0, left, bottom);	// BOTTOM LEFT
		vertexData.setUV(1, left, top);		// TOP LEFT
		vertexData.setUV(2, right, top);	// TOP RIGHT
		vertexData.setUV(3, right, bottom); // BOTTOM RIGHT
		
		var mulX:Float = SheetPacker.bufferWidth / 2;
		var mulY:Float = SheetPacker.bufferHeight / 2;
		
		var offsetX:Float = -mulX;
		var offsetY:Float = -mulY;
		
		var bottomLeft:Point = new Point(partition.x, partition.y + partition.height);
		var topLeft:Point = new Point(partition.x, partition.y);
		var topRight:Point = new Point(partition.x + partition.width, partition.y);
		var bottomRight:Point = new Point(partition.x + partition.width, partition.y + partition.height);
		
		//trace([(bottomLeft.x + offsetX) / mulX,	(-bottomLeft.y - offsetY) / mulY]);
		//trace([(topLeft.x + offsetX) / mulX,		(-topLeft.y - offsetY) / mulY]);
		//trace([(topRight.x + offsetX) / mulX,		(-topRight.y - offsetY) / mulY]);
		//trace([(bottomRight.x + offsetX) / mulX,	(-bottomRight.y - offsetY) / mulY]);
		
		vertexData.setXY(0, (bottomLeft.x + offsetX) / mulX,	(-bottomLeft.y - offsetY) / mulY);
		vertexData.setXY(1, (topLeft.x + offsetX) / mulX,		(-topLeft.y - offsetY) / mulY);
		vertexData.setXY(2, (topRight.x + offsetX) / mulX,		(-topRight.y - offsetY) / mulY);
		vertexData.setXY(3, (bottomRight.x + offsetX) / mulX,	(-bottomRight.y - offsetY) / mulY);
		
		vertexData.setColor(0x0);
		vertexData.setAlpha(1);
		
		/*vertexData.setMaskT(0, -1);
		vertexData.setMaskT(1, -1);
		vertexData.setMaskT(2, -1);
		vertexData.setMaskT(3, -1);*/
		
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
		vertexData.setTexture(0);
		
		// don't draw masks while drawing into atlas //
		vertexData.setMaskTexture(-1);
		///////////////////////////////////////
		
		//vertexData.renderBatchIndex = 0;
		
		Core.textureOrder.setValues(textureData.textureId, textureData, true);
	}
	
	public static function setVertexData(partition:AtlasPartition) 
	{
		if (partition.placed) return;
		partition.placed = true;
		
		var textureData:ITextureData = partition.textureData;
		
		//trace("PartitionRenderable VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		
		var renderBatchIndex:Int = Core.textureRenderBatch.getRenderBatchIndex(VertexData.OBJECT_POSITION);
		var renderBatchDef:RenderBatchDef = Core.textureRenderBatch.getRenderBatchDef(renderBatchIndex);
		var vertexData:IVertexData = new VertexData();
		
		for (i in 0...renderBatchDef.textureIdArray.length) 
		{
			if (renderBatchDef.textureIdArray[i] == textureData.textureId) {
				//trace("i = " + i);
				//vertexData.batchTextureIndex = i;
				vertexData.setTexture(i);
			}
		}
		
		VertexData.OBJECT_POSITION++;
		//IndicesData.OBJECT_POSITION++;
	}
}