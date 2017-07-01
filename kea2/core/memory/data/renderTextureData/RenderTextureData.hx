package kea2.core.memory.data.renderTextureData;
import kea2.core.memory.data.displayData.DisplayData;

/**
 * ...
 * @author P.J.Shand
 */
class RenderTextureData
{
	public static var BUFFER_SIZE:Int = 10000;
	public static inline var BYTES_PER_ITEM:Int = 4;
	
	public static inline var INDEX_CLEAR:Int = 0;
	
	public var clear(get, set):Bool;
	
	var memoryBlock:MemoryBlock;
	
	public function new(objectOffset:Int) 
	{
		memoryBlock = Kea.current.keaMemory.renderTextureDataPool.createMemoryBlock(RenderTextureDrawData.BYTES_PER_ITEM, objectOffset);
	}
	
	///////////////////////////////////////////////////////////////
	
	inline function get_clear():Bool { 
		if (memoryBlock.readInt(INDEX_CLEAR) == 1) return true;
		return false;
	}
	
	///////////////////////////////////////////////////////////////
	
	inline function set_clear(value:Bool):Bool { 
		if (value == true) memoryBlock.writeInt(INDEX_CLEAR, 1);
		else memoryBlock.writeInt(INDEX_CLEAR, 0);
		return value;
	}
}