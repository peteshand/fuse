package fuse.texture;

import fuse.texture.BaseTexture;
import fuse.core.front.texture.Textures;
import openfl.display.BitmapData;
import openfl.events.Event;
/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse)
class BitmapTexture extends BaseTexture
{
	var bitmapData:BitmapData;
	
	public function new(bitmapData:BitmapData, ?width:Int, ?height:Int, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null, overTextureId:Null<Int>=null) 
	{
		this.bitmapData = bitmapData;
		
		var w:Int = width;
		if (width == null) w = bitmapData.width;
		
		var h:Int = height;
		if (width == null) h = bitmapData.height;
		
		super(w, h, queUpload, onTextureUploadCompleteCallback, true, overTextureId);
	}
	
	override public function upload() 
	{
		createNativeTexture();
		update(bitmapData);
	}
	
	public function update(source:BitmapData) 
	{
		this.bitmapData = source;
		
		//var uploadFromBitmapDataAsync:BitmapData -> Int -> Void = Reflect.getProperty(nativeTexture, "uploadFromBitmapDataAsync");
		//if (uploadFromBitmapDataAsync != null) {
		//	nativeTexture.addEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		//	uploadFromBitmapDataAsync(bitmapData, 0);
		//}
		//else {
			nativeTexture.uploadFromBitmapData(bitmapData, 0);
			OnTextureUploadComplete(null);
		//}
	}
	
	//public function uploadFromBitmapData(source:BitmapData, miplevel:UInt = 0):Void
	//{
		//nativeTexture.uploadFromBitmapData(source, miplevel);
		//textureData.placed = 0;
	//}
	
	private function OnTextureUploadComplete(e:Event):Void 
	{
		nativeTexture.removeEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		textureData.changeCount++;
		textureData.placed = 0;
		Textures.registerTexture(objectId, this);
		textureData.textureAvailable = 1;
		
		Fuse.current.conductorData.frontStaticCount = 0;
		
		if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
		onUpload.dispatch();
	}
}