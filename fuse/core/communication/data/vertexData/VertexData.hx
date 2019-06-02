package fuse.core.communication.data.vertexData;

import fuse.Fuse;
import fuse.core.render.shaders.FShader;
import fuse.utils.Color;
import fuse.core.communication.memory.Memory;

/**
 * ...
 * @author P.J.Shand
 */
class VertexData implements IVertexData {
	@:isVar public static var OBJECT_POSITION(get, set):Int = 0;
	public static var BUFFER_SIZE:Int = 10000;
	static var poolStartPosition(get, null):Int;
	static var _basePosition:Int = 0;
	public static var basePosition(get, null):Int = 0;
	// new order
	public static inline var INDEX_X:Int = 0;
	public static inline var INDEX_Y:Int = 4;
	public static inline var INDEX_AA_M:Int = 8;
	public static inline var INDEX_TEXTURE:Int = 12;
	public static inline var INDEX_ALPHA:Int = 16;
	public static inline var INDEX_U:Int = 20;
	public static inline var INDEX_V:Int = 24;
	public static inline var INDEX_COLOR:Int = 28;
	public static inline var VERTEX_X:Int = 32;
	public static inline var VERTEX_Y:Int = 36;
	public static inline var VERTEX_WIDTH:Int = 40;
	public static inline var VERTEX_HEIGHT:Int = 44;
	public static inline var INDEX_MU:Int = 48;
	public static inline var INDEX_MV:Int = 52;
	public static inline var INDEX_MASK_TEXTURE:Int = 56;
	public static inline var INDEX_MASK_BASE_VALUE:Int = 60;
	public static inline var BYTES_PER_VALUE:Int = 4;
	public static var VALUES_PER_VERTEX(get, null):Int;
	public static var BYTES_PER_VERTEX(get, null):Int; // = BYTES_PER_VALUE * VALUES_PER_VERTEX;
	public static var BYTES_PER_ITEM:Int = BYTES_PER_VERTEX * 4;

	public function new() {
		// poolStartPosition = Fuse.current.sharedMemory.vertexDataPool.start;
	}

	inline public function setRect(index:Int, x:Float, y:Float, width:Float = -1, height:Float = -1, rotation:Float = 0):Void {
		writeFloat(INDEX_X + indexOffset(index), x);
		writeFloat(INDEX_Y + indexOffset(index), y);

		// trace("index = " + index);

		var _x:Float = Math.floor(index / 2);
		var _y:Float = Math.floor(((index + 3) % 4) / 2);
		// _x *= width - 1;
		// _y *= height - 1;

		// trace([_x * width, _y * height]);
		var amp:Float = 1000;
		// var m:Float = Math.sin(rotation / 180 * Math.PI * 2);
		var r1:Float = rotation % 90;
		if (r1 < 0)
			r1 += 90;
		var m:Float = Math.sin(r1 / 180 * Math.PI * 2);
		m = Math.pow(m, 0.00001);
		m = ((Math.abs(m) - 1) * -amp) + 1;
		// m = (Math.abs(m) * -1) + 2;
		// trace([rotation, r1, m]);

		writeFloat(INDEX_AA_M + indexOffset(index), m);

		// TODO: take into account if texture isn't baked into atlas buffer
		if (width > height) {
			writeFloat(VERTEX_WIDTH + indexOffset(index), height);
			writeFloat(VERTEX_HEIGHT + indexOffset(index), width);

			writeFloat(VERTEX_X + indexOffset(index), _x * height);
			writeFloat(VERTEX_Y + indexOffset(index), _y * width);
		} else {
			writeFloat(VERTEX_WIDTH + indexOffset(index), width);
			writeFloat(VERTEX_HEIGHT + indexOffset(index), height);

			writeFloat(VERTEX_X + indexOffset(index), _x * width);
			writeFloat(VERTEX_Y + indexOffset(index), _y * height);
		}
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	inline public function setUV(index:Int, u:Float, v:Float):Void {
		writeFloat(INDEX_U + indexOffset(index), u);
		writeFloat(INDEX_V + indexOffset(index), v);

		// setU(index, u);
		// setV(index, v);
	}

	// inline function setU(index:Int, value:Float):Void { writeFloat(INDEX_U + indexOffset(index), value); }
	// inline function setV(index:Int, value:Float):Void { writeFloat(INDEX_V + indexOffset(index), value); }
	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	inline public function setMaskUV(index:Int, u:Float, v:Float):Void {
		setMaskU(index, u);
		setMaskV(index, v);
	}

	inline function setMaskU(index:Int, value:Float):Void {
		writeFloat(INDEX_MU + indexOffset(index), value);
	}

	inline function setMaskV(index:Int, value:Float):Void {
		writeFloat(INDEX_MV + indexOffset(index), value);
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	inline public function setTexture(value:Float):Void {
		for (i in 0...4)
			writeFloat(INDEX_TEXTURE + indexOffset(i), value);
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	public function setMaskTexture(value:Float):Void {
		for (i in 0...4)
			writeFloat(INDEX_MASK_TEXTURE + indexOffset(i), value);
		if (value == -1)
			setMaskBaseValue(1);
		else
			setMaskBaseValue(0);
	}

	inline function setMaskBaseValue(value:Float):Void {
		for (i in 0...4)
			writeFloat(INDEX_MASK_BASE_VALUE + indexOffset(i), value);
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	inline public function setAlpha(value:Float):Void {
		for (i in 0...4)
			writeFloat(INDEX_ALPHA + indexOffset(i), 1 - value); // write inverted alpha
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	inline public function setColor(index:Int, value:Color):Void {
		writeInt32(INDEX_COLOR + indexOffset(index), value);
	}

	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////

	inline function indexOffset(index:Int):Int {
		return index * BYTES_PER_VERTEX;
	}

	inline function readFloat(offset:Int):Float {
		return Memory.getFloat(VertexData.basePosition + offset);
	}

	inline function writeFloat(offset:Int, value:Float):Void {
		Memory.setFloat(VertexData.basePosition + offset, value);
	}

	inline function writeInt32(offset:Int, value:UInt):Void {
		Memory.setI32(VertexData.basePosition + offset, value);
	}

	inline function writeInt16(offset:Int, value:UInt):Void {
		Memory.setI16(VertexData.basePosition + offset, value);
	}

	static inline function get_OBJECT_POSITION():Int {
		return VertexData.OBJECT_POSITION;
	}

	static inline function set_OBJECT_POSITION(value:Int):Int {
		VertexData.OBJECT_POSITION = value;
		VertexData._basePosition = poolStartPosition + (VertexData.OBJECT_POSITION * VertexData.BYTES_PER_ITEM);
		return value;
	}

	static inline function get_basePosition():Int {
		return _basePosition;
	}

	static inline function get_BYTES_PER_VERTEX():Int {
		return VALUES_PER_VERTEX * BYTES_PER_VALUE;
		// if (FShader.ENABLE_MASKS) return INDEX_MASK_BASE_VALUE + BYTES_PER_VALUE;
		// else return INDEX_COLOR + BYTES_PER_VALUE;
	}

	static inline function get_VALUES_PER_VERTEX():Int {
		if (FShader.ENABLE_MASKS)
			return 16;
		else
			return INDEX_COLOR + 12;
	}

	static inline function get_poolStartPosition():Int {
		return Fuse.current.sharedMemory.vertexDataPool.start;
	}
}
