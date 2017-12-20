package fuse.texture;

import fuse.texture.Texture;
import fuse.core.front.texture.Textures;
import openfl.display.BitmapData;
import openfl.events.Event;
//import openfl.display3D.textures.Texture as NativeTexture;
/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class BitmapTexture extends Texture
{
	var bitmapData:BitmapData;
	
	public function new(bitmapData:BitmapData, ?width:Int, ?height:Int, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.bitmapData = bitmapData;
		
		if (width == null) this.width = bitmapData.width;
		else this.width = width;
		
		if (height == null) this.height = bitmapData.height;
		else this.height = height;
		
		super(queUpload, onTextureUploadCompleteCallback);
	}
	
	override public function upload() 
	{
		createNativeTexture();
		update(bitmapData);
	}
	
	public function update(source:BitmapData) 
	{
		this.bitmapData = source;
		
		nativeTexture.uploadFromBitmapData(bitmapData, 0);
		OnTextureUploadComplete(null);
		
		//nativeTexture.addEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		//nativeTexture.uploadFromBitmapDataAsync(bitmapData, 0);
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