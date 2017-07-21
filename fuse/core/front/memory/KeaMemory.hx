package fuse.core.front.memory;

import fuse.core.front.memory.data.MemoryPool;
import fuse.core.front.memory.data.batchData.BatchData;
import fuse.core.front.memory.data.conductorData.ConductorData;
import fuse.core.front.memory.data.displayData.DisplayData;
import fuse.core.front.memory.data.renderTextureData.RenderTextureData;
import fuse.core.front.memory.data.renderTextureData.RenderTextureDrawData;
import fuse.core.front.memory.data.textureData.TextureData;
import fuse.core.front.memory.data.vertexData.VertexData;

import openfl.Memory;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

/**
 * ...
 * @author P.J.Shand
 */
class KeaMemory
{
	static var memorySize:Int = 0;
	@:isVar public static var memory(get, set):ByteArray;
	
	public var batchDataPool:MemoryPool;
	public var conductorDataPool:MemoryPool;
	public var displayDataPool:MemoryPool;
	public var textureDataPool:MemoryPool;
	public var vertexDataPool:MemoryPool;
	//public var atlasVertexDataPool:MemoryPool;
	public var renderTextureDataPool:MemoryPool;
	public var renderTextureDrawDataPool:MemoryPool;
	
	public function new(memory:ByteArray=null) 
	{
		vertexDataPool = CreatePool(VertexData.BUFFER_SIZE * VertexData.BYTES_PER_ITEM);
		batchDataPool = CreatePool(BatchData.BUFFER_SIZE * BatchData.BYTES_PER_ITEM);
		conductorDataPool = CreatePool(ConductorData.BUFFER_SIZE);
		displayDataPool = CreatePool(DisplayData.BUFFER_SIZE * DisplayData.BYTES_PER_ITEM);
		textureDataPool = CreatePool(TextureData.BUFFER_SIZE * TextureData.BYTES_PER_ITEM);
		//atlasVertexDataPool = CreatePool(VertexData.BUFFER_SIZE * VertexData.BYTES_PER_ITEM);
		renderTextureDataPool = CreatePool(RenderTextureData.BUFFER_SIZE * RenderTextureData.BYTES_PER_ITEM);
		renderTextureDrawDataPool = CreatePool(RenderTextureDrawData.BUFFER_SIZE * RenderTextureDrawData.BYTES_PER_ITEM);
		
		/*trace("batchDataPool.start     = " + batchDataPool.start);
		trace("batchDataPool.end       = " + batchDataPool.end);
		
		trace("conductorDataPool.start = " + conductorDataPool.start);
		trace("conductorDataPool.end   = " + conductorDataPool.end);
		
		trace("displayDataPool.start   = " + displayDataPool.start);
		trace("displayDataPool.end     = " + displayDataPool.end);
		
		trace("vertexDataPool.start    = " + vertexDataPool.start);
		trace("vertexDataPool.end      = " + vertexDataPool.end);
		
		trace("renderTextureDataPool.start    = " + renderTextureDataPool.start);
		trace("renderTextureDataPool.end      = " + renderTextureDataPool.end);*/
		
		if (memory == null) {
			KeaMemory.memory = new ByteArray();
		}
		else {
			KeaMemory.memory = memory;
		}
		
		
	}
	
	function CreatePool(size:Int):MemoryPool
	{
		var pool = new MemoryPool(size);
		memorySize += pool.size;
		return pool;
	}
	
	static function get_memory():ByteArray 
	{
		return memory;
	}
	
	static function set_memory(value:ByteArray):ByteArray 
	{
		memory = value;
		memory.length = memorySize + memorySize;
		memory.shareable = true;
		memory.position = 0;
		memory.endian = Endian.LITTLE_ENDIAN;
		Memory.select(memory);
		return memory;
	}
}