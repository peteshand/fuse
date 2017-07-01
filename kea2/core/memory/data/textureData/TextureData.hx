package kea2.core.memory.data.textureData;
import kea2.core.atlas.packer.AtlasPartition;
import kea2.utils.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class TextureData
{
	public static var BUFFER_SIZE:Int = 10000;
	public static inline var BYTES_PER_ITEM:Int = 44;
	
	public static inline var INDEX_X:Int = 0;
	public static inline var INDEX_Y:Int = 4;
	public static inline var INDEX_WIDTH:Int = 8;
	public static inline var INDEX_HEIGHT:Int = 12;
	public static inline var INDEX_P2_WIDTH:Int = 16;
	public static inline var INDEX_P2_HEIGHT:Int = 20;
	
	public static inline var INDEX_ATLAS_X:Int = 24;
	public static inline var INDEX_ATLAS_Y:Int = 28;
	public static inline var INDEX_ATLAS_WIDTH:Int = 32;
	public static inline var INDEX_ATLAS_HEIGHT:Int = 36;
	public static inline var INDEX_ATLAS_INDEX:Int = 40;
	
	public var memoryBlock:MemoryBlock;
	public var textureId:Int;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var p2Width(get, set):Float;
	public var p2Height(get, set):Float;
	
	public var area(get, null):Float;
	public var placed:Bool = false;
	public var partition = new Notifier<AtlasPartition>();
	
	public var atlasX(get, set):Float;
	public var atlasY(get, set):Float;
	public var atlasWidth(get, set):Float;
	public var atlasHeight(get, set):Float;
	public var atlasIndex(get, set):Int;
	
	public function new(objectOffset:Int) 
	{
		this.textureId = objectOffset;
		memoryBlock = Kea.current.keaMemory.textureDataPool.createMemoryBlock(TextureData.BYTES_PER_ITEM, objectOffset);
	}
	
	inline function get_x():Float { 
		return memoryBlock.readFloat(INDEX_X);
	}
	
	inline function get_y():Float { 
		return memoryBlock.readFloat(INDEX_Y);
	}
	
	inline function get_width():Float { 
		return memoryBlock.readFloat(INDEX_WIDTH);
	}
	
	inline function get_height():Float { 
		return memoryBlock.readFloat(INDEX_HEIGHT);
	}
	
	inline function get_p2Width():Float { 
		return memoryBlock.readFloat(INDEX_P2_WIDTH);
	}
	
	inline function get_p2Height():Float { 
		return memoryBlock.readFloat(INDEX_P2_HEIGHT);
	}
	
	inline function get_atlasX():Float { 
		return memoryBlock.readFloat(INDEX_ATLAS_X);
	}
	
	inline function get_atlasY():Float { 
		return memoryBlock.readFloat(INDEX_ATLAS_Y);
	}
	
	inline function get_atlasWidth():Float { 
		return memoryBlock.readFloat(INDEX_ATLAS_WIDTH);
	}
	
	inline function get_atlasHeight():Float { 
		return memoryBlock.readFloat(INDEX_ATLAS_HEIGHT);
	}
	
	inline function get_atlasIndex():Int { 
		return memoryBlock.readInt(INDEX_ATLAS_INDEX);
	}
	
	
	
	
	inline function set_x(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_X, value);
		return value;
	}
	
	inline function set_y(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_Y, value);
		return value;
	}
	
	inline function set_width(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_WIDTH, value);
		return value;
	}
	
	inline function set_height(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_HEIGHT, value);
		return value;
	}
	
	inline function set_p2Width(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_P2_WIDTH, value);
		return value;
	}
	
	inline function set_p2Height(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_P2_HEIGHT, value);
		return value;
	}
	
	inline function set_atlasX(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_ATLAS_X, value);
		return value;
	}
	
	inline function set_atlasY(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_ATLAS_Y, value);
		return value;
	}
	
	inline function set_atlasWidth(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_ATLAS_WIDTH, value);
		return value;
	}
	
	inline function set_atlasHeight(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_ATLAS_HEIGHT, value);
		return value;
	}
	
	inline function set_atlasIndex(value:Int):Int { 
		memoryBlock.writeInt(INDEX_ATLAS_INDEX, value);
		return value;
	}
	
	
	function get_area():Float 
	{
		return this.width * this.height;
	}
}