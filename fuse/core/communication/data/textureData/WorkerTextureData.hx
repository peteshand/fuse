package fuse.core.communication.data.textureData;

import fuse.texture.TextureId;
import fuse.Fuse;
import fuse.core.communication.data.MemoryBlock;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import fuse.utils.ObjectId;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerTextureData {
	public static var BUFFER_SIZE:Int = 10000;
	static inline var X:Int = 0;
	static inline var Y:Int = 2;
	static inline var WIDTH:Int = 4;
	static inline var HEIGHT:Int = 6;
	static inline var P2_WIDTH:Int = 8;
	static inline var P2_HEIGHT:Int = 10;
	static inline var OFFSET_U:Int = 12;
	static inline var OFFSET_V:Int = 16;
	static inline var SCALE_U:Int = 20;
	static inline var SCALE_V:Int = 24;
	static inline var TEXTURE_AVAILABLE:Int = 28;
	static inline var TEXTURE_PLACED:Int = 30;
	static inline var TEXTURE_PERSISTENT:Int = 32;
	static inline var TEXTURE_DIRECT_RENDER:Int = 34;
	static inline var ATLAS_BATCH_TEXTURE_INDEX:Int = 36;
	static inline var CHANGE_COUNT:Int = 38;
	// static inline var TEXTURE_ID:Int = 40;
	public static inline var BYTES_PER_ITEM:Int = 40;

	public var memoryBlock:MemoryBlock;
	// public var rotate:Bool = false;
	// Backend Props
	// public var objectId:ObjectId;
	// public var textureId:TextureId;
	public var x(get, set):Int;
	public var y(get, set):Int;
	public var width(get, set):Int;
	public var height(get, set):Int;
	public var p2Width(get, set):Int;
	public var p2Height(get, set):Int;
	public var offsetU(get, set):Float;
	public var offsetV(get, set):Float;
	public var scaleU(get, set):Float;
	public var scaleV(get, set):Float;
	public var activeData:TextureSizeData; // points to the active TextureSizeData
	public var baseData:TextureSizeData; // stores data about the source texture
	public var atlasData:TextureSizeData; // stores data about the dynamic texture atlas
	public var textureId:TextureId;
	// public var textureAvailable(get, set):Int;
	public var placed(get, set):Int;
	public var persistent(get, set):Int;
	public var directRender(get, set):Int;
	// public var atlasBatchTextureIndex(get, set):Int;
	// public var changeCount(get, set):Int;
	public var area(get, null):Float;
	// Shared Props
	public var nativeTexture:Texture;
	public var textureBase:TextureBase;

	public function new(objectId:ObjectId) {
		baseData = {
			objectId: objectId,
			textureId: 0,
			x: 0,
			y: 0,
			width: 0,
			height: 0,
			p2Width: 0,
			p2Height: 0,
			offsetU: 0,
			offsetV: 0,
			scaleU: 1,
			scaleV: 1
		};
		atlasData = {
			objectId: objectId,
			textureId: 0,
			x: 0,
			y: 0,
			width: 0,
			height: 0,
			p2Width: 0,
			p2Height: 0,
			offsetU: 0,
			offsetV: 0,
			scaleU: 1,
			scaleV: 1
		};

		activeData = baseData;
		// textureAvailable = 0;

		// objectId = objectOffset;
		memoryBlock = Fuse.current.sharedMemory.textureDataPool.createMemoryBlock(WorkerTextureData.BYTES_PER_ITEM, objectId);
		// atlasTextureId = objectId;
	}

	public function dispose():Void {
		if (textureBase != null) {
			textureBase.dispose();
			textureBase = null;
		}
	}

	inline function get_x():Int {
		return memoryBlock.readInt16(X);
	}

	inline function get_y():Int {
		return memoryBlock.readInt16(Y);
	}

	inline function get_width():Int {
		return memoryBlock.readInt16(WIDTH);
	}

	inline function get_height():Int {
		return memoryBlock.readInt16(HEIGHT);
	}

	inline function get_p2Width():Int {
		return memoryBlock.readInt16(P2_WIDTH);
	}

	inline function get_p2Height():Int {
		return memoryBlock.readInt16(P2_HEIGHT);
	}

	inline function get_offsetU():Float {
		return memoryBlock.readFloat(OFFSET_U);
	}

	inline function get_offsetV():Float {
		return memoryBlock.readFloat(OFFSET_V);
	}

	inline function get_scaleU():Float {
		return memoryBlock.readFloat(SCALE_U);
	}

	inline function get_scaleV():Float {
		return memoryBlock.readFloat(SCALE_V);
	}

	inline function get_textureAvailable():Int {
		return memoryBlock.readInt16(TEXTURE_AVAILABLE);
	}

	inline function get_placed():Int {
		return memoryBlock.readInt16(TEXTURE_PLACED);
	}

	inline function get_persistent():Int {
		return memoryBlock.readInt16(TEXTURE_PERSISTENT);
	}

	inline function get_directRender():Int {
		return memoryBlock.readInt16(TEXTURE_DIRECT_RENDER);
	}

	// inline function get_atlasBatchTextureIndex():Int {
	// return memoryBlock.readInt16(ATLAS_BATCH_TEXTURE_INDEX);
	// }

	inline function get_changeCount():Int {
		return memoryBlock.readInt16(CHANGE_COUNT);
	}

	/*inline function get_textureId():TextureId { 
		return new TextureId(memoryBlock.readInt16(TEXTURE_ID));
	}*/
	inline function set_x(value:Int):Int {
		memoryBlock.writeInt16(X, value);
		return value;
	}

	inline function set_y(value:Int):Int {
		memoryBlock.writeInt16(Y, value);
		return value;
	}

	inline function set_width(value:Int):Int {
		memoryBlock.writeInt16(WIDTH, value);
		return value;
	}

	inline function set_height(value:Int):Int {
		memoryBlock.writeInt16(HEIGHT, value);
		return value;
	}

	inline function set_p2Width(value:Int):Int {
		memoryBlock.writeInt16(P2_WIDTH, value);
		return value;
	}

	inline function set_p2Height(value:Int):Int {
		memoryBlock.writeInt16(P2_HEIGHT, value);
		return value;
	}

	inline function set_offsetU(value:Float):Float {
		memoryBlock.writeFloat(OFFSET_U, value);
		return value;
	}

	inline function set_offsetV(value:Float):Float {
		memoryBlock.writeFloat(OFFSET_V, value);
		return value;
	}

	inline function set_scaleU(value:Float):Float {
		memoryBlock.writeFloat(SCALE_U, value);
		return value;
	}

	inline function set_scaleV(value:Float):Float {
		memoryBlock.writeFloat(SCALE_V, value);
		return value;
	}

	inline function set_textureAvailable(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_AVAILABLE, value);
		return value;
	}

	inline function set_placed(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_PLACED, value);
		return value;
	}

	inline function set_persistent(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_PERSISTENT, value);
		return value;
	}

	inline function set_directRender(value:Int):Int {
		memoryBlock.writeInt16(TEXTURE_DIRECT_RENDER, value);
		return value;
	}

	// inline function set_atlasBatchTextureIndex(value:Int):Int {
	// memoryBlock.writeInt16(ATLAS_BATCH_TEXTURE_INDEX, value);
	// return value;
	// }

	inline function set_changeCount(value:Int):Int {
		memoryBlock.writeInt16(CHANGE_COUNT, value);
		return value;
	}

	/*inline function set_textureId(value:TextureId):TextureId { 
		baseData.textureId = value;
		atlasData.textureId = value;
		memoryBlock.writeInt16(TEXTURE_ID, value);
		return value;
	}*/
	public function toString():String {
		return "objectId = " + baseData.textureId + ", atlasIndex = " + atlasData.textureId + " - (" + activeData.x + ", " + activeData.y + ", "
			+ activeData.width + ", " + activeData.height + ")";
	}

	inline function get_area():Float {
		return activeData.width * activeData.height;
	}
}
