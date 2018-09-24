package fuse.core.front.texture;

import fuse.texture.BitmapTexture;
import openfl.display.BitmapData;

class DefaultTexture extends BitmapTexture
{
	public function new(bitmapData:BitmapData, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.persistent = 1;
		
		super(bitmapData, queUpload, onTextureUploadCompleteCallback);
		
		this.textureData.offsetU = 1 / bitmapData.width;
		this.textureData.offsetV = 1 / bitmapData.width;
		this.textureData.scaleU = (bitmapData.width - 2) / bitmapData.width;
		this.textureData.scaleV = (bitmapData.height - 2) / bitmapData.height;
		Fuse.current.workerSetup.updateTexture(objectId);
	}
	
	override public function dispose():Void
	{
		// Can't dispose DefaultTexture
	}
}