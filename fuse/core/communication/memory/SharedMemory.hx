package fuse.core.communication.memory;

import fuse.info.WorkerInfo;
import fuse.core.communication.data.MemoryPool;
import fuse.core.communication.data.batchData.WorkerBatchData;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.data.displayData.WorkerDisplayData;
import fuse.core.communication.data.rangeData.WorkerRangeData;
import fuse.core.communication.data.renderTextureData.RenderTextureData;
import fuse.core.communication.data.renderTextureData.RenderTextureDrawData;
import fuse.core.communication.data.textureData.WorkerTextureData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.core.messenger.MessageManager;
import fuse.core.communication.memory.Memory;
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
	public var batchDataPool:MemoryPool;
	public var vertexRangePool:MemoryPool;
	public var conductorDataPool:MemoryPool;
	public var displayDataPool:MemoryPool;
	public var textureDataPool:MemoryPool;
	public var renderTextureDataPool:MemoryPool;
	public var renderTextureDrawDataPool:MemoryPool;
	public var messageDataPool:MemoryPool;
	
	public function new(memory:ByteArray=null) 
	{
		vertexDataPool = CreatePool(VertexData.BUFFER_SIZE * VertexData.BYTES_PER_ITEM);
		batchDataPool = CreatePool(WorkerBatchData.BUFFER_SIZE * WorkerBatchData.BYTES_PER_ITEM);
		vertexRangePool = CreatePool(WorkerRangeData.BUFFER_SIZE * WorkerRangeData.BYTES_PER_ITEM);
		conductorDataPool = CreatePool(WorkerConductorData.BUFFER_SIZE);
		displayDataPool = CreatePool(WorkerDisplayData.BUFFER_SIZE * WorkerDisplayData.BYTES_PER_ITEM);
		textureDataPool = CreatePool(WorkerTextureData.BUFFER_SIZE * WorkerTextureData.BYTES_PER_ITEM);
		renderTextureDataPool = CreatePool(RenderTextureData.BUFFER_SIZE * RenderTextureData.BYTES_PER_ITEM);
		renderTextureDrawDataPool = CreatePool(RenderTextureDrawData.BUFFER_SIZE * RenderTextureDrawData.BYTES_PER_ITEM);
		messageDataPool = CreatePool(MessageManager.BUFFER_SIZE);
		
		if (memory == null) {
			SharedMemory.memory = new ByteArrayData();
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
		memory.position = 0;
		memory.endian = Endian.LITTLE_ENDIAN;
		#if air
			//memory.shareable = true;
			if (WorkerInfo.isMainThread) {
				Reflect.setProperty(memory, "shareable", true);
			}
			//if (WorkerInfo.usingWorkers || WorkerInfo.isWorkerThread) {
				//Memory.select(memory);
			//}
		#end
		
		Memory.select(memory);
		
		return memory;
	}
}