package kea2.texture;

import kea2.core.texture.Textures;
import kea2.texture.Texture;
import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.textures.Texture as NativeTexture;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
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