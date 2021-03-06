package fuse.core.front.texture;

import fuse.utils.AtfData;
import openfl.display3D.Context3DTextureFormat;
import fuse.utils.AtfData.AtfDataInfo;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.core.front.texture.Textures;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.utils.ByteArray;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class ATFTexture extends FrontBaseTexture {
	var data:ByteArray;
	var atfDataInfo:AtfDataInfo;

	public function new(data:ByteArray, queUpload:Bool = true, onTextureUploadCompleteCallback:Void->Void = null) {
		this.data = data;
		atfDataInfo = AtfData.getInfo(data);
		if (!atfDataInfo.valid) {
			throw new Error("Invalid ATF format");
			return;
		}

		trace("atfDataInfo.format = " + atfDataInfo.format);

		// if (atfDataInfo.format != Context3DTextureFormat.BGRA) {
		// throw new Error("Only ATF BGRA format supported");
		// return;
		// }

		super(atfDataInfo.width, atfDataInfo.height, queUpload, onTextureUploadCompleteCallback);
	}

	override public function upload() {
		textureData.textureBase = textureData.nativeTexture = Textures.context3D.createTexture(textureData.p2Width, textureData.p2Height,
			Context3DTextureFormat.BGRA, false);
		// createNativeTexture();
		update(data);
	}

	public function update(data:ByteArray) {
		this.data = data;
		if (atfDataInfo == null || atfDataInfo.data != data) {
			atfDataInfo = AtfData.getInfo(data);
			if (!atfDataInfo.valid) {
				throw new Error("Invalid ATF format");
				return;
			}
			if (atfDataInfo.format != Context3DTextureFormat.BGRA) {
				throw new Error("Only ATF BGRA format supported");
				return;
			}
		}

		// nativeTexture.uploadFromBitmapData(bitmapData, 0);
		// OnTextureUploadComplete(null);

		nativeTexture.addEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		nativeTexture.uploadCompressedTextureFromByteArray(data, 0, true);
		// OnTextureUploadComplete(null);
	}

	// public function uploadFromBitmapData(source:BitmapData, miplevel:UInt = 0):Void
	// {
	// nativeTexture.uploadFromBitmapData(source, miplevel);
	// textureData.placed = 0;
	// }

	private function OnTextureUploadComplete(e:Event):Void {
		nativeTexture.removeEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);

		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		textureAvailable = true;
		if (onTextureUploadCompleteCallback != null)
			onTextureUploadCompleteCallback();
		onUpload.dispatch();
	}
}
