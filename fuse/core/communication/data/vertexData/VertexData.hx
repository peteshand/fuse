package fuse.core.communication.data.vertexData;

import fuse.Fuse;
import fuse.utils.Color;
import fuse.core.communication.memory.Memory;

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
	
	//public static inline var INDEX_XY:Int = 0;
	public static inline var INDEX_X:Int = 0;
	public static inline var INDEX_Y:Int = 4;
	
	public static inline var INDEX_U:Int = 8;
	public static inline var INDEX_V:Int = 12;
	public static inline var INDEX_MU:Int = 16;
	public static inline var INDEX_MV:Int = 20;
	
	public static inline var INDEX_COLOR:Int = 24;
	
	public static inline var INDEX_TEXTURE:Int = 28;
	public static inline var INDEX_MASK_TEXTURE:Int = 32;
	public static inline var INDEX_MASK_BASE_VALUE:Int = 36;
	public static inline var INDEX_ALPHA:Int = 40;
	
	public static inline var BYTES_PER_VALUE:Int = 4;
	public static inline var VALUES_PER_VERTEX:Int = 11;
	public static inline var BYTES_PER_VERTEX:Int = BYTES_PER_VALUE * VALUES_PER_VERTEX;
	public static inline var BYTES_PER_ITEM:Int = BYTES_PER_VERTEX * 4;
	
	public function new() 
	{
		poolStartPosition = Fuse.current.sharedMemory.vertexDataPool.start;
	}
	
	inline public function setXY(index:Int, x:Float, y:Float):Void 
	{
		writeFloat(INDEX_X + indexOffset(index), x);
		writeFloat(INDEX_Y + indexOffset(index), y);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline public function setUV(index:Int, u:Float, v:Float):Void
	{
		writeFloat(INDEX_U + indexOffset(index), u);
		writeFloat(INDEX_V + indexOffset(index), v);
		
		//setU(index, u);
		//setV(index, v);
	}
	//inline function setU(index:Int, value:Float):Void { writeFloat(INDEX_U + indexOffset(index), value); }
	//inline function setV(index:Int, value:Float):Void { writeFloat(INDEX_V + indexOffset(index), value); }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline public function setMaskUV(index:Int, u:Float, v:Float):Void
	{
		setMaskU(index, u);
		setMaskV(index, v);
	}
	inline function setMaskU(index:Int, value:Float):Void { writeFloat(INDEX_MU + indexOffset(index), value); }
	inline function setMaskV(index:Int, value:Float):Void { writeFloat(INDEX_MV + indexOffset(index), value); }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline public function setTexture(value:Float):Void
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
	
	inline function setMaskBaseValue(value:Float):Void
	{
		for (i in 0...4) writeFloat(INDEX_MASK_BASE_VALUE + indexOffset(i), value);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline public function setAlpha(value:Float):Void
	{
		for (i in 0...4) writeFloat(INDEX_ALPHA + indexOffset(i), 1 - value); // write inverted alpha
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline public function setColor(index:Int, value:Color):Void
	{
		//writeFloat(INDEX_COLOR + indexOffset(index), value);
		writeInt32(INDEX_COLOR + indexOffset(index), value);
	}
	
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
	
	inline function writeInt32(offset:Int, value:UInt):Void
	{
		Memory.setI32(VertexData.basePosition + offset, value);
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