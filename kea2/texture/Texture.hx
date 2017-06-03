package kea2.texture;
import kea.util.PowerOfTwo;
import kea2.core.texture.Textures;
import kea2.core.texture.upload.TextureUploader;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture as OpenFLTexture;
/**
 * ...
 * @author P.J.Shand
 */
class Texture
{
	static private var textureIdCount:Int = 0;
	
	public var textureId:Int;
	public var width:Int;
	public var height:Int;
	
	var bitmapData:BitmapData;
	var textureUploader:TextureUploader;
	var textureWidth:Int;
	var textureHeight:Int;
	
	public function new(bitmapData:BitmapData, queUpload:Bool=true) 
	{
		this.bitmapData = bitmapData;
		
		width = bitmapData.width;
		height = bitmapData.height;
		
		textureWidth = PowerOfTwo.getNextPowerOfTwo(width);
		textureHeight = PowerOfTwo.getNextPowerOfTwo(height);
		
		textureId = textureIdCount++;
		
		textureUploader = new TextureUploader(textureId, bitmapData, textureWidth, textureHeight, queUpload);
		textureUploader.onUploadComplete.add(OnTextureUploadComplete);
		
		if (queUpload) Textures.registerUploader(textureUploader);
		else textureUploader.upload();
	}
	
	function OnTextureUploadComplete() 
	{
		trace("OnTextureUploadComplete");
	}
	
}