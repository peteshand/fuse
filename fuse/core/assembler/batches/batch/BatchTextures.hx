package fuse.core.assembler.batches.batch;

import fuse.texture.TextureId;
import fuse.core.assembler.batches.batch.BatchTextures;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class BatchTextures {
	public var textureIds = new GcoArray<TextureId>([]);
	public var textureId1(get, null):TextureId;
	public var textureId2(get, null):TextureId;
	public var textureId3(get, null):TextureId;
	public var textureId4(get, null):TextureId;
	public var textureId5(get, null):TextureId;
	public var textureId6(get, null):TextureId;
	public var textureId7(get, null):TextureId;
	public var textureId8(get, null):TextureId;

	public function new() {}

	public function getTextureIndex(textureId:TextureId):Int {
		for (i in 0...textureIds.length) {
			if (textureId == textureIds[i])
				return i;
		}
		if (textureIds.length < PlatformSettings.MAX_TEXTURES) {
			textureIds.push(textureId);
			return textureIds.length - 1;
		}
		return -1;
	}

	public function toString():String {
		return cast textureIds;
	}

	public function clear() {
		textureIds.clear();
	}

	public function copyFrom(copyFrom:BatchTextures) {
		for (i in 0...copyFrom.textureIds.length) {
			textureIds[i] = copyFrom.textureIds[i];
		}
	}

	inline function get_textureId1():TextureId {
		if (textureIds.length > 0)
			return textureIds[0];
		return 0;
	}

	inline function get_textureId2():TextureId {
		if (textureIds.length > 1)
			return textureIds[1];
		return 0;
	}

	inline function get_textureId3():TextureId {
		if (textureIds.length > 2)
			return textureIds[2];
		return 0;
	}

	inline function get_textureId4():TextureId {
		if (textureIds.length > 3)
			return textureIds[3];
		return 0;
	}

	inline function get_textureId5():TextureId {
		if (textureIds.length > 4)
			return textureIds[4];
		return 0;
	}

	inline function get_textureId6():TextureId {
		if (textureIds.length > 5)
			return textureIds[5];
		return 0;
	}

	inline function get_textureId7():TextureId {
		if (textureIds.length > 6)
			return textureIds[6];
		return 0;
	}

	inline function get_textureId8():TextureId {
		if (textureIds.length > 7)
			return textureIds[7];
		return 0;
	}
}
