package fuse.core.front.texture;

import fuse.core.front.texture.BlankBmd;
import fuse.texture.DefaultTexture;
import openfl.Lib;
import fuse.core.front.buffers.AtlasBuffers;
import fuse.core.front.buffers.LayerCacheBuffers;
import fuse.core.front.texture.upload.TextureUploadQue;
import openfl.display.BitmapData;
import openfl.display3D.Context3D;
import openfl.display3D.textures.TextureBase;
import openfl.events.Event;
import fuse.core.front.texture.IFrontTexture;
import fuse.geom.Rectangle;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.front.buffers.AtlasBuffers)
@:access(fuse.core.front.buffers.LayerCacheBuffers)
@:access(fuse.core.front.texture)
class Textures {
	static private var context3D:Context3D;
	static public var textures = new Map<Int, IFrontTexture>();
	static private var blankId:Int = 0;
	static private var whiteId:Int = 1;
	static private var errorId:Int = 2;
	static private var textureCount:Int = 0;
	static public var whiteTexture:DefaultTexture;
	static public var blankTexture:DefaultTexture;

	public function new() {}

	static public function init(context3D:Context3D) {
		Textures.context3D = context3D;

		createDefaultTextures();

		Lib.current.addEventListener(Event.ENTER_FRAME, OnTick);
	}

	static private function OnTick(e:Event) {
		TextureUploadQue.check();
	}

	static private function createDefaultTextures() {
		blankTexture = new DefaultTexture(new BlankBmd(), false);
		// blankTexture = new DefaultTexture(new BitmapData(8, 8, true, 0xFFFF0000), false);
		// trace("blankTexture.textureId = " + blankTexture.textureId);

		// var white:BitmapData = new BitmapData(64, 64, true, 0x00000000);
		// white.fillRect(new Rectangle(2, 2, white.width-4, white.height-4), 0xFFFFFFFF);
		// whiteTexture = new DefaultTexture(white, false);

		whiteTexture = new DefaultTexture(new BitmapData(128, 128, true, 0xFFFFFFFF), false);
		// trace("whiteTexture.textureId = " + whiteTexture.textureId);
	}

	static public function registerTexture(textureId:Int, texture:IFrontTexture):Void {
		if (!textures.exists(textureId)) {
			textures.set(textureId, texture);
			textureCount++;
			// trace("textureCount = " + textureCount);
			// trace("frontStaticCount = 0");
			Fuse.current.conductorData.frontStaticCount = 0;
		}
	}

	static public function deregisterTexture(textureId:Int, texture:IFrontTexture) {
		if (textureId == 0) {
			trace("deregisterTexture: " + textureId);
		}

		if (textures.exists(textureId)) {
			textures.remove(textureId);
		}
	}

	static inline public function getTextureBase(textureId:Null<Int>):TextureBase {
		if (textureId == null)
			return null;

		var texture:IFrontTexture = getTexture(textureId);
		if (texture == null) {
			// trace("No texture found for textureId: " + textureId);
			return null;
		}
		// if (texture.textureBase == null) trace("texture.textureBase = null");
		return texture.textureBase;
	}

	static inline public function getTexture(textureId:Int):IFrontTexture {
		return textures.get(getTextureId(textureId));
	}

	static public function getTextureId(textureId:Null<Int>):Null<Int> {
		if (textureId == -1)
			return -1;
		if (textureId == null)
			return null;
		if (textures.exists(textureId))
			return textureId;

		if (textureId >= AtlasBuffers.startIndex && textureId < AtlasBuffers.endIndex) {
			AtlasBuffers.create(textureId);
			// recheck
			if (textures.exists(textureId))
				return textureId;
		} else if (textureId >= LayerCacheBuffers.startIndex && textureId < LayerCacheBuffers.endIndex) {
			LayerCacheBuffers.create(textureId);
			// recheck
			if (textures.exists(textureId))
				return textureId;
		}
		// still can't find textureId, default to blankId
		return blankId;
	}
}
