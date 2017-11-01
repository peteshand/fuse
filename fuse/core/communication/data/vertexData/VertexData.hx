package fuse.core.communication.data.vertexData;
import fuse.Fuse;
import fuse.core.communication.data.indices.IndicesData;
import openfl.Memory;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.communication.data.indices.IndicesData)
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
	public static inline var INDEX_MU:Int = 16;
	public static inline var INDEX_MV:Int = 20;
	
	public static inline var INDEX_TEXTURE:Int = 24;
	public static inline var INDEX_MASK_TEXTURE:Int = 28;
	public static inline var INDEX_MASK_BASE_VALUE:Int = 32;
	public static inline var INDEX_ALPHA:Int = 36;
	
	public static inline var INDEX_R:Int = 40;
	public static inline var INDEX_G:Int = 44;
	public static inline var INDEX_B:Int = 48;
	public static inline var INDEX_A:Int = 52;
	
	public static inline var BYTES_PER_VALUE:Int = 4;
	public static inline var VALUES_PER_VERTEX:Int = 14;
	public static inline var BYTES_PER_VERTEX:Int = BYTES_PER_VALUE * VALUES_PER_VERTEX;
	public static inline var BYTES_PER_ITEM:Int = BYTES_PER_VERTEX * 4;
	
	public function new() 
	{
		poolStartPosition = Fuse.current.sharedMemory.vertexDataPool.start;
	}
	
	/*public function getX(index:Int):Float { return readFloat(INDEX_X + indexOffset(index)); }
	public function getY(index:Int):Float { return readFloat(INDEX_Y + indexOffset(index)); }
	public function getU(index:Int):Float { return readFloat(INDEX_U + indexOffset(index)); }
	public function getV(index:Int):Float { return readFloat(INDEX_V + indexOffset(index)); }
	public function getT(index:Int):Float { return readFloat(INDEX_TEXTURE + indexOffset(index)); }
	public function getR(index:Int):Float { return readFloat(INDEX_R + indexOffset(index)); }
	public function getG(index:Int):Float { return readFloat(INDEX_G + indexOffset(index)); }
	public function getB(index:Int):Float { return readFloat(INDEX_B + indexOffset(index)); }
	public function getA(index:Int):Float { return readFloat(INDEX_A + indexOffset(index)); }
	public function getAlpha(index:Int):Float { return readFloat(INDEX_ALPHA + indexOffset(index)); }*/
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function setXY(index:Int, x:Float, y:Float):Void 
	{
		setX(index, x);
		setY(index, y);
	}
	inline function setX(index:Int, value:Float):Void { writeFloat(INDEX_X + indexOffset(index), value); }
	inline function setY(index:Int, value:Float):Void { writeFloat(INDEX_Y + indexOffset(index), value); }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function setUV(index:Int, u:Float, v:Float):Void
	{
		setU(index, u);
		setV(index, v);
	}
	inline function setU(index:Int, value:Float):Void { writeFloat(INDEX_U + indexOffset(index), value); }
	inline function setV(index:Int, value:Float):Void { writeFloat(INDEX_V + indexOffset(index), value); }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function setMaskUV(index:Int, u:Float, v:Float):Void
	{
		setMaskU(index, u);
		setMaskV(index, v);
	}
	inline function setMaskU(index:Int, value:Float):Void { writeFloat(INDEX_MU + indexOffset(index), value); }
	inline function setMaskV(index:Int, value:Float):Void { writeFloat(INDEX_MV + indexOffset(index), value); }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function setTexture(value:Float):Void
	{
		for (i in 0...4) writeFloat(INDEX_TEXTURE + indexOffset(i), value);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function setMaskTexture(value:Float):Void
	{
		for (i in 0...4) writeFloat(INDEX_MASK_TEXTURE + indexOffset(i), value);
		if (value == -1) setMaskBaseValue(1);
		else setMaskBaseValue(0);
	}
	
	function setMaskBaseValue(value:Float):Void
	{
		for (i in 0...4) writeFloat(INDEX_MASK_BASE_VALUE + indexOffset(i), value);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function setAlpha(value:Float):Void
	{
		for (i in 0...4) writeFloat(INDEX_ALPHA + indexOffset(i), 1 - value); // write inverted alpha
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
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
	inline function setR(index:Int, value:Float):Void { writeFloat(INDEX_R + indexOffset(index), value); }
	inline function setG(index:Int, value:Float):Void { writeFloat(INDEX_G + indexOffset(index), value); }
	inline function setB(index:Int, value:Float):Void { writeFloat(INDEX_B + indexOffset(index), value); }
	inline function setA(index:Int, value:Float):Void { writeFloat(INDEX_A + indexOffset(index), value); }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
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
		IndicesData.OBJECT_POSITION = value;
		return value;
	}
	
	static inline function get_basePosition():Int 
	{
		return _basePosition;
	}
}