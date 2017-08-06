package fuse.texture;

import fuse.texture.Texture;
import fuse.core.front.texture.Textures;
import openfl.display.BitmapData;
import openfl.events.Event;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class BitmapTexture extends Texture
{
	var bitmapData:BitmapData;
	
	public function new(bitmapData:BitmapData, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.bitmapData = bitmapData;
		this.width = bitmapData.width;
		this.height = bitmapData.height;
		
		super(queUpload, onTextureUploadCompleteCallback);
	}
	
	override public function upload() 
	{
		createNativeTexture();
		
		nativeTexture.uploadFromBitmapData(bitmapData, 0);
		OnTextureUploadComplete(null);
		
		//nativeTexture.addEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		//nativeTexture.uploadFromBitmapDataAsync(bitmapData, 0);
		
	}
	
	private function OnTextureUploadComplete(e:Event):Void 
	{
		nativeTexture.removeEventListener(Event.TEXTURE_READY, OnTextureUploadComplete);
		
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
		if (onTextureUploadCompleteCallback != null) onTextureUploadCompleteCallback();
	}
}