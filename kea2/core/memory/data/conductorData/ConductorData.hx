package kea2.core.memory.data.conductorData;
import kea2.core.memory.data.MemoryBlock;

/**
 * ...
 * @author P.J.Shand
 */
class ConductorData
{
	public static var BUFFER_SIZE:Int = 56;
	
	static public inline var FRAME_INDEX:Int = 0;
	static public inline var PROCESS_INDEX:Int = 4;
	static public inline var NUMBER_OF_BATCHES:Int = 8;
	static public inline var NUMBER_OF_RENDERABLES:Int = 12;
	static public inline var BUSY:Int = 16;
	static public inline var RENDER_TEXTURE_PROCESS_INDEX:Int = 20;
	static public inline var RENDER_TEXTURE_COUNT_INDEX:Int = 24;
	static public inline var ATLAS_TEXTURE_ID_1:Int = 28;
	static public inline var ATLAS_TEXTURE_ID_2:Int = 32;
	static public inline var ATLAS_TEXTURE_ID_3:Int = 36;
	static public inline var ATLAS_TEXTURE_ID_4:Int = 40;
	static public inline var ATLAS_TEXTURE_ID_5:Int = 44;
	static public inline var STAGE_WIDTH:Int = 48;
	static public inline var STAGE_HEIGHT:Int = 52;
	
	public static var memoryBlock:MemoryBlock;
	
	@:isVar public var frameIndex(get, set):Int = 0;
	@:isVar public var processIndex(get, set):Int = 0;
	@:isVar public var numberOfBatches(get, set):Int = 0;
	@:isVar public var numberOfRenderables(get, set):Int = 0;
	@:isVar public var busy(get, set):Int = 0;
	@:isVar public var renderTextureProcessIndex(get, set):Int = 0;
	@:isVar public var renderTextureCountIndex(get, set):Int = 0;
	
	@:isVar public var atlasTextureId1(get, set):Int = 0;
	@:isVar public var atlasTextureId2(get, set):Int = 0;
	@:isVar public var atlasTextureId3(get, set):Int = 0;
	@:isVar public var atlasTextureId4(get, set):Int = 0;
	@:isVar public var atlasTextureId5(get, set):Int = 0;
	@:isVar public var stageWidth(get, set):Int = 0;
	@:isVar public var stageHeight(get, set):Int = 0;
	
	public function new() 
	{
		if (memoryBlock == null) {
			memoryBlock = Kea.current.keaMemory.conductorDataPool.createMemoryBlock(ConductorData.BUFFER_SIZE, 0);
		}
	}
	
	inline function get_frameIndex():Int				{ return memoryBlock.readInt(FRAME_INDEX); }
	inline function get_processIndex():Int				{ return memoryBlock.readInt(PROCESS_INDEX); }
	inline function get_numberOfBatches():Int			{ return memoryBlock.readInt(NUMBER_OF_BATCHES); }
	inline function get_numberOfRenderables():Int		{ return memoryBlock.readInt(NUMBER_OF_RENDERABLES); }
	inline function get_busy():Int						{ return memoryBlock.readInt(BUSY); }
	inline function get_renderTextureProcessIndex():Int	{ return memoryBlock.readInt(RENDER_TEXTURE_PROCESS_INDEX); }
	inline function get_renderTextureCountIndex():Int	{ return memoryBlock.readInt(RENDER_TEXTURE_COUNT_INDEX); }
	inline function get_atlasTextureId1():Int			{ return memoryBlock.readInt(ATLAS_TEXTURE_ID_1); }
	inline function get_atlasTextureId2():Int			{ return memoryBlock.readInt(ATLAS_TEXTURE_ID_2); }
	inline function get_atlasTextureId3():Int			{ return memoryBlock.readInt(ATLAS_TEXTURE_ID_3); }
	inline function get_atlasTextureId4():Int			{ return memoryBlock.readInt(ATLAS_TEXTURE_ID_4); }
	inline function get_atlasTextureId5():Int			{ return memoryBlock.readInt(ATLAS_TEXTURE_ID_5); }
	inline function get_stageWidth():Int				{ return memoryBlock.readInt(STAGE_WIDTH); }
	inline function get_stageHeight():Int				{ return memoryBlock.readInt(STAGE_HEIGHT); }
	
	
	inline function set_frameIndex(value:Int):Int {
		memoryBlock.writeInt(FRAME_INDEX, value);
		return value;
	}
	
	inline function set_processIndex(value:Int):Int {
		memoryBlock.writeInt(PROCESS_INDEX, value);
		return value;
	}
	
	inline function set_numberOfBatches(value:Int):Int {
		memoryBlock.writeInt(NUMBER_OF_BATCHES, value);
		return value;
	}
	
	inline function set_numberOfRenderables(value:Int):Int {
		memoryBlock.writeInt(NUMBER_OF_RENDERABLES, value);
		return value;
	}
	
	inline function set_busy(value:Int):Int {
		memoryBlock.writeInt(BUSY, value);
		return value;
	}
	
	inline function set_renderTextureProcessIndex(value:Int):Int {
		memoryBlock.writeInt(RENDER_TEXTURE_PROCESS_INDEX, value);
		return value;
	}
	
	inline function set_renderTextureCountIndex(value:Int):Int {
		memoryBlock.writeInt(RENDER_TEXTURE_COUNT_INDEX, value);
		return value;
	}
	
	inline function set_atlasTextureId1(value:Int):Int {
		memoryBlock.writeInt(ATLAS_TEXTURE_ID_1, value);
		return value;
	}
	
	inline function set_atlasTextureId2(value:Int):Int {
		memoryBlock.writeInt(ATLAS_TEXTURE_ID_2, value);
		return value;
	}
	
	inline function set_atlasTextureId3(value:Int):Int {
		memoryBlock.writeInt(ATLAS_TEXTURE_ID_3, value);
		return value;
	}
	
	inline function set_atlasTextureId4(value:Int):Int {
		memoryBlock.writeInt(ATLAS_TEXTURE_ID_4, value);
		return value;
	}
	
	inline function set_atlasTextureId5(value:Int):Int {
		memoryBlock.writeInt(ATLAS_TEXTURE_ID_5, value);
		return value;
	}
	
	inline function set_stageWidth(value:Int):Int {
		memoryBlock.writeInt(STAGE_WIDTH, value);
		return value;
	}
	
	inline function set_stageHeight(value:Int):Int {
		memoryBlock.writeInt(STAGE_HEIGHT, value);
		return value;
	}
	
}