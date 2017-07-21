package fuse.texture;

import fuse.texture.Texture;
import fuse.core.front.texture.Textures;
import openfl.display.BitmapData;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class BitmapTexture extends Texture
{
	var bitmapData:BitmapData;
	
	public function new(bitmapData:BitmapData, queUpload:Bool=true, onTextureUploadComplete:Void -> Void = null) 
	{
		this.bitmapData = bitmapData;
		this.width = bitmapData.width;
		this.height = bitmapData.height;
		
		super(queUpload, onTextureUploadComplete);
	}
	
	override public function upload() 
	{
		createNativeTexture();
		nativeTexture.uploadFromBitmapData(bitmapData, 0);
		Textures.registerTexture(textureId, this);
		textureData.textureAvailable = 1;
		if (onTextureUploadComplete != null) onTextureUploadComplete();
	}
}