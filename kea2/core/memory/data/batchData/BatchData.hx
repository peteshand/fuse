package kea2.core.memory.data.batchData;

/**
 * ...
 * @author P.J.Shand
 */
class BatchData
{
	static public inline var START_INDEX:Int = 0;
	static public inline var LENGTH_INDEX:Int = 4;
	static public inline var TEXTURE_ID1:Int = 8;
	static public inline var TEXTURE_ID2:Int = 12;
	static public inline var TEXTURE_ID3:Int = 16;
	static public inline var TEXTURE_ID4:Int = 20;
	static public inline var RENDER_TARGET_ID:Int = 24;
	static public inline var NUM_TEXTURES:Int = 28;
	static public inline var NUM_ITEMS:Int = 32;
	static public inline var WIDTH:Int = 36;
	static public inline var HEIGHT:Int = 40;
	
	public static inline var BYTES_PER_ITEM:Int = 44;
	var objectId:Int;
	public static var BUFFER_SIZE:Int = 120000;
	
	public var memoryBlock:MemoryBlock;
	
	/*var _startIndex:Int;
	var _textureId:Int;
	var _length:Int;*/
	
	@:isVar public var startIndex(get, set):Int;
	@:isVar public var length(get, set):Int;
	@:isVar public var textureIds(get, null):Array<Int>;
	@:isVar public var textureId1(get, set):Int;
	@:isVar public var textureId2(get, set):Int;
	@:isVar public var textureId3(get, set):Int;
	@:isVar public var textureId4(get, set):Int;
	@:isVar public var renderTargetId(get, set):Int;
	@:isVar public var numTextures(get, set):Int;
	@:isVar public var numItems(get, set):Int;
	@:isVar public var width(get, set):Int;
	@:isVar public var height(get, set):Int;
	
	public var firstIndex(get, null):Int;
	
	public function new(objectId:Int) 
	{
		this.objectId = objectId;
		memoryBlock = Kea.current.keaMemory.batchDataPool.createMemoryBlock(BatchData.BYTES_PER_ITEM, objectId);
	}
	
	function get_startIndex():Int		{ return memoryBlock.readInt(START_INDEX); }
	function get_length():Int			{ return memoryBlock.readInt(LENGTH_INDEX); }
	function get_textureId1():Int		{ return memoryBlock.readInt(TEXTURE_ID1); }
	function get_textureId2():Int		{ return memoryBlock.readInt(TEXTURE_ID2); }
	function get_textureId3():Int		{ return memoryBlock.readInt(TEXTURE_ID3); }
	function get_textureId4():Int		{ return memoryBlock.readInt(TEXTURE_ID4); }
	function get_renderTargetId():Int	{ return memoryBlock.readInt(RENDER_TARGET_ID); }
	function get_numTextures():Int		{ return memoryBlock.readInt(NUM_TEXTURES); }
	function get_numItems():Int			{ return memoryBlock.readInt(NUM_ITEMS); }
	function get_width():Int			{ return memoryBlock.readInt(WIDTH); }
	function get_height():Int			{ return memoryBlock.readInt(HEIGHT); }
	
	function get_textureIds():Array<Int>
	{
		return [textureId1, textureId2, textureId3, textureId4];
	}
	
	function set_startIndex(value:Int):Int {
		memoryBlock.writeInt(START_INDEX, value);
		return value;
	}
	
	function set_length(value:Int):Int {
		memoryBlock.writeInt(LENGTH_INDEX, value);
		return value;
	}
	
	function set_textureId1(value:Int):Int {
		memoryBlock.writeInt(TEXTURE_ID1, value);
		return value;
	}
	
	function set_textureId2(value:Int):Int {
		memoryBlock.writeInt(TEXTURE_ID2, value);
		return value;
	}
	
	function set_textureId3(value:Int):Int {
		memoryBlock.writeInt(TEXTURE_ID3, value);
		return value;
	}
	
	function set_textureId4(value:Int):Int {
		memoryBlock.writeInt(TEXTURE_ID4, value);
		return value;
	}
	
	function set_renderTargetId(value:Int):Int {
		memoryBlock.writeInt(RENDER_TARGET_ID, value);
		return value;
	}
	
	function set_numTextures(value:Int):Int {
		memoryBlock.writeInt(NUM_TEXTURES, value);
		return value;
	}
	
	function set_numItems(value:Int):Int {
		memoryBlock.writeInt(NUM_ITEMS, value);
		return value;
	}
	
	function set_width(value:Int):Int {
		memoryBlock.writeInt(WIDTH, value);
		return value;
	}
	
	function set_height(value:Int):Int {
		memoryBlock.writeInt(HEIGHT, value);
		return value;
	}
	
	function get_firstIndex():Int 
	{
		return objectId;
	}
}