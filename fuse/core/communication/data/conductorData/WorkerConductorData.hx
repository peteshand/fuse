package fuse.core.communication.data.conductorData;

import fuse.Fuse;
import fuse.core.communication.data.MemoryBlock;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerConductorData {
	static public inline var FRAME_INDEX:Int = 0;
	static public inline var PROCESS_INDEX:Int = 4;
	static public inline var NUMBER_OF_BATCHES:Int = 8;
	static public inline var NUMBER_OF_RENDERABLES:Int = 12;
	static public inline var BUSY:Int = 16;
	static public inline var RENDER_TEXTURE_PROCESS_INDEX:Int = 20;
	static public inline var RENDER_TEXTURE_COUNT_INDEX:Int = 24;
	static public inline var ATLAS_TEXTURE_ID_1:Int = 28;
	static public inline var ATLAS_TEXTURE_ID_2:Int = 32;
	static public inline var ATLAS_TEXTURE_ID_3:Int = 36;
	static public inline var ATLAS_TEXTURE_ID_4:Int = 40;
	static public inline var ATLAS_TEXTURE_ID_5:Int = 44;
	static public inline var LAYER_CACHE_TEXTURE_ID_1:Int = 48;
	static public inline var LAYER_CACHE_TEXTURE_ID_2:Int = 52;
	static public inline var LAYER_CACHE_TEXTURE_ID_3:Int = 56;
	static public inline var LAYER_CACHE_TEXTURE_ID_4:Int = 60;
	static public inline var LAYER_CACHE_TEXTURE_ID_5:Int = 64;
	static public inline var CHANGE_AVAILABLE:Int = 68;
	static public inline var FRONT_STATIC_COUNT:Int = 72;
	static public inline var BACK_IS_STATIC:Int = 76;
	static public inline var NUM_TRIANGLES:Int = 80;
	static public inline var HIGHEST_NUM_TEXTURES:Int = 84;
	static public inline var NUM_RANGES:Int = 88;
	public static inline var BUFFER_SIZE:Int = 92;
	public static var memoryBlock:MemoryBlock;

	@:isVar public var frameIndex(get, set):Int = 0;
	@:isVar public var processIndex(get, set):Int = 0;
	@:isVar public var numberOfBatches(get, set):Int = 0;
	@:isVar public var numberOfRenderables(get, set):Int = 0;
	@:isVar public var busy(get, set):Int = 0;
	@:isVar public var renderTextureProcessIndex(get, set):Int = 0;
	@:isVar public var renderTextureCountIndex(get, set):Int = 0;
	@:isVar public var atlasTextureId1(get, set):Int = 0;
	@:isVar public var atlasTextureId2(get, set):Int = 0;
	@:isVar public var atlasTextureId3(get, set):Int = 0;
	@:isVar public var atlasTextureId4(get, set):Int = 0;
	@:isVar public var atlasTextureId5(get, set):Int = 0;
	@:isVar public var layerCacheTextureId1(get, set):Int = 0;
	@:isVar public var layerCacheTextureId2(get, set):Int = 0;
	@:isVar public var layerCacheTextureId3(get, set):Int = 0;
	@:isVar public var layerCacheTextureId4(get, set):Int = 0;
	@:isVar public var layerCacheTextureId5(get, set):Int = 0;

	// @:isVar public var isStatic(get, set):Int = 0;
	var _changeAvailable:Int = 0;

	@:isVar public var changeAvailable(get, set):Int = 0;

	var _frontStaticCount:Int = 0;

	@:isVar public var frontStaticCount(get, set):Int = 0;

	var _backIsStatic:Int = 0;

	@:isVar public var backIsStatic(get, set):Int = 0;
	@:isVar public var numTriangles(get, set):Int = 0;
	@:isVar public var highestNumTextures(get, set):Int;
	@:isVar public var numRanges(get, set):Int;

	public function new() {
		if (memoryBlock == null) {
			memoryBlock = Fuse.current.sharedMemory.conductorDataPool.createMemoryBlock(WorkerConductorData.BUFFER_SIZE, 0);
		}
	}

	inline function get_frameIndex():Int {
		return memoryBlock.readInt(FRAME_INDEX);
	}

	inline function get_processIndex():Int {
		return memoryBlock.readInt(PROCESS_INDEX);
	}

	inline function get_numberOfBatches():Int {
		return memoryBlock.readInt(NUMBER_OF_BATCHES);
	}

	inline function get_numberOfRenderables():Int {
		return memoryBlock.readInt(NUMBER_OF_RENDERABLES);
	}

	inline function get_busy():Int {
		return memoryBlock.readInt(BUSY);
	}

	inline function get_renderTextureProcessIndex():Int {
		return memoryBlock.readInt(RENDER_TEXTURE_PROCESS_INDEX);
	}

	inline function get_renderTextureCountIndex():Int {
		return memoryBlock.readInt(RENDER_TEXTURE_COUNT_INDEX);
	}

	inline function get_atlasTextureId1():Int {
		return memoryBlock.readInt(ATLAS_TEXTURE_ID_1);
	}

	inline function get_atlasTextureId2():Int {
		return memoryBlock.readInt(ATLAS_TEXTURE_ID_2);
	}

	inline function get_atlasTextureId3():Int {
		return memoryBlock.readInt(ATLAS_TEXTURE_ID_3);
	}

	inline function get_atlasTextureId4():Int {
		return memoryBlock.readInt(ATLAS_TEXTURE_ID_4);
	}

	inline function get_atlasTextureId5():Int {
		return memoryBlock.readInt(ATLAS_TEXTURE_ID_5);
	}

	inline function get_layerCacheTextureId1():Int {
		return memoryBlock.readInt(LAYER_CACHE_TEXTURE_ID_1);
	}

	inline function get_layerCacheTextureId2():Int {
		return memoryBlock.readInt(LAYER_CACHE_TEXTURE_ID_2);
	}

	inline function get_layerCacheTextureId3():Int {
		return memoryBlock.readInt(LAYER_CACHE_TEXTURE_ID_3);
	}

	inline function get_layerCacheTextureId4():Int {
		return memoryBlock.readInt(LAYER_CACHE_TEXTURE_ID_4);
	}

	inline function get_layerCacheTextureId5():Int {
		return memoryBlock.readInt(LAYER_CACHE_TEXTURE_ID_5);
	}

	inline function get_changeAvailable():Int {
		return memoryBlock.readInt(CHANGE_AVAILABLE);
	}

	inline function get_frontStaticCount():Int {
		return memoryBlock.readInt(FRONT_STATIC_COUNT);
	}

	inline function get_backIsStatic():Int {
		return memoryBlock.readInt(BACK_IS_STATIC);
	}

	inline function get_numTriangles():Int {
		return memoryBlock.readInt(NUM_TRIANGLES);
	}

	inline function get_highestNumTextures():Int {
		return memoryBlock.readInt(HIGHEST_NUM_TEXTURES);
	}

	inline function get_numRanges():Int {
		return memoryBlock.readInt16(NUM_RANGES);
	}

	inline function set_frameIndex(value:Int):Int {
		memoryBlock.writeInt(FRAME_INDEX, value);
		return value;
	}

	inline function set_processIndex(value:Int):Int {
		memoryBlock.writeInt(PROCESS_INDEX, value);
		return value;
	}

	inline function set_numberOfBatches(value:Int):Int {
		memoryBlock.writeInt(NUMBER_OF_BATCHES, value);
		return value;
	}

	inline function set_numberOfRenderables(value:Int):Int {
		memoryBlock.writeInt(NUMBER_OF_RENDERABLES, value);
		return value;
	}

	inline function set_busy(value:Int):Int {
		memoryBlock.writeInt(BUSY, value);
		return value;
	}

	inline function set_renderTextureProcessIndex(value:Int):Int {
		memoryBlock.writeInt(RENDER_TEXTURE_PROCESS_INDEX, value);
		return value;
	}

	inline function set_renderTextureCountIndex(value:Int):Int {
		memoryBlock.writeInt(RENDER_TEXTURE_COUNT_INDEX, value);
		return value;
	}

	inline function set_atlasTextureId1(value:Int):Int {
		memoryBlock.writeInt(ATLAS_TEXTURE_ID_1, value);
		return value;
	}

	inline function set_atlasTextureId2(value:Int):Int {
		memoryBlock.writeInt(ATLAS_TEXTURE_ID_2, value);
		return value;
	}

	inline function set_atlasTextureId3(value:Int):Int {
		memoryBlock.writeInt(ATLAS_TEXTURE_ID_3, value);
		return value;
	}

	inline function set_atlasTextureId4(value:Int):Int {
		memoryBlock.writeInt(ATLAS_TEXTURE_ID_4, value);
		return value;
	}

	inline function set_atlasTextureId5(value:Int):Int {
		memoryBlock.writeInt(ATLAS_TEXTURE_ID_5, value);
		return value;
	}

	inline function set_layerCacheTextureId1(value:Int):Int {
		memoryBlock.writeInt(LAYER_CACHE_TEXTURE_ID_1, value);
		return value;
	}

	inline function set_layerCacheTextureId2(value:Int):Int {
		memoryBlock.writeInt(LAYER_CACHE_TEXTURE_ID_2, value);
		return value;
	}

	inline function set_layerCacheTextureId3(value:Int):Int {
		memoryBlock.writeInt(LAYER_CACHE_TEXTURE_ID_3, value);
		return value;
	}

	inline function set_layerCacheTextureId4(value:Int):Int {
		memoryBlock.writeInt(LAYER_CACHE_TEXTURE_ID_4, value);
		return value;
	}

	inline function set_layerCacheTextureId5(value:Int):Int {
		memoryBlock.writeInt(LAYER_CACHE_TEXTURE_ID_5, value);
		return value;
	}

	inline function set_changeAvailable(value:Int):Int {
		if (value == _changeAvailable)
			return value;
		_changeAvailable = value;
		memoryBlock.writeInt(CHANGE_AVAILABLE, value);
		return value;
	}

	inline function set_frontStaticCount(value:Int):Int {
		if (value == _frontStaticCount)
			return value;
		_frontStaticCount = value;
		memoryBlock.writeInt(FRONT_STATIC_COUNT, value);
		return value;
	}

	inline function set_backIsStatic(value:Int):Int {
		if (value == _backIsStatic)
			return value;
		_backIsStatic = value;
		memoryBlock.writeInt(BACK_IS_STATIC, value);
		return value;
	}

	inline function set_numTriangles(value:Int):Int {
		memoryBlock.writeInt(NUM_TRIANGLES, value);
		return value;
	}

	inline function set_highestNumTextures(value:Int):Int {
		memoryBlock.writeInt(HIGHEST_NUM_TEXTURES, value);
		return value;
	}

	inline function set_numRanges(value:Int):Int {
		memoryBlock.writeInt16(NUM_RANGES, value);
		return value;
	}
}
