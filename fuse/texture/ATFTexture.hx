package fuse.texture;

import fuse.texture.AtfData.AtfDataInfo;
import fuse.texture.Texture;
import fuse.core.front.texture.Textures;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.utils.ByteArray;
//import openfl.display3D.textures.Texture as NativeTexture;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class ATFTexture extends Texture
{
	var data:ByteArray;
	var atfDataInfo:AtfDataInfo;
	
	public function new(data:ByteArray, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.data = data;
		atfDataInfo = AtfData.getInfo(data);
		if (!atfDataInfo.valid) {
			throw new Error("Invalid ATF format");
			return;
		}
		
		this.width = atfDataInfo.width;
		this.height = atfDataInfo.height;
		
		super(queUpload, onTextureUploadCompleteCallback);
	}
	
	override public function upload() 
	{
		createNativeTexture();
		update(data);
	}
	
	public function update(data:ByteArray) 
	{
		this.data = data;
		if (atfDataInfo == null || atfDataInfo.data != data) {
			atfDataInfo = AtfData.getInfo(data);
			if (!atfDataInfo.valid) {
				throw new Error("Invalid ATF format");
				return;
			}
		}
		
		
		//nativeTexture.uploadFromBitmapData(bitmapData, 0);
		//OnTextureUploadComplete(null);
		
		nativeTexture.addEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		nativeTexture.uploadCompressedTextureFromByteArray(data, 0, true);
	}
	
	//public function uploadFromBitmapData(source:BitmapData, miplevel:UInt = 0):Void
	//{
		//nativeTexture.uploadFromBitmapData(source, miplevel);
		//textureData.placed = 0;
	//}
	
	private function OnTextureUploadComplete(e:Event):Void 
	{
		nativeTexture.removeEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		
		textureData.placed = 0;
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
		if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
	}
}