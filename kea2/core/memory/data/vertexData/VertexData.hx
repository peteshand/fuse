package kea2.core.memory.data.vertexData;
import openfl.Memory;

/**
 * ...
 * @author P.J.Shand
 */
class VertexData
{
	@:isVar public static var OBJECT_POSITION(get, set):Int = 0;
	public static var BUFFER_SIZE:Int = 10000;
	public static inline var BYTES_PER_ITEM:Int = 112;
	
	static var poolStartPosition:Int;
	static var _basePosition:Int = 0;
	public static var basePosition(get, null):Int = 0;
	
	public static inline var INDEX_X1:Int = 0;
	public static inline var INDEX_Y1:Int = 4;
	public static inline var INDEX_Z1:Int = 8;
	public static inline var INDEX_U1:Int = 12;
	public static inline var INDEX_V1:Int = 16;
	public static inline var INDEX_T1:Int = 20;
	//
	
	public static inline var INDEX_X2:Int = 28;
	public static inline var INDEX_Y2:Int = 32;
	public static inline var INDEX_Z2:Int = 36;
	public static inline var INDEX_U2:Int = 40;
	public static inline var INDEX_V2:Int = 44;
	public static inline var INDEX_T2:Int = 48;
	//
	
	public static inline var INDEX_X3:Int = 56;
	public static inline var INDEX_Y3:Int = 60;
	public static inline var INDEX_Z3:Int = 64;
	public static inline var INDEX_U3:Int = 68;
	public static inline var INDEX_V3:Int = 72;
	public static inline var INDEX_T3:Int = 76;
	//
	
	public static inline var INDEX_X4:Int = 84;
	public static inline var INDEX_Y4:Int = 88;
	public static inline var INDEX_Z4:Int = 92;
	public static inline var INDEX_U4:Int = 96;
	public static inline var INDEX_V4:Int = 100;
	public static inline var INDEX_T4:Int = 104;
	
	public static inline var INDEX_BATCH_ID:Int = 108;
	
	/*public static inline var INDEX_RED:Int = 20;
	public static inline var INDEX_GREEN:Int = 24;
	public static inline var INDEX_BLUE:Int = 28;
	public static inline var INDEX_ALPHA:Int = 32;*/
	
	//public var memoryBlock:MemoryBlock;
	
	public var x1(get, set):Float;
	public var y1(get, set):Float;
	public var z1(get, set):Float;
	public var u1(get, set):Float;
	public var v1(get, set):Float;
	//public var t1(get, set):Float;
	
	public var x2(get, set):Float;
	public var y2(get, set):Float;
	public var z2(get, set):Float;
	public var u2(get, set):Float;
	public var v2(get, set):Float;
	//public var t2(get, set):Float;
	
	public var x3(get, set):Float;
	public var y3(get, set):Float;
	public var z3(get, set):Float;
	public var u3(get, set):Float;
	public var v3(get, set):Float;
	//public var t3(get, set):Float;
	
	public var x4(get, set):Float;
	public var y4(get, set):Float;
	public var z4(get, set):Float;
	public var u4(get, set):Float;
	public var v4(get, set):Float;
	//public var t4(get, set):Float;
	public var textureId(get, set):Float;
	public var renderBatchIndex(get, set):Float;
	/*public var red(get, set):Float;
	public var green(get, set):Float;
	public var blue(get, set):Float;
	public var alpha(get, set):Float;*/
	
	public function new() 
	{
		poolStartPosition = Kea.current.keaMemory.vertexDataPool.start;
	}
	
	inline function get_x1():Float return readFloat(INDEX_X1);
	inline function get_y1():Float return readFloat(INDEX_Y1);
	inline function get_z1():Float return readFloat(INDEX_Z1);
	inline function get_u1():Float return readFloat(INDEX_U1);
	inline function get_v1():Float return readFloat(INDEX_V1);
	//inline function get_t1():Float return readFloat(INDEX_T1);
	
	inline function get_x2():Float return readFloat(INDEX_X2);
	inline function get_y2():Float return readFloat(INDEX_Y2);
	inline function get_z2():Float return readFloat(INDEX_Z2);
	inline function get_u2():Float return readFloat(INDEX_U2);
	inline function get_v2():Float return readFloat(INDEX_V2);
	//inline function get_t2():Float return readFloat(INDEX_T2);
	
	inline function get_x3():Float return readFloat(INDEX_X3);
	inline function get_y3():Float return readFloat(INDEX_Y3);
	inline function get_z3():Float return readFloat(INDEX_Z3);
	inline function get_u3():Float return readFloat(INDEX_U3);
	inline function get_v3():Float return readFloat(INDEX_V3);
	//inline function get_t3():Float return readFloat(INDEX_T3);
	
	inline function get_x4():Float return readFloat(INDEX_X4);
	inline function get_y4():Float return readFloat(INDEX_Y4);
	inline function get_z4():Float return readFloat(INDEX_Z4);
	inline function get_u4():Float return readFloat(INDEX_U4);
	inline function get_v4():Float return readFloat(INDEX_V4);
	//inline function get_t4():Float return readFloat(INDEX_T4);
	inline function get_textureId():Float return readFloat(INDEX_T1);
	inline function get_renderBatchIndex():Float return readFloat(INDEX_BATCH_ID);
	
	
	//inline function get_red():Float { 
		//return readFloat(INDEX_RED);
	//}
	//
	//inline function get_green():Float { 
		//return readFloat(INDEX_GREEN);
	//}
	//
	//inline function get_blue():Float { 
		//return readFloat(INDEX_BLUE);
	//}
	//
	//inline function get_alpha():Float { 
		//return readFloat(INDEX_ALPHA);
	//}
	
	
	
	inline function set_x1(value:Float):Float { 
		writeFloat(INDEX_X1, value);
		return value;
	}
	
	inline function set_y1(value:Float):Float { 
		writeFloat(INDEX_Y1, value);
		return value;
	}
	
	inline function set_z1(value:Float):Float { 
		writeFloat(INDEX_Z1, value);
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
	
	/*inline function set_t1(value:Float):Float {
		writeFloat(INDEX_T1, value);
		return value;
	}*/
	
	
	inline function set_x2(value:Float):Float { 
		writeFloat(INDEX_X2, value);
		return value;
	}
	
	inline function set_y2(value:Float):Float { 
		writeFloat(INDEX_Y2, value);
		return value;
	}
	
	inline function set_z2(value:Float):Float { 
		writeFloat(INDEX_Z2, value);
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
	
	/*inline function set_t2(value:Float):Float {
		writeFloat(INDEX_T2, value);
		return value;
	}*/
	
	
	inline function set_x3(value:Float):Float { 
		writeFloat(INDEX_X3, value);
		return value;
	}
	
	inline function set_y3(value:Float):Float { 
		writeFloat(INDEX_Y3, value);
		return value;
	}
	
	inline function set_z3(value:Float):Float { 
		writeFloat(INDEX_Z3, value);
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
	
	/*inline function set_t3(value:Float):Float {
		writeFloat(INDEX_T3, value);
		return value;
	}*/
	
	
	inline function set_x4(value:Float):Float { 
		writeFloat(INDEX_X4, value);
		return value;
	}
	
	inline function set_y4(value:Float):Float { 
		writeFloat(INDEX_Y4, value);
		return value;
	}
	
	inline function set_z4(value:Float):Float {
		writeFloat(INDEX_Z4, value);
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
	
	/*inline function set_t4(value:Float):Float {
		writeFloat(INDEX_T4, value);
		return value;
	}*/
	inline function set_textureId(value:Float):Float {
		writeFloat(INDEX_T1, value);
		writeFloat(INDEX_T2, value);
		writeFloat(INDEX_T3, value);
		writeFloat(INDEX_T4, value);
		return value;
	}
	
	inline function set_renderBatchIndex(value:Float):Float {
		writeFloat(INDEX_BATCH_ID, value);
		return value;
	}
	
	
	
	
	function readFloat(offset:Int):Float
	{
		//OBJECT_POSITION = objectOffset;
		return Memory.getFloat(VertexData.basePosition + offset);
	}
	
	function writeFloat(offset:Int, value:Float):Void
	{
		//OBJECT_POSITION = objectOffset;
		//trace(VertexData.basePosition + offset);
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
	
	//inline function set_red(value:Float):Float { 
		//writeFloat(INDEX_RED, value);
		//return value;
	//}
	//
	//inline function set_green(value:Float):Float { 
		//writeFloat(INDEX_GREEN, value);
		//return value;
	//}
	//
	//inline function set_blue(value:Float):Float { 
		//writeFloat(INDEX_BLUE, value);
		//return value;
	//}
	//
	//inline function set_alpha(value:Float):Float { 
		//writeFloat(INDEX_ALPHA, value);
		//return value;
	//}
}