package kea2.core.memory.data.renderTextureData;
import kea2.core.memory.data.displayData.DisplayData;
import openfl.Memory;

/**
 * ...
 * @author P.J.Shand
 */
class RenderTextureDrawData
{
	public static var BUFFER_SIZE:Int = 10000;
	public static inline var BYTES_PER_ITEM:Int = 8;
	
	@:isVar public static var OBJECT_POSITION(get, set):Int = 0;
	static var _basePosition:Int = 0;
	public static var basePosition(get, null):Int = 0;
	
	public static inline var INDEX_RENDER_TEXTURE_ID:Int = 0;
	public static inline var INDEX_DISPLAY_OBJECT_ID:Int = 4;
	
	public var renderTextureId(get, set):Int;
	public var displayObjectId(get, set):Int;
	
	//var memoryBlock:MemoryBlock;
	
	public function new(objectOffset:Int) 
	{
		//memoryBlock = Kea.current.keaMemory.renderTextureDrawDataPool.createMemoryBlock(RenderTextureDrawData.BYTES_PER_ITEM, objectOffset);
	}
	
	///////////////////////////////////////////////////////////////
	
	inline function get_renderTextureId():Int { 
		return readInt(INDEX_RENDER_TEXTURE_ID);
	}
	
	inline function get_displayObjectId():Int { 
		return readInt(INDEX_DISPLAY_OBJECT_ID);
	}
	
	///////////////////////////////////////////////////////////////
	
	inline function set_renderTextureId(value:Int):Int { 
		writeInt(INDEX_RENDER_TEXTURE_ID, value);
		return value;
	}
	
	inline function set_displayObjectId(value:Int):Int { 
		writeInt(INDEX_DISPLAY_OBJECT_ID, value);
		return value;
	}
	
	inline function readInt(offset:Int):Int
	{
		return Memory.getI32(RenderTextureDrawData.basePosition + offset);
	}
	
	inline function writeInt(offset:Int, value:Int):Void
	{
		Memory.setI32(RenderTextureDrawData.basePosition + offset, value);
	}
	
	static inline function get_OBJECT_POSITION():Int 
	{
		return RenderTextureDrawData.OBJECT_POSITION;
	}
	
	static inline function set_OBJECT_POSITION(value:Int):Int 
	{
		RenderTextureDrawData.OBJECT_POSITION = value;
		RenderTextureDrawData._basePosition = Kea.current.keaMemory.renderTextureDrawDataPool.start + (RenderTextureDrawData.OBJECT_POSITION * RenderTextureDrawData.BYTES_PER_ITEM);
		return value;
	}
	
	static inline function get_basePosition():Int 
	{
		return _basePosition;
	}
}