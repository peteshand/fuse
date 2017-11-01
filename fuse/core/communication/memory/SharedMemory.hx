package fuse.core.communication.memory;

import fuse.core.communication.data.MemoryPool;
import fuse.core.communication.data.batchData.BatchData;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.communication.data.displayData.DisplayData;
import fuse.core.communication.data.indices.IndicesData;
import fuse.core.communication.data.renderTextureData.RenderTextureData;
import fuse.core.communication.data.renderTextureData.RenderTextureDrawData;
import fuse.core.communication.data.textureData.TextureData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.messenger.MessageManager;
import fuse.core.messenger.Messenger;
import fuse.core.utils.WorkerInfo;

import openfl.Memory;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

/**
 * ...
 * @author P.J.Shand
 */
class SharedMemory
{
	static var memorySize:Int = 0;
	@:isVar public static var memory(get, set):ByteArray;
	
	public var vertexDataPool:MemoryPool;
	public var indicesDataPool:MemoryPool;
	public var batchDataPool:MemoryPool;
	public var conductorDataPool:MemoryPool;
	public var displayDataPool:MemoryPool;
	public var textureDataPool:MemoryPool;
	//public var atlasVertexDataPool:MemoryPool;
	public var renderTextureDataPool:MemoryPool;
	public var renderTextureDrawDataPool:MemoryPool;
	public var messageDataPool:MemoryPool;
	
	public function new(memory:ByteArray=null) 
	{
		vertexDataPool = CreatePool(VertexData.BUFFER_SIZE * VertexData.BYTES_PER_ITEM);
		indicesDataPool = CreatePool(IndicesData.BUFFER_SIZE * IndicesData.BYTES_PER_ITEM);
		batchDataPool = CreatePool(BatchData.BUFFER_SIZE * BatchData.BYTES_PER_ITEM);
		conductorDataPool = CreatePool(ConductorData.BUFFER_SIZE);
		displayDataPool = CreatePool(DisplayData.BUFFER_SIZE * DisplayData.BYTES_PER_ITEM);
		textureDataPool = CreatePool(TextureData.BUFFER_SIZE * TextureData.BYTES_PER_ITEM);
		//atlasVertexDataPool = CreatePool(VertexData.BUFFER_SIZE * VertexData.BYTES_PER_ITEM);
		renderTextureDataPool = CreatePool(RenderTextureData.BUFFER_SIZE * RenderTextureData.BYTES_PER_ITEM);
		renderTextureDrawDataPool = CreatePool(RenderTextureDrawData.BUFFER_SIZE * RenderTextureDrawData.BYTES_PER_ITEM);
		messageDataPool = CreatePool(MessageManager.BUFFER_SIZE);
		
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
			SharedMemory.memory = new ByteArray();
		}
		else {
			SharedMemory.memory = memory;
		}
		
		//Messenger.init(messageDataPool);
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
		
		#if flash
			//memory.shareable = true;
			if (WorkerInfo.isMainThread) {
				Reflect.setProperty(memory, "shareable", true);
			}
		#end
		
		memory.position = 0;
		memory.endian = Endian.LITTLE_ENDIAN;
		Memory.select(memory);
		return memory;
	}
}