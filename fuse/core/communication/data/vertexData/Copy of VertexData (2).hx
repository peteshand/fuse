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
	
	var x = new Gate(0);
	var y = new Gate(4);
	
	var u = new Gate(8);
	var v = new Gate(12);
	var mu = new Gate(16);
	var mv = new Gate(20);
	
	var texture = new Gate(24);
	var mask_texture = new Gate(28);
	var mask_base_value = new Gate(32);
	var alpha = new Gate(36);
	
	var r = new Gate(40);
	var g = new Gate(44);
	var b = new Gate(48);
	var a = new Gate(52);
	
	public function new() 
	{
		
		
		poolStartPosition = Fuse.current.sharedMemory.vertexDataPool.start;
	}
	
	inline public function setXY(index:Int, x:Float, y:Float):Void 
	{
		setX(index, x);
		setY(index, y);
	}
	inline function setX(index:Int, value:Float):Void { x.set(INDEX_X + indexOffset(index), value); }
	inline function setY(index:Int, value:Float):Void { y.set(INDEX_Y + indexOffset(index), value); }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline public function setUV(index:Int, u:Float, v:Float):Void
	{
		setU(index, u);
		setV(index, v);
	}
	inline function setU(index:Int, value:Float):Void { u.set(INDEX_U + indexOffset(index), value); }
	inline function setV(index:Int, value:Float):Void { v.set(INDEX_V + indexOffset(index), value); }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline public function setMaskUV(index:Int, u:Float, v:Float):Void
	{
		setMaskU(index, u);
		setMaskV(index, v);
	}
	inline function setMaskU(index:Int, value:Float):Void { mu.set(INDEX_MU + indexOffset(index), value); }
	inline function setMaskV(index:Int, value:Float):Void { mv.set(INDEX_MV + indexOffset(index), value); }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline public function setTexture(value:Float):Void
	{
		for (i in 0...4) texture.set(INDEX_TEXTURE + indexOffset(i), value);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	public function setMaskTexture(value:Float):Void
	{
		for (i in 0...4) mask_texture.set(INDEX_MASK_TEXTURE + indexOffset(i), value);
		if (value == -1) setMaskBaseValue(1);
		else setMaskBaseValue(0);
	}
	
	inline function setMaskBaseValue(value:Float):Void
	{
		for (i in 0...4) mask_base_value.set(INDEX_MASK_BASE_VALUE + indexOffset(i), value);
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline public function setAlpha(value:Float):Void
	{
		for (i in 0...4) alpha.set(INDEX_ALPHA + indexOffset(i), 1 - value); // write inverted alpha
	}
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline public function setColor(value:Color):Void
	{
		for (i in 0...4) 
		{
			this.setR(i, value.red);
			this.setG(i, value.green);
			this.setB(i, value.blue);
			this.setA(i, value.alpha);
		}
	}
	inline function setR(index:Int, value:Float):Void { r.set(INDEX_R + indexOffset(index), value); }
	inline function setG(index:Int, value:Float):Void { g.set(INDEX_B + indexOffset(index), value); }
	inline function setB(index:Int, value:Float):Void { b.set(INDEX_G + indexOffset(index), value); }
	inline function setA(index:Int, value:Float):Void { a.set(INDEX_A + indexOffset(index), value); }
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	inline function indexOffset(index:Int):Int
	{
		return index * BYTES_PER_VERTEX;
	}
	
	//inline function readFloat(offset:Int):Float
	//{
		//return Memory.getFloat(VertexData.basePosition + offset);
	//}
	
	//inline function writeFloat(offset:Int, value:Float):Void
	//{
		//Memory.setFloat(VertexData.basePosition + offset, value);
	//}
	
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

class Gate
{
	var value:Float = 0;
	var baseOffset:Int;
	
	public function new(baseOffset:Int):Void
	{
		this.baseOffset = baseOffset;
	}
	
	public function set(offset:Int, value:Float):Void
	{
		//if (this.value == value) return;
		//this.value = value;
		Memory.setFloat(VertexData.basePosition + offset, value);
	}
}