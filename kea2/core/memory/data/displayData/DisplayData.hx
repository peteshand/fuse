package kea2.core.memory.data.displayData;
import kea2.core.memory.data.MemoryBlock;
import kha.Color;

/**
 * ...
 * @author P.J.Shand
 */
class DisplayData
{
	public static var BUFFER_SIZE:Int = 10000;
	public static inline var BYTES_PER_ITEM:Int = 48;
	
	public static inline var INDEX_X:Int = 0;
	public static inline var INDEX_Y:Int = 4;
	public static inline var INDEX_WIDTH:Int = 8;
	public static inline var INDEX_HEIGHT:Int = 12;
	public static inline var INDEX_PIVOT_X:Int = 16;
	public static inline var INDEX_PIVOT_Y:Int = 20;
	public static inline var INDEX_SCALE_X:Int = 24;
	public static inline var INDEX_SCALE_Y:Int = 28;
	public static inline var INDEX_ROTATION:Int = 32;
	public static inline var INDEX_ALPHA:Int = 36;
	
	public static inline var INDEX_COLOR:Int = 40;
	//public static inline var INDEX_OBJECT_ID:Int = 44;
	//public static inline var INDEX_PARENT_ID:Int = 48;
	//public static inline var INDEX_RENDER_ID:Int = 52;
	public static inline var INDEX_TEXTURE_ID:Int = 44;
	
	//public static inline var INDEX_IS_STATIC:Int = 60;
	//public static inline var INDEX_APPLY_POSITION:Int = 64;
	//public static inline var INDEX_APPLY_ROTATION:Int = 68;
	
	public var memoryBlock:MemoryBlock;
	
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
	
	public var color(get, set):Color;
	//public var objectId(get, set):Int;
	//public var parentId(get, set):Int;
	//public var renderId(get, set):Int;
	public var textureId(get, set):Int;
	
	//public var isStatic(get, set):Int;
	//public var applyPosition(get, set):Int;
	//public var applyRotation(get, set):Int;
	
	public function new(objectOffset:Int) 
	{
		memoryBlock = Kea.current.keaMemory.displayDataPool.createMemoryBlock(DisplayData.BYTES_PER_ITEM, objectOffset);
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
	
	inline function get_color():Color { 
		return memoryBlock.readInt(DisplayData.INDEX_COLOR);
	}
	
	//inline function get_objectId():Int { 
		//return memoryBlock.readInt(INDEX_OBJECT_ID);
	//}
	
	//inline function get_parentId():Int { 
		//return memoryBlock.readInt(INDEX_PARENT_ID);
	//}
	
	//inline function get_renderId():Int { 
		//return memoryBlock.readInt(INDEX_RENDER_ID);
	//}
	
	inline function get_textureId():Int { 
		return memoryBlock.readInt(INDEX_TEXTURE_ID);
	}
	
	//inline function get_isStatic():Int { 
		//return memoryBlock.readInt(INDEX_IS_STATIC);
	//}
	
	//inline function get_applyPosition():Int { 
		//return memoryBlock.readInt(INDEX_APPLY_POSITION);
	//}
	
	//inline function get_applyRotation():Int { 
		//return memoryBlock.readInt(INDEX_APPLY_ROTATION);
	//}
	
	
	
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
	
	inline function set_color(value:Color):Color { 
		memoryBlock.writeInt(INDEX_COLOR, value);
		return value;
	}
	
	//inline function set_objectId(value:Int):Int { 
		//memoryBlock.writeInt(INDEX_OBJECT_ID, value);
		//return value;
	//}
	
	//inline function set_parentId(value:Int):Int { 
		//memoryBlock.writeInt(INDEX_PARENT_ID, value);
		//return value;
	//}
	
	//inline function set_renderId(value:Int):Int { 
		//memoryBlock.writeInt(INDEX_RENDER_ID, value);
		//return value;
	//}
	
	inline function set_textureId(value:Int):Int { 
		memoryBlock.writeInt(INDEX_TEXTURE_ID, value);
		return value;
	}
	
	//inline function set_isStatic(value:Int):Int { 
		//memoryBlock.writeInt(INDEX_IS_STATIC, value);
		//return value;
	//}
	
	//inline function set_applyPosition(value:Int):Int { 
		//memoryBlock.writeInt(INDEX_APPLY_POSITION, value);
		//return value;
	//}
	
	//inline function set_applyRotation(value:Int):Int { 
		//memoryBlock.writeInt(INDEX_APPLY_ROTATION, value);
		//return value;
	//}
}