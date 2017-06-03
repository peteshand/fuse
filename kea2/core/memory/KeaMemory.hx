package kea2.core.memory;

import kea2.core.memory.data.MemoryPool;
import kea2.core.memory.data.batchData.BatchData;
import kea2.core.memory.data.conductorData.ConductorData;
import kea2.core.memory.data.displayData.DisplayData;
import kea2.core.memory.data.vertexData.VertexData;

import openfl.Memory;
import openfl.utils.ByteArray;
import openfl.utils.Endian;

/**
 * ...
 * @author P.J.Shand
 */
class KeaMemory
{
	static var memorySize:Int;
	@:isVar public static var memory(get, set):ByteArray;
	
	public var batchDataPool:MemoryPool;
	public var conductorDataPool:MemoryPool;
	public var displayDataPool:MemoryPool;
	public var vertexDataPool:MemoryPool;
	
	public function new(memory:ByteArray=null) 
	{
		batchDataPool = new MemoryPool(BatchData.BUFFER_SIZE);
		conductorDataPool = new MemoryPool(ConductorData.BUFFER_SIZE);
		displayDataPool = new MemoryPool(DisplayData.BUFFER_SIZE * DisplayData.BYTES_PER_ITEM);
		vertexDataPool = new MemoryPool(VertexData.BUFFER_SIZE * VertexData.BYTES_PER_ITEM);
		
		trace("batchDataPool.start     = " + batchDataPool.start);
		trace("batchDataPool.end       = " + batchDataPool.end);
		
		trace("conductorDataPool.start = " + conductorDataPool.start);
		trace("conductorDataPool.end   = " + conductorDataPool.end);
		
		trace("displayDataPool.start   = " + displayDataPool.start);
		trace("displayDataPool.end     = " + displayDataPool.end);
		
		trace("vertexDataPool.start    = " + vertexDataPool.start);
		trace("vertexDataPool.end      = " + vertexDataPool.end);
		
		memorySize = conductorDataPool.size + displayDataPool.size + vertexDataPool.size;
		
		if (memory == null) {
			KeaMemory.memory = new ByteArray();
		}
		else {
			KeaMemory.memory = memory;
		}
		
		
	}
	
	static function get_memory():ByteArray 
	{
		return memory;
	}
	
	static function set_memory(value:ByteArray):ByteArray 
	{
		memory = value;
		trace("memorySize = " + memorySize);
		memory.length = memorySize + memorySize;
		memory.shareable = true;
		memory.position = 0;
		memory.endian = Endian.LITTLE_ENDIAN;
		Memory.select(memory);
		return memory;
	}
}