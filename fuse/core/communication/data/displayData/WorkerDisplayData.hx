package fuse.core.communication.data.displayData;
import fuse.Fuse;
import fuse.core.communication.data.MemoryBlock;

/**
 * ...
 * @author P.J.Shand
 */

class WorkerDisplayData /*implements IDisplayData*/
{
	public static var BUFFER_SIZE:Int = 10000;
	
	static inline var INDEX_X:Int = 0;
	static inline var INDEX_Y:Int = 4;
	static inline var INDEX_WIDTH:Int = 8;
	static inline var INDEX_HEIGHT:Int = 12;
	static inline var INDEX_PIVOT_X:Int = 16;
	static inline var INDEX_PIVOT_Y:Int = 20;
	static inline var INDEX_SCALE_X:Int = 24;
	static inline var INDEX_SCALE_Y:Int = 28;
	static inline var INDEX_ROTATION:Int = 32;
	static inline var INDEX_ALPHA:Int = 36;
	static inline var INDEX_COLOR:Int = 40;
	static inline var INDEX_COLOR_TL:Int = 44;
	static inline var INDEX_COLOR_TR:Int = 48;
	static inline var INDEX_COLOR_BL:Int = 52;
	static inline var INDEX_COLOR_BR:Int = 56;
	
	static inline var INDEX_TEXTURE_ID:Int = 60;
	static inline var INDEX_RENDER_LAYER:Int = 64;
	static inline var INDEX_VISIBLE:Int = 68;
	static inline var INDEX_BLEND_MODE:Int = 72;
	
	static inline var INDEX_SHADER_ID:Int = 76;
	
	static inline var INDEX_IS_STATIC:Int = 80;
	static inline var INDEX_IS_MOVING:Int = 84;
	static inline var INDEX_IS_ROTATING:Int = 88;
	
	public static inline var BYTES_PER_ITEM:Int = 92;
	
	var memoryBlock:MemoryBlock;
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, set):Float;
	public var height(get, set):Float;
	public var pivotX(get, set):Float;
	public var pivotY(get, set):Float;
	public var scaleX(get, set):Float;
	public var scaleY(get, set):Float;
	public var rotation(get, set):Float;
	public var alpha(get, set):Float;
	public var color(get, set):UInt;
	public var colorTL(get, set):UInt;
	public var colorTR(get, set):UInt;
	public var colorBL(get, set):UInt;
	public var colorBR(get, set):UInt;
	public var textureId(get, set):Int;
	public var renderLayer(get, set):Int;
	
	public var visible(get, set):Int;
	public var blendMode(get, set):Int;
	
	public var shaderId(get, set):Int;

	public var isStatic(get, set):Int;
	public var isMoving(get, set):Int;
	public var isRotating(get, set):Int;
	
	private var _objectId:Int;
	public var objectId(get, never):Int;
	
	public function new(objectOffset:Null<Int>) 
	{
		if (objectOffset != null) {
			_objectId = objectOffset;
			memoryBlock = Fuse.current.sharedMemory.displayDataPool.createMemoryBlock(WorkerDisplayData.BYTES_PER_ITEM, objectOffset);
		}
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
	
	inline function get_pivotX():Float { 
		return memoryBlock.readFloat(INDEX_PIVOT_X);
	}
	
	inline function get_pivotY():Float { 
		return memoryBlock.readFloat(INDEX_PIVOT_Y);
	}
	
	inline function get_scaleX():Float { 
		return memoryBlock.readFloat(INDEX_SCALE_X);
	}
	
	inline function get_scaleY():Float { 
		return memoryBlock.readFloat(INDEX_SCALE_Y);
	}
	
	inline function get_rotation():Float { 
		return memoryBlock.readFloat(INDEX_ROTATION);
	}
	
	inline function get_alpha():Float { 
		return memoryBlock.readFloat(INDEX_ALPHA);
	}
	
	inline function get_color():UInt { 
		return memoryBlock.readInt(WorkerDisplayData.INDEX_COLOR);
	}
	
	inline function get_colorTL():UInt { 
		return memoryBlock.readInt(WorkerDisplayData.INDEX_COLOR_TL);
	}
	
	inline function get_colorTR():UInt { 
		return memoryBlock.readInt(WorkerDisplayData.INDEX_COLOR_TR);
	}
	
	inline function get_colorBL():UInt { 
		return memoryBlock.readInt(WorkerDisplayData.INDEX_COLOR_BL);
	}
	
	inline function get_colorBR():UInt { 
		return memoryBlock.readInt(WorkerDisplayData.INDEX_COLOR_BR);
	}
	
	inline function get_textureId():Int { 
		return memoryBlock.readInt(INDEX_TEXTURE_ID);
	}
	
	inline function get_renderLayer():Int { 
		return memoryBlock.readInt(INDEX_RENDER_LAYER);
	}
	
	inline function get_visible():Int { 
		return memoryBlock.readByte(INDEX_VISIBLE);
	}
	
	inline function get_blendMode():Int { 
		return memoryBlock.readByte(INDEX_BLEND_MODE);
	}
	
	inline function get_shaderId():Int { return memoryBlock.readInt(INDEX_SHADER_ID); }
	
	
	inline function get_isStatic():Int { 
		return memoryBlock.readByte(INDEX_IS_STATIC);
	}
	
	inline function get_isMoving():Int { 
		return memoryBlock.readByte(INDEX_IS_MOVING);
	}
	
	inline function get_isRotating():Int { 
		return memoryBlock.readByte(INDEX_IS_ROTATING);
	}
	
	
	inline function get_objectId():Int
	{
		return _objectId;
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
	
	inline function set_pivotX(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_PIVOT_X, value);
		return value;
	}
	
	inline function set_pivotY(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_PIVOT_Y, value);
		return value;
	}
	
	inline function set_scaleX(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_SCALE_X, value);
		return value;
	}
	
	inline function set_scaleY(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_SCALE_Y, value);
		return value;
	}
	
	inline function set_rotation(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_ROTATION, value);
		return value;
	}
	
	inline function set_alpha(value:Float):Float { 
		memoryBlock.writeFloat(INDEX_ALPHA, value);
		return value;
	}
	
	inline function set_color(value:UInt):UInt { 
		memoryBlock.writeInt(INDEX_COLOR, value);
		return value;
	}
	
	inline function set_colorTL(value:UInt):UInt { 
		memoryBlock.writeInt(INDEX_COLOR_TL, value);
		return value;
	}
	
	inline function set_colorTR(value:UInt):UInt { 
		memoryBlock.writeInt(INDEX_COLOR_TR, value);
		return value;
	}
	
	inline function set_colorBL(value:UInt):UInt { 
		memoryBlock.writeInt(INDEX_COLOR_BL, value);
		return value;
	}
	
	inline function set_colorBR(value:UInt):UInt { 
		memoryBlock.writeInt(INDEX_COLOR_BR, value);
		return value;
	}
	
	inline function set_textureId(value:Int):Int { 
		memoryBlock.writeInt(INDEX_TEXTURE_ID, value);
		return value;
	}
	
	inline function set_renderLayer(value:Int):Int { 
		memoryBlock.writeInt(INDEX_RENDER_LAYER, value);
		return value;
	}
	
	inline function set_visible(value:Int):Int { 
		memoryBlock.writeByte(INDEX_VISIBLE, value);
		return value;
	}
	
	inline function set_blendMode(value:Int):Int { 
		memoryBlock.writeByte(INDEX_BLEND_MODE, value);
		return value;
	}
	
	inline function set_shaderId(value:Int):Int { memoryBlock.writeInt(INDEX_SHADER_ID, value); return value; }
	
	inline function set_isStatic(value:Int):Int { 
		memoryBlock.writeByte(INDEX_IS_STATIC, value);
		return value;
	}
	
	inline function set_isMoving(value:Int):Int { 
		memoryBlock.writeByte(INDEX_IS_MOVING, value);
		return value;
	}
	
	inline function set_isRotating(value:Int):Int { 
		memoryBlock.writeByte(INDEX_IS_ROTATING, value);
		return value;
	}
	
	
}