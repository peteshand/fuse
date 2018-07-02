package fuse.core.communication.data.rangeData;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerRangeData implements IRangeData
{
	static public inline var START_POS:Int = 0;
	static public inline var LENGTH_POS:Int = 2;
	
	public static inline var BYTES_PER_ITEM:Int = 4;
	public static inline var BUFFER_SIZE:Int = 10000;
	
	public var memoryBlock:MemoryBlock;
	var objectId:Int;
	
	@:isVar public var start(get, set):Int;
	@:isVar public var length(get, set):Int;
	
	public function new(objectId:Int) 
	{
		this.objectId = objectId;
		memoryBlock = Fuse.current.sharedMemory.vertexRangePool.createMemoryBlock(WorkerRangeData.BYTES_PER_ITEM, objectId);
	}
	
	function get_start():Int	{ return memoryBlock.readInt16(START_POS); }
	function get_length():Int	{ return memoryBlock.readInt16(LENGTH_POS); }
	
	function set_start(value:Int):Int {
		memoryBlock.writeInt16(START_POS, value);
		return value;
	}
	
	function set_length(value:Int):Int {
		memoryBlock.writeInt16(LENGTH_POS, value);
		return value;
	}
}