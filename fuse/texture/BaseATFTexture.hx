package fuse.texture;
import fuse.utils.AtfData;
import openfl.display3D.Context3DTextureFormat;

import fuse.utils.AtfData.AtfDataInfo;
import fuse.texture.BaseTexture;
import fuse.core.front.texture.Textures;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.utils.ByteArray;

/**
 * ...
 * @author P.J.Shand
 */

@:forward(textureData, nativeTexture, textureBase, textureId, width, height, onUpdate, clearColour, _clear, _alreadyClear, upload, dispose, directRender)
abstract ATFTexture(AbstractTexture) to Int from Int 
{
	var baseATFTexture(get, never):BaseATFTexture;
	
	public function new(data:ByteArray, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		var baseATFTexture = new BaseATFTexture(AbstractTexture.textureIdCount++, data, queUpload, onTextureUploadCompleteCallback);
		this = new AbstractTexture(baseATFTexture, baseATFTexture.textureId);
	}
	
	function upload():Void										{ baseATFTexture.upload(); 					}
	function get_baseATFTexture():BaseATFTexture				{ return untyped this.coreTexture; 				}
	@:to public function toAbstractTexture():AbstractTexture	{ return this; 									}
}

@:access(fuse)
class BaseATFTexture extends BaseTexture
{
	var data:ByteArray;
	var atfDataInfo:AtfDataInfo;
	
	public function new(textureId:Int, data:ByteArray, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.data = data;
		atfDataInfo = AtfData.getInfo(data);
		if (!atfDataInfo.valid) {
			throw new Error("Invalid ATF format");
			return;
		}
		
		trace("atfDataInfo.format = " + atfDataInfo.format);
		
		//if (atfDataInfo.format != Context3DTextureFormat.BGRA) {
			//throw new Error("Only ATF BGRA format supported");
			//return;
		//}
		
		super(textureId, atfDataInfo.width, atfDataInfo.height, queUpload, onTextureUploadCompleteCallback);
	}
	
	override public function upload() 
	{
		textureData.textureBase = textureData.nativeTexture = Textures.context3D.createTexture(p2Width, p2Height, Context3DTextureFormat.BGRA, false);
		//createNativeTexture();
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
			if (atfDataInfo.format != Context3DTextureFormat.BGRA) {
				throw new Error("Only ATF BGRA format supported");
				return;
			}
		}
		
		
		//nativeTexture.uploadFromBitmapData(bitmapData, 0);
		//OnTextureUploadComplete(null);
		
		nativeTexture.addEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		nativeTexture.uploadCompressedTextureFromByteArray(data, 0, true);
		//OnTextureUploadComplete(null);
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