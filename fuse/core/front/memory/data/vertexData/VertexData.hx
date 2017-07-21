package fuse.core.front.memory.data.vertexData;
import fuse.Fuse;
import openfl.Memory;

/**
 * ...
 * @author P.J.Shand
 */
class VertexData implements IVertexData
{
	@:isVar public static var OBJECT_POSITION(get, set):Int = 0;
	public static var BUFFER_SIZE:Int = 10000;
	
	static var poolStartPosition:Int;
	static var _basePosition:Int = 0;
	public static var basePosition(get, null):Int = 0;
	
	public static inline var INDEX_X1:Int = 0;
	public static inline var INDEX_Y1:Int = 4;
	public static inline var INDEX_U1:Int = 8;
	public static inline var INDEX_V1:Int = 12;
	public static inline var INDEX_T1:Int = 16;
	
	public static inline var INDEX_X2:Int = 20;
	public static inline var INDEX_Y2:Int = 24;
	public static inline var INDEX_U2:Int = 28;
	public static inline var INDEX_V2:Int = 32;
	public static inline var INDEX_T2:Int = 36;
	
	public static inline var INDEX_X3:Int = 40;
	public static inline var INDEX_Y3:Int = 44;
	public static inline var INDEX_U3:Int = 48;
	public static inline var INDEX_V3:Int = 52;
	public static inline var INDEX_T3:Int = 56;
	
	public static inline var INDEX_X4:Int = 60;
	public static inline var INDEX_Y4:Int = 64;
	public static inline var INDEX_U4:Int = 68;
	public static inline var INDEX_V4:Int = 72;
	public static inline var INDEX_T4:Int = 76;
	public static inline var BYTES_PER_ITEM:Int = 80;
	
	public var x1(get, set):Float;
	public var y1(get, set):Float;
	public var u1(get, set):Float;
	public var v1(get, set):Float;
	
	public var x2(get, set):Float;
	public var y2(get, set):Float;
	public var u2(get, set):Float;
	public var v2(get, set):Float;
	
	public var x3(get, set):Float;
	public var y3(get, set):Float;
	public var u3(get, set):Float;
	public var v3(get, set):Float;
	
	public var x4(get, set):Float;
	public var y4(get, set):Float;
	public var u4(get, set):Float;
	public var v4(get, set):Float;
	public var batchTextureIndex(get, set):Float;
	
	public function new() 
	{
		poolStartPosition = Fuse.current.keaMemory.vertexDataPool.start;
	}
	
	inline function get_x1():Float return readFloat(INDEX_X1);
	inline function get_y1():Float return readFloat(INDEX_Y1);
	inline function get_u1():Float return readFloat(INDEX_U1);
	inline function get_v1():Float return readFloat(INDEX_V1);
	
	inline function get_x2():Float return readFloat(INDEX_X2);
	inline function get_y2():Float return readFloat(INDEX_Y2);
	inline function get_u2():Float return readFloat(INDEX_U2);
	inline function get_v2():Float return readFloat(INDEX_V2);
	
	inline function get_x3():Float return readFloat(INDEX_X3);
	inline function get_y3():Float return readFloat(INDEX_Y3);
	inline function get_u3():Float return readFloat(INDEX_U3);
	inline function get_v3():Float return readFloat(INDEX_V3);
	
	inline function get_x4():Float return readFloat(INDEX_X4);
	inline function get_y4():Float return readFloat(INDEX_Y4);
	inline function get_u4():Float return readFloat(INDEX_U4);
	inline function get_v4():Float return readFloat(INDEX_V4);
	inline function get_batchTextureIndex():Float return readFloat(INDEX_T1);
	
	
	inline function set_x1(value:Float):Float { 
		writeFloat(INDEX_X1, value);
		return value;
	}
	
	inline function set_y1(value:Float):Float { 
		writeFloat(INDEX_Y1, value);
		return value;
	}
	
	inline function set_u1(value:Float):Float {
		writeFloat(INDEX_U1, value);
		return value;
	}
	
	inline function set_v1(value:Float):Float {
		writeFloat(INDEX_V1, value);
		return value;
	}
	
	inline function set_x2(value:Float):Float { 
		writeFloat(INDEX_X2, value);
		return value;
	}
	
	inline function set_y2(value:Float):Float { 
		writeFloat(INDEX_Y2, value);
		return value;
	}
	
	inline function set_u2(value:Float):Float {
		writeFloat(INDEX_U2, value);
		return value;
	}
	
	inline function set_v2(value:Float):Float {
		writeFloat(INDEX_V2, value);
		return value;
	}
	
	inline function set_x3(value:Float):Float { 
		writeFloat(INDEX_X3, value);
		return value;
	}
	
	inline function set_y3(value:Float):Float { 
		writeFloat(INDEX_Y3, value);
		return value;
	}
	
	inline function set_u3(value:Float):Float {
		writeFloat(INDEX_U3, value);
		return value;
	}
	
	inline function set_v3(value:Float):Float {
		writeFloat(INDEX_V3, value);
		return value;
	}
	
	inline function set_x4(value:Float):Float { 
		writeFloat(INDEX_X4, value);
		return value;
	}
	
	inline function set_y4(value:Float):Float { 
		writeFloat(INDEX_Y4, value);
		return value;
	}
	
	inline function set_u4(value:Float):Float {
		writeFloat(INDEX_U4, value);
		return value;
	}
	
	inline function set_v4(value:Float):Float {
		writeFloat(INDEX_V4, value);
		return value;
	}
	
	inline function set_batchTextureIndex(value:Float):Float {
		writeFloat(INDEX_T1, value);
		writeFloat(INDEX_T2, value);
		writeFloat(INDEX_T3, value);
		writeFloat(INDEX_T4, value);
		return value;
	}
	
	inline function readFloat(offset:Int):Float
	{
		return Memory.getFloat(VertexData.basePosition + offset);
	}
	
	inline function writeFloat(offset:Int, value:Float):Void
	{
		Memory.setFloat(VertexData.basePosition + offset, value);
	}
	
	static inline function get_OBJECT_POSITION():Int 
	{
		return VertexData.OBJECT_POSITION;
	}
	
	static inline function set_OBJECT_POSITION(value:Int):Int 
	{
		VertexData.OBJECT_POSITION = value;
		VertexData._basePosition = poolStartPosition + (VertexData.OBJECT_POSITION * VertexData.BYTES_PER_ITEM);
		return value;
	}
	
	static inline function get_basePosition():Int 
	{
		return _basePosition;
	}
}