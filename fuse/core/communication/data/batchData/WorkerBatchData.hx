package fuse.core.communication.data.batchData;
import fuse.Fuse;
import fuse.core.communication.data.MemoryBlock;

/**
 * ...
 * @author P.J.Shand
 */

class WorkerBatchData implements IBatchData
{
	static public inline var RENDER_TARGET_ID:Int = 0;
	static public inline var CLEAR_RENDER_TARGET:Int = 4;
	static public inline var START_INDEX:Int = 6;
	static public inline var LENGTH_INDEX:Int = 8;
	
	static public inline var BLEND_MODE_INDEX:Int = 10;
	static public inline var TEXTURE_ID1:Int = 12;
	static public inline var TEXTURE_ID2:Int = 14;
	static public inline var TEXTURE_ID3:Int = 16;
	static public inline var TEXTURE_ID4:Int = 18;
	static public inline var TEXTURE_ID5:Int = 20;
	static public inline var TEXTURE_ID6:Int = 22;
	static public inline var TEXTURE_ID7:Int = 24;
	static public inline var TEXTURE_ID8:Int = 26;
	static public inline var NUM_TEXTURES:Int = 28;
	static public inline var NUM_ITEMS:Int = 30;
	static public inline var WIDTH:Int = 32;
	static public inline var HEIGHT:Int = 34;
	static public inline var SKIP:Int = 36;
	
	public static inline var BYTES_PER_ITEM:Int = 38;
	public static inline var BUFFER_SIZE:Int = 10000;
	
	public var memoryBlock:MemoryBlock;
	
	var objectId:Int;
	
	@:isVar public var renderTargetId(get, set):Int;
	@:isVar public var clearRenderTarget(get, set):Int;
	@:isVar public var startIndex(get, set):Int;
	@:isVar public var length(get, set):Int;
	@:isVar public var blendMode(get, set):Int;
	
	@:isVar public var textureIds(get, null):Array<Int>;
	@:isVar public var textureId1(get, set):Int;
	@:isVar public var textureId2(get, set):Int;
	@:isVar public var textureId3(get, set):Int;
	@:isVar public var textureId4(get, set):Int;
	@:isVar public var textureId5(get, set):Int;
	@:isVar public var textureId6(get, set):Int;
	@:isVar public var textureId7(get, set):Int;
	@:isVar public var textureId8(get, set):Int;
	@:isVar public var numTextures(get, set):Int;
	@:isVar public var numItems(get, set):Int;
	@:isVar public var width(get, set):Int;
	@:isVar public var height(get, set):Int;
	@:isVar public var skip(get, set):Int = 0;
	var _textureIds:Array<Int> = [];
	
	public function new(objectId:Int) 
	{
		this.objectId = objectId;
		memoryBlock = Fuse.current.sharedMemory.batchDataPool.createMemoryBlock(WorkerBatchData.BYTES_PER_ITEM, objectId);
	}
	
	function get_renderTargetId():Int	{ return memoryBlock.readInt(RENDER_TARGET_ID); }
	function get_clearRenderTarget():Int	{ return memoryBlock.readInt16(CLEAR_RENDER_TARGET); }
	function get_startIndex():Int		{ return memoryBlock.readInt16(START_INDEX); }
	
	function get_blendMode():Int		{ return memoryBlock.readInt16(BLEND_MODE_INDEX); }
	function get_length():Int			{ return memoryBlock.readInt16(LENGTH_INDEX); }
	function get_textureId1():Int		{ return memoryBlock.readInt16(TEXTURE_ID1); }
	function get_textureId2():Int		{ return memoryBlock.readInt16(TEXTURE_ID2); }
	function get_textureId3():Int		{ return memoryBlock.readInt16(TEXTURE_ID3); }
	function get_textureId4():Int		{ return memoryBlock.readInt16(TEXTURE_ID4); }
	function get_textureId5():Int		{ return memoryBlock.readInt16(TEXTURE_ID5); }
	function get_textureId6():Int		{ return memoryBlock.readInt16(TEXTURE_ID6); }
	function get_textureId7():Int		{ return memoryBlock.readInt16(TEXTURE_ID7); }
	function get_textureId8():Int		{ return memoryBlock.readInt16(TEXTURE_ID8); }
	function get_numTextures():Int		{ return memoryBlock.readInt16(NUM_TEXTURES); }
	function get_numItems():Int			{ return memoryBlock.readInt16(NUM_ITEMS); }
	function get_width():Int			{ return memoryBlock.readInt16(WIDTH); }
	function get_height():Int			{ return memoryBlock.readInt16(HEIGHT); }
	function get_skip():Int				{ return memoryBlock.readInt16(SKIP); }
	
	
	function set_renderTargetId(value:Int):Int {
		memoryBlock.writeInt(RENDER_TARGET_ID, value);
		return value;
	}
	
	function set_clearRenderTarget(value:Int):Int {
		memoryBlock.writeInt16(CLEAR_RENDER_TARGET, value);
		return value;
	}
	
	function get_textureIds():Array<Int>
	{
		_textureIds[0] = textureId1;
		_textureIds[1] = textureId2;
		_textureIds[2] = textureId3;
		_textureIds[3] = textureId4;
		_textureIds[4] = textureId5;
		_textureIds[5] = textureId6;
		_textureIds[6] = textureId7;
		_textureIds[7] = textureId8;
		return _textureIds;
	}
	
	function set_startIndex(value:Int):Int {
		memoryBlock.writeInt16(START_INDEX, value);
		return value;
	}
	
	function set_length(value:Int):Int {
		memoryBlock.writeInt16(LENGTH_INDEX, value);
		return value;
	}
	
	function set_blendMode(value:Int):Int {
		memoryBlock.writeInt16(BLEND_MODE_INDEX, value);
		return value;
	}
	
	function set_textureId1(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_ID1, value);
		return value;
	}
	
	function set_textureId2(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_ID2, value);
		return value;
	}
	
	function set_textureId3(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_ID3, value);
		return value;
	}
	
	function set_textureId4(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_ID4, value);
		return value;
	}
	
	function set_textureId5(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_ID5, value);
		return value;
	}
	
	function set_textureId6(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_ID6, value);
		return value;
	}
	
	function set_textureId7(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_ID7, value);
		return value;
	}
	
	function set_textureId8(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_ID8, value);
		return value;
	}
	
	function set_numTextures(value:Int):Int {
		memoryBlock.writeInt16(NUM_TEXTURES, value);
		return value;
	}
	
	function set_numItems(value:Int):Int {
		memoryBlock.writeInt16(NUM_ITEMS, value);
		return value;
	}
	
	function set_width(value:Int):Int {
		memoryBlock.writeInt16(WIDTH, value);
		return value;
	}
	
	function set_height(value:Int):Int {
		memoryBlock.writeInt16(HEIGHT, value);
		return value;
	}
	
	function set_skip(value:Int):Int {
		memoryBlock.writeInt16(SKIP, value);
		return value;
	}
}