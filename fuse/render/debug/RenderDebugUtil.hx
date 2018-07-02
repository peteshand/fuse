package fuse.render.debug;
import fuse.core.communication.data.batchData.IBatchData;
import fuse.core.communication.memory.SharedMemory;
import fuse.render.buffers.Buffer;

/**
 * ...
 * @author P.J.Shand
 */
class RenderDebugUtil
{

	public function new() 
	{
		
	}
	
	public static function batchDebug(batchData:IBatchData) 
	{
		//trace("startIndex      = " + batchData.startIndex);
		trace("numItemsInBatch = " + batchData.numItems);
		trace([batchData.textureId1, batchData.textureId2, batchData.textureId3, batchData.textureId4, batchData.textureId5, batchData.textureId6, batchData.textureId7, batchData.textureId8]);
		trace("renderTargetId = " + batchData.renderTargetId);
	}
	
	public static inline function vertexDebug(startIndex:Int, numItems:Int) 
	{
		//trace("numItems = " + numItems);
		if (numItems == 0) return;
		
		/*trace("Batch: " + i);
		trace("batchData.startIndex = " + batchData.startIndex);
		trace("numItemsInBatch = " + numItemsInBatch);
		trace([batchData.textureId1, batchData.textureId2, batchData.textureId3, batchData.textureId4]);
		trace("targetTextureId = " + targetTextureId.value);*/
		
		SharedMemory.memory.position = startIndex;// + (j * VertexData.BYTES_PER_ITEM);
		//trace("startIndex = " + startIndex);
		
		for (j in 0...numItems) 
		{
			//trace("SharedMemory.memory.position = " + SharedMemory.memory.position);
			
			for (k in 0...Buffer.VERTICES_PER_QUAD) 
			{
				// New Order
				var INDEX_X:Float = SharedMemory.memory.readFloat();
				var INDEX_Y:Float = SharedMemory.memory.readFloat();
				
				var INDEX_Texture:Float = SharedMemory.memory.readFloat();
				var INDEX_ALPHA:Float = SharedMemory.memory.readFloat();
				var INDEX_U:Float = SharedMemory.memory.readFloat();
				var INDEX_V:Float = SharedMemory.memory.readFloat();
				
				var INDEX_COLOUR:UInt = SharedMemory.memory.readUnsignedInt();
				
				var INDEX_MU:Float = SharedMemory.memory.readFloat();
				var INDEX_MV:Float = SharedMemory.memory.readFloat();
				var INDEX_MaskTexture:Float = SharedMemory.memory.readFloat();
				var INDEX_MASK_BASE_VALUE:Float = SharedMemory.memory.readFloat();
				
				// old order
				//var INDEX_X:Float = SharedMemory.memory.readFloat();
				//var INDEX_Y:Float = SharedMemory.memory.readFloat();
				//
				//var INDEX_U:Float = SharedMemory.memory.readFloat();
				//var INDEX_V:Float = SharedMemory.memory.readFloat();
				//var INDEX_MU:Float = SharedMemory.memory.readFloat();
				//var INDEX_MV:Float = SharedMemory.memory.readFloat();
				//
				//var INDEX_COLOUR:UInt = SharedMemory.memory.readUnsignedInt();
				//
				//var INDEX_Texture:Float = SharedMemory.memory.readFloat();
				//var INDEX_MaskTexture:Float = SharedMemory.memory.readFloat();
				//var INDEX_MASK_BASE_VALUE:Float = SharedMemory.memory.readFloat();
				//var INDEX_ALPHA:Float = SharedMemory.memory.readFloat();
				
				//var INDEX_R:Float = SharedMemory.memory.readFloat();
				//var INDEX_G:Float = SharedMemory.memory.readFloat();
				//var INDEX_B:Float = SharedMemory.memory.readFloat();
				//var INDEX_A:Float = SharedMemory.memory.readFloat();
				
				if (k == 0){
					trace([INDEX_Texture, Math.floor(1024 * (1 + INDEX_X)), Math.floor(2048 - ((1 + INDEX_Y) * 1024))]);
				}
				//trace([1024 * (1 + INDEX_X), 2048 - ((1 + INDEX_Y) * 1024), INDEX_U, INDEX_V]);
				//trace([INDEX_Texture, INDEX_ALPHA]);
				//trace("Colour = " + StringTools.hex(INDEX_COLOUR));
				//trace([INDEX_MU, INDEX_MV, INDEX_MaskTexture, INDEX_MASK_BASE_VALUE]);
				//trace([INDEX_R, INDEX_G, INDEX_B, INDEX_A]);
				//trace("--");
				
				//trace("INDEX_X = " + INDEX_X);
				//trace("INDEX_Y = " + INDEX_Y);
				//trace("INDEX_U = " + INDEX_U);
				//trace("INDEX_V = " + INDEX_V);
				////trace("INDEX_MU = " + INDEX_MU);
				////trace("INDEX_MV = " + INDEX_MV);
				//trace("INDEX_Texture = " + INDEX_Texture);
				////trace("INDEX_MaskTexture = " + INDEX_MaskTexture);
				////trace("INDEX_MASK_BASE_VALUE = " + INDEX_MASK_BASE_VALUE);
				////trace("INDEX_ALPHA = " + INDEX_ALPHA);
				//trace("INDEX_R = " + INDEX_R);
				//trace("INDEX_G = " + INDEX_G);
				//trace("INDEX_B = " + INDEX_B);
				//trace("INDEX_A = " + INDEX_A);
				
			}
			//trace("---------------------");
		}
	}
	
	public static function debugIndex(numItemsInBatch:Int, startIndex:Int) 
	{
		SharedMemory.memory.position = startIndex;
		for (i in 0...numItemsInBatch) 
		{
			var i1:Int = SharedMemory.memory.readShort();
			var i2:Int = SharedMemory.memory.readShort();
			var i3:Int = SharedMemory.memory.readShort();
			var i4:Int = SharedMemory.memory.readShort();
			var i5:Int = SharedMemory.memory.readShort();
			var i6:Int = SharedMemory.memory.readShort();
			//trace([i1, i2, i3, i4, i5, i6]);
		}
	}
}