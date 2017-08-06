package fuse.core.communication.data.textureData;
import fuse.Fuse;
import fuse.core.communication.data.MemoryBlock;
import fuse.core.front.atlas.packer.AtlasPartition;
import fuse.utils.Notifier;

/**
 * ...
 * @author P.J.Shand
 */
class TextureData implements ITextureData
{
	public static var BUFFER_SIZE:Int = 10000;
	
	static inline var X:Int = 0;
	static inline var Y:Int = 2;
	static inline var WIDTH:Int = 4;
	static inline var HEIGHT:Int = 6;
	static inline var P2_WIDTH:Int = 8;
	static inline var P2_HEIGHT:Int = 10;
	
	static inline var BASE_X:Int = 12;
	static inline var BASE_Y:Int = 14;
	static inline var BASE_WIDTH:Int = 16;
	static inline var BASE_HEIGHT:Int = 18;
	static inline var BASE_P2_WIDTH:Int = 20;
	static inline var BASE_P2_HEIGHT:Int = 22;
	
	static inline var TEXTURE_AVAILABLE:Int = 24;
	
	/*static inline var ATLAS_X:Int = 52;
	static inline var ATLAS_Y:Int = 56;
	static inline var ATLAS_WIDTH:Int = 60;
	static inline var ATLAS_HEIGHT:Int = 64;*/
	static inline var ATLAS_TEXTURE_ID:Int = 26;
	static inline var ATLAS_BATCH_TEXTURE_INDEX:Int = 28;
	
	public static inline var BYTES_PER_ITEM:Int = 30;
	
	public var memoryBlock:MemoryBlock;
	public var textureId:Int;
	
	public var x(get, set):Int;
	public var y(get, set):Int;
	public var width(get, set):Int;
	public var height(get, set):Int;
	public var p2Width(get, set):Int;
	public var p2Height(get, set):Int;
	
	public var baseX(get, set):Int;
	public var baseY(get, set):Int;
	public var baseWidth(get, set):Int;
	public var baseHeight(get, set):Int;
	public var baseP2Width(get, set):Int;
	public var baseP2Height(get, set):Int;
	
	public var textureAvailable(get, set):Int;
	
	public var area(get, null):Float;
	public var placed:Bool = false;
	public var partition = new Notifier<AtlasPartition>();
	
	public var atlasTextureId(get, set):Int;
	public var atlasBatchTextureIndex(get, set):Int;
	
	public function new(objectOffset:Int) 
	{
		this.textureId = objectOffset;
		memoryBlock = Fuse.current.keaMemory.textureDataPool.createMemoryBlock(TextureData.BYTES_PER_ITEM, objectOffset);
	}
	
	inline function get_x():Int { 
		return memoryBlock.readInt16(X);
	}
	
	inline function get_y():Int { 
		return memoryBlock.readInt16(Y);
	}
	
	inline function get_width():Int { 
		return memoryBlock.readInt16(WIDTH);
	}
	
	inline function get_height():Int { 
		return memoryBlock.readInt16(HEIGHT);
	}
	
	inline function get_p2Width():Int { 
		return memoryBlock.readInt16(P2_WIDTH);
	}
	
	inline function get_p2Height():Int { 
		return memoryBlock.readInt16(P2_HEIGHT);
	}
	
	inline function get_baseX():Int { 
		return memoryBlock.readInt16(BASE_X);
	}
	
	inline function get_baseY():Int { 
		return memoryBlock.readInt16(BASE_Y);
	}
	
	inline function get_baseWidth():Int { 
		return memoryBlock.readInt16(BASE_WIDTH);
	}
	
	inline function get_baseHeight():Int { 
		return memoryBlock.readInt16(BASE_HEIGHT);
	}
	
	inline function get_baseP2Width():Int { 
		return memoryBlock.readInt16(BASE_P2_WIDTH);
	}
	
	inline function get_baseP2Height():Int { 
		return memoryBlock.readInt16(BASE_P2_HEIGHT);
	}
	
	
	inline function get_textureAvailable():Int { 
		return memoryBlock.readInt16(TEXTURE_AVAILABLE);
	}
	
	/*inline function get_atlasX():Int { 
		return memoryBlock.readInt16(ATLAS_X);
	}
	
	inline function get_atlasY():Int { 
		return memoryBlock.readInt16(ATLAS_Y);
	}
	
	inline function get_atlasWidth():Int { 
		return memoryBlock.readInt16(ATLAS_WIDTH);
	}
	
	inline function get_atlasHeight():Int { 
		return memoryBlock.readInt16(ATLAS_HEIGHT);
	}*/
	
	inline function get_atlasTextureId():Int { 
		return memoryBlock.readInt16(ATLAS_TEXTURE_ID);
	}
	
	inline function get_atlasBatchTextureIndex():Int { 
		return memoryBlock.readInt16(ATLAS_BATCH_TEXTURE_INDEX);
	}
	
	
	
	
	inline function set_x(value:Int):Int { 
		memoryBlock.writeInt16(X, value);
		return value;
	}
	
	inline function set_y(value:Int):Int { 
		memoryBlock.writeInt16(Y, value);
		return value;
	}
	
	inline function set_width(value:Int):Int { 
		memoryBlock.writeInt16(WIDTH, value);
		return value;
	}
	
	inline function set_height(value:Int):Int { 
		memoryBlock.writeInt16(HEIGHT, value);
		return value;
	}
	
	inline function set_p2Width(value:Int):Int { 
		memoryBlock.writeInt16(P2_WIDTH, value);
		return value;
	}
	
	inline function set_p2Height(value:Int):Int { 
		memoryBlock.writeInt16(P2_HEIGHT, value);
		return value;
	}
	
	inline function set_baseX(value:Int):Int { 
		memoryBlock.writeInt16(BASE_X, value);
		return value;
	}
	
	inline function set_baseY(value:Int):Int { 
		memoryBlock.writeInt16(BASE_Y, value);
		return value;
	}
	
	inline function set_baseWidth(value:Int):Int { 
		memoryBlock.writeInt16(BASE_WIDTH, value);
		return value;
	}
	
	inline function set_baseHeight(value:Int):Int { 
		memoryBlock.writeInt16(BASE_HEIGHT, value);
		return value;
	}
	
	inline function set_baseP2Width(value:Int):Int { 
		memoryBlock.writeInt16(BASE_P2_WIDTH, value);
		return value;
	}
	
	inline function set_baseP2Height(value:Int):Int { 
		memoryBlock.writeInt16(BASE_P2_HEIGHT, value);
		return value;
	}
	
	inline function set_textureAvailable(value:Int):Int { 
		memoryBlock.writeInt16(TEXTURE_AVAILABLE, value);
		return value;
	}
	
	
	
	/*inline function set_atlasX(value:Int):Int { 
		memoryBlock.writeInt16(ATLAS_X, value);
		return value;
	}
	
	inline function set_atlasY(value:Int):Int { 
		memoryBlock.writeInt16(ATLAS_Y, value);
		return value;
	}
	
	inline function set_atlasWidth(value:Int):Int { 
		memoryBlock.writeInt16(ATLAS_WIDTH, value);
		return value;
	}
	
	inline function set_atlasHeight(value:Int):Int { 
		memoryBlock.writeInt16(ATLAS_HEIGHT, value);
		return value;
	}*/
	
	inline function set_atlasTextureId(value:Int):Int { 
		memoryBlock.writeInt16(ATLAS_TEXTURE_ID, value);
		return value;
	}
	
	inline function set_atlasBatchTextureIndex(value:Int):Int { 
		memoryBlock.writeInt16(ATLAS_BATCH_TEXTURE_INDEX, value);
		return value;
	}
	
	
	
	public function toString():String
	{
		return "textureId = " + textureId + ", atlasIndex = " + atlasTextureId + " - (" + x + ", " + y + ", " + width + ", " + height + ")";
	}
	
	
	function get_area():Float 
	{
		return this.width * this.height;
	}
}