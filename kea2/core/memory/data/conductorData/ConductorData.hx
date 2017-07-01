package kea2.core.memory.data.conductorData;
import kea2.core.memory.data.MemoryBlock;

/**
 * ...
 * @author P.J.Shand
 */
class ConductorData
{
	public static var BUFFER_SIZE:Int = 20;
	
	static public inline var FRAME_INDEX:Int = 0;
	static public inline var PROCESS_INDEX:Int = 4;
	static public inline var NUMBER_OF_BATCHES:Int = 8;
	static public inline var NUMBER_OF_RENDERABLES:Int = 12;
	static public inline var BUSY:Int = 16;
	static public inline var RENDER_TEXTURE_PROCESS_INDEX:Int = 20;
	static public inline var RENDER_TEXTURE_COUNT_INDEX:Int = 24;
	
	public static var memoryBlock:MemoryBlock;
	
	@:isVar public var frameIndex(get, set):Int = 0;
	@:isVar public var processIndex(get, set):Int = 0;
	@:isVar public var numberOfBatches(get, set):Int = 0;
	@:isVar public var numberOfRenderables(get, set):Int = 0;
	@:isVar public var busy(get, set):Int = 0;
	@:isVar public var renderTextureProcessIndex(get, set):Int = 0;
	@:isVar public var renderTextureCountIndex(get, set):Int = 0;
	
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
	
}