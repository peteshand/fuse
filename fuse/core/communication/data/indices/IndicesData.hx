package fuse.core.communication.data.indices;
import openfl.Memory;

/**
 * ...
 * @author P.J.Shand
 */
class IndicesData implements IIndicesData
{
	@:isVar private static var OBJECT_POSITION(get, set):Int = 0;
	public static var BUFFER_SIZE:Int = 10000;
	
	static var poolStartPosition:Int;
	static var _basePosition:Int = 0;
	public static var basePosition(get, null):Int = 0;
	
	public static inline var I1:Int = 0;
	public static inline var I2:Int = 2;
	public static inline var I3:Int = 4;
	public static inline var I4:Int = 6;
	public static inline var I5:Int = 8;
	public static inline var I6:Int = 10;
	
	public static inline var BYTES_PER_ITEM:Int = 12;
	static inline var BYTES_PER_VALUE:Int = 2;
	
	public var i1(get, set):Int;
	public var i2(get, set):Int;
	public var i3(get, set):Int;
	public var i4(get, set):Int;
	public var i5(get, set):Int;
	public var i6(get, set):Int;
	
	
	
	public function new() 
	{
		poolStartPosition = Fuse.current.sharedMemory.indicesDataPool.start;
	}
	
	/*public inline function getIndex(index:Int):Int
	{
		return readShort(index * IndicesData.BYTES_PER_VALUE);
	}*/
	
	public inline function setIndex(index:Int, value:Int):Void
	{
		writeShort(index * IndicesData.BYTES_PER_VALUE, IndicesData.OBJECT_POSITION * 4 + value);
	}
	
	inline function get_i1():Int return readShort(I1);
	inline function get_i2():Int return readShort(I2);
	inline function get_i3():Int return readShort(I3);
	inline function get_i4():Int return readShort(I4);
	inline function get_i5():Int return readShort(I5);
	inline function get_i6():Int return readShort(I6);
	
	inline function set_i1(value:Int):Int { 
		writeShort(I1, value);
		return value;
	}
	
	inline function set_i2(value:Int):Int { 
		writeShort(I2, value);
		return value;
	}
	
	inline function set_i3(value:Int):Int { 
		writeShort(I3, value);
		return value;
	}
	
	inline function set_i4(value:Int):Int { 
		writeShort(I4, value);
		return value;
	}
	
	inline function set_i5(value:Int):Int { 
		writeShort(I5, value);
		return value;
	}
	
	inline function set_i6(value:Int):Int { 
		writeShort(I6, value);
		return value;
	}
	
	inline function readShort(offset:Int):Int
	{
		return Memory.getUI16(IndicesData.basePosition + offset);
	}
	
	inline function writeShort(offset:Int, value:Int):Void
	{
		Memory.setI16(IndicesData.basePosition + offset, value);
	}
	
	static inline function get_OBJECT_POSITION():Int 
	{
		return IndicesData.OBJECT_POSITION;
	}
	
	static inline function set_OBJECT_POSITION(value:Int):Int 
	{
		IndicesData.OBJECT_POSITION = value;
		IndicesData._basePosition = poolStartPosition + (IndicesData.OBJECT_POSITION * IndicesData.BYTES_PER_ITEM);
		return value;
	}
	
	static inline function get_basePosition():Int 
	{
		return _basePosition;
	}
}