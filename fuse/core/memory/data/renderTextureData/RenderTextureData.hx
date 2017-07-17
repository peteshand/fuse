package fuse.core.memory.data.renderTextureData;
import fuse.Kea;
import fuse.core.memory.data.MemoryBlock;
import fuse.core.memory.data.displayData.DisplayData;

/**
 * ...
 * @author P.J.Shand
 */
class RenderTextureData implements IRenderTextureData
{
	public static var BUFFER_SIZE:Int = 10000;
	
	public static inline var INDEX_CLEAR:Int = 0;
	public static inline var BYTES_PER_ITEM:Int = 2;
	
	public var clear(get, set):Bool;
	
	var memoryBlock:MemoryBlock;
	
	public function new(objectOffset:Int) 
	{
		memoryBlock = Kea.current.keaMemory.renderTextureDataPool.createMemoryBlock(RenderTextureDrawData.BYTES_PER_ITEM, objectOffset);
	}
	
	///////////////////////////////////////////////////////////////
	
	inline function get_clear():Bool { 
		if (memoryBlock.readInt16(INDEX_CLEAR) == 1) return true;
		return false;
	}
	
	///////////////////////////////////////////////////////////////
	
	inline function set_clear(value:Bool):Bool { 
		if (value == true) memoryBlock.writeInt16(INDEX_CLEAR, 1);
		else memoryBlock.writeInt16(INDEX_CLEAR, 0);
		return value;
	}
}