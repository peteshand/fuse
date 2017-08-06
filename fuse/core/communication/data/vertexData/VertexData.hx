package fuse.core.communication.data.vertexData;
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
	
	public static inline var INDEX_X:Int = 0;
	public static inline var INDEX_Y:Int = 4;
	public static inline var INDEX_U:Int = 8;
	public static inline var INDEX_V:Int = 12;
	public static inline var INDEX_T:Int = 16;
	public static inline var INDEX_ALPHA:Int = 20;
	public static inline var INDEX_R:Int = 24;
	public static inline var INDEX_G:Int = 28;
	public static inline var INDEX_B:Int = 32;
	public static inline var INDEX_A:Int = 36;
	
	public static inline var BYTES_PER_VERTEX:Int = 40;
	public static inline var BYTES_PER_ITEM:Int = BYTES_PER_VERTEX * 4;
	
	public function new() 
	{
		poolStartPosition = Fuse.current.keaMemory.vertexDataPool.start;
	}
	
	/*public function getX(index:Int):Float { return readFloat(INDEX_X + indexOffset(index)); }
	public function getY(index:Int):Float { return readFloat(INDEX_Y + indexOffset(index)); }
	public function getU(index:Int):Float { return readFloat(INDEX_U + indexOffset(index)); }
	public function getV(index:Int):Float { return readFloat(INDEX_V + indexOffset(index)); }
	public function getT(index:Int):Float { return readFloat(INDEX_T + indexOffset(index)); }
	public function getR(index:Int):Float { return readFloat(INDEX_R + indexOffset(index)); }
	public function getG(index:Int):Float { return readFloat(INDEX_G + indexOffset(index)); }
	public function getB(index:Int):Float { return readFloat(INDEX_B + indexOffset(index)); }
	public function getA(index:Int):Float { return readFloat(INDEX_A + indexOffset(index)); }
	public function getAlpha(index:Int):Float { return readFloat(INDEX_ALPHA + indexOffset(index)); }*/
	
	public function setX(index:Int, value:Float):Void { writeFloat(INDEX_X + indexOffset(index), value); }
	public function setY(index:Int, value:Float):Void { writeFloat(INDEX_Y + indexOffset(index), value); }
	public function setU(index:Int, value:Float):Void { writeFloat(INDEX_U + indexOffset(index), value); }
	public function setV(index:Int, value:Float):Void { writeFloat(INDEX_V + indexOffset(index), value); }
	public function setT(index:Int, value:Float):Void { writeFloat(INDEX_T + indexOffset(index), value); }
	public function setR(index:Int, value:Float):Void { writeFloat(INDEX_R + indexOffset(index), value); }
	public function setG(index:Int, value:Float):Void { writeFloat(INDEX_G + indexOffset(index), value); }
	public function setB(index:Int, value:Float):Void { writeFloat(INDEX_B + indexOffset(index), value); }
	public function setA(index:Int, value:Float):Void { writeFloat(INDEX_A + indexOffset(index), value); }
	
	public function setColor(value:Color):Void
	{
		for (i in 0...4) 
		{
			this.setR(i, value.R);
			this.setG(i, value.G);
			this.setB(i, value.B);
			this.setA(i, value.A);
		}
	}
	
	public function setAlpha(value:Float):Void
	{
		for (i in 0...4) 
		{
			// write inverted alpha
			writeFloat(INDEX_ALPHA + indexOffset(i), 1 - value);
		}
	}
	
	inline function indexOffset(index:Int):Int
	{
		return index * BYTES_PER_VERTEX;
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