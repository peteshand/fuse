package fuse.core.front.texture;

import fuse.core.front.texture.BitmapTexture;
import openfl.display.BitmapData;

class DefaultTexture extends BitmapTexture
{
	public function new(bitmapData:BitmapData, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.persistent = 1;
		
		super(bitmapData, queUpload, onTextureUploadCompleteCallback);
		
		this.offsetU = 1 / bitmapData.width;
		this.offsetV = 1 / bitmapData.width;
		this.scaleU = (bitmapData.width - 2) / bitmapData.width;
		this.scaleV = (bitmapData.height - 2) / bitmapData.height;
	}
	
	override public function dispose():Void
	{
		// Can't dispose DefaultTexture
	}
}