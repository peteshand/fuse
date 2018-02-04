package fuse.core.assembler.batches.batch;

import fuse.core.assembler.atlas.partition.AtlasPartition;
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
		//if (AtlasSheet.shouldClear) {
			batchData.clearRenderTarget = 1;
		/*}
		else {
			batchData.clearRenderTarget = 0;
		}*/
		
		trace(this);
		
		setBatchProps();
		
		for (i in 0...renderables.length) 
		{
			VertexWriter.VERTEX_COUNT += VertexData.BYTES_PER_ITEM;
			//renderables[i].writeVertex();
			writePartitionVertex(untyped renderables[i]);
		}
		
		return true;
	}
	
	function writePartitionVertex(partition:AtlasPartition) 
	{
		//if (partition.placed) return;
		
		var textureData:ITextureData = partition.coreTexture.textureData;
		
		/*No longer required*/ //RenderTexture.currentRenderTargetId = textureData.atlasTextureId;
		
		var left:Float = textureData.baseX;
		var top:Float = textureData.baseY;
		var right:Float = textureData.baseWidth / textureData.baseP2Width;
		var bottom:Float = textureData.baseHeight / textureData.baseP2Height;
		
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
		
		//textureData.atlasTextureId
		//trace("textureData.textureId = " + textureData.textureId);
		//vertexData.batchTextureIndex = 0;// textureData.textureId;
		vertexData.setTexture(0);
		
		// don't draw masks while drawing into atlas //
		vertexData.setMaskTexture(-1);
		///////////////////////////////////////
		
		//vertexData.renderBatchIndex = 0;
		
		//Core.textureOrder.setValues(textureData.textureId, textureData, true);
	//}
	
	//public function setVertexData(partition:AtlasPartition) 
	//{
		//if (partition.placed) return;
		//partition.placed = true;
		
		//var textureData:ITextureData = partition.textureData;
		
		//trace("PartitionRenderable VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		
		//var renderBatchIndex:Int = Core.textureRenderBatch.getRenderBatchIndex(VertexData.OBJECT_POSITION);
		//var renderBatchDef:RenderBatchDef = Core.textureRenderBatch.getRenderBatchDef(renderBatchIndex);
		//var vertexData:IVertexData = new VertexData();
		
		//for (i in 0...renderBatchDef.textureIdArray.length) 
		//{
			//if (renderBatchDef.textureIdArray[i] == textureData.textureId) {
				////trace("i = " + i);
				////vertexData.batchTextureIndex = i;
				//vertexData.setTexture(i);
			//}
		//}
		
		vertexData.setTexture(partition.textureIndex);
		
		VertexData.OBJECT_POSITION++;

	}
}