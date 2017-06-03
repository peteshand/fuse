package kea2.core.memory.data.batchData;

/**
 * ...
 * @author P.J.Shand
 */
class BatchData
{
	public static var BUFFER_SIZE:Int = 120000;
	public static inline var BYTES_PER_ITEM:Int = 24;
	
	static public inline var START_INDEX:Int = 0;
	static public inline var LENGTH_INDEX:Int = 4;
	static public inline var TEXTURE_ID1:Int = 8;
	static public inline var TEXTURE_ID2:Int = 12;
	static public inline var TEXTURE_ID3:Int = 16;
	static public inline var TEXTURE_ID4:Int = 20;
	
	public var memoryBlock:MemoryBlock;
	
	/*var _startIndex:Int;
	var _textureId:Int;
	var _length:Int;*/
	
	@:isVar public var startIndex(get, set):Int;
	@:isVar public var length(get, set):Int;
	@:isVar public var textureId1(get, set):Int;
	@:isVar public var textureId2(get, set):Int;
	@:isVar public var textureId3(get, set):Int;
	@:isVar public var textureId4(get, set):Int;
	
	public function new(objectId:Int) 
	{
		memoryBlock = Kea.current.keaMemory.batchDataPool.createMemoryBlock(BatchData.BYTES_PER_ITEM, objectId);
	}
	
	function get_startIndex():Int 
	{
		return memoryBlock.readInt(START_INDEX);
	}
	
	function set_startIndex(value:Int):Int 
	{
		memoryBlock.writeInt(START_INDEX, value);
		return value;
	}
	
	function get_length():Int 
	{
		return memoryBlock.readInt(LENGTH_INDEX);
	}
	
	function set_length(value:Int):Int 
	{
		memoryBlock.writeInt(LENGTH_INDEX, value);
		return value;
	}
	
	function get_textureId1():Int 
	{
		return memoryBlock.readInt(TEXTURE_ID1);
	}
	
	function set_textureId1(value:Int):Int 
	{
		memoryBlock.writeInt(TEXTURE_ID1, value);
		return value;
	}
	
	function get_textureId2():Int 
	{
		return memoryBlock.readInt(TEXTURE_ID2);
	}
	
	function set_textureId2(value:Int):Int 
	{
		memoryBlock.writeInt(TEXTURE_ID2, value);
		return value;
	}
	
	function get_textureId3():Int 
	{
		return memoryBlock.readInt(TEXTURE_ID3);
	}
	
	function set_textureId3(value:Int):Int 
	{
		memoryBlock.writeInt(TEXTURE_ID3, value);
		return value;
	}
	
	function get_textureId4():Int 
	{
		return memoryBlock.readInt(TEXTURE_ID4);
	}
	
	function set_textureId4(value:Int):Int 
	{
		memoryBlock.writeInt(TEXTURE_ID4, value);
		return value;
	}
}