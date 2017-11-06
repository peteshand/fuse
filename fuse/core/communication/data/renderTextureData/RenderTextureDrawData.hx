package fuse.core.communication.data.renderTextureData;

import fuse.Fuse;
import openfl.Memory;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
class RenderTextureDrawData implements IRenderTextureDrawData
{
	public static var BUFFER_SIZE:Int = 10000;
	
	@:isVar public static var OBJECT_POSITION(get, set):Int = 0;
	static var _basePosition:Int = 0;
	public static var basePosition(get, null):Int = 0;
	
	public static inline var INDEX_RENDER_TEXTURE_ID:Int = 0;
	public static inline var INDEX_DISPLAY_OBJECT_ID:Int = 2;
	public static inline var BYTES_PER_ITEM:Int = 4;
	
	public var renderTextureId(get, set):Int;
	public var displayObjectId(get, set):Int;
	
	//var memoryBlock:MemoryBlock;
	
	public function new(objectOffset:Int) 
	{
		//memoryBlock = Kea.current.sharedMemory.renderTextureDrawDataPool.createMemoryBlock(RenderTextureDrawData.BYTES_PER_ITEM, objectOffset);
	}
	
	///////////////////////////////////////////////////////////////
	
	inline function get_renderTextureId():Int { 
		return readInt16(INDEX_RENDER_TEXTURE_ID);
	}
	
	inline function get_displayObjectId():Int { 
		return readInt16(INDEX_DISPLAY_OBJECT_ID);
	}
	
	///////////////////////////////////////////////////////////////
	
	inline function set_renderTextureId(value:Int):Int { 
		writeInt16(INDEX_RENDER_TEXTURE_ID, value);
		return value;
	}
	
	inline function set_displayObjectId(value:Int):Int { 
		writeInt16(INDEX_DISPLAY_OBJECT_ID, value);
		return value;
	}
	
	inline function readInt16(offset:Int):Int
	{
		return Memory.getUI16(RenderTextureDrawData.basePosition + offset);
	}
	
	inline function writeInt16(offset:Int, value:Int):Void
	{
		Memory.setI16(RenderTextureDrawData.basePosition + offset, value);
	}
	
	static inline function get_OBJECT_POSITION():Int 
	{
		return RenderTextureDrawData.OBJECT_POSITION;
	}
	
	static inline function set_OBJECT_POSITION(value:Int):Int 
	{
		RenderTextureDrawData.OBJECT_POSITION = value;
		RenderTextureDrawData._basePosition = Fuse.current.sharedMemory.renderTextureDrawDataPool.start + (RenderTextureDrawData.OBJECT_POSITION * RenderTextureDrawData.BYTES_PER_ITEM);
		return value;
	}
	
	static inline function get_basePosition():Int 
	{
		return _basePosition;
	}
}