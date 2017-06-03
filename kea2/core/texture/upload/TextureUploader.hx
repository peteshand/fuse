package kea2.core.texture.upload;
import msignal.Signal.Signal0;
import openfl.display.BitmapData;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.textures.Texture;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
class TextureUploader
{
	var width:Int;
	var height:Int;
	var bitmapData:BitmapData;
	public var textureId:Int;
	public var onUploadComplete:Signal0;
	
	public function new(textureId:Int, bitmapData:BitmapData, width:Int, height:Int, queUpload:Bool = true) 
	{
		this.bitmapData = bitmapData;
		this.height = height;
		this.width = width;
		this.textureId = textureId;
		
		onUploadComplete = new Signal0();
	}
	
	public function upload() 
	{
		var texture:Texture = Textures.context3D.createTexture(width, height, Context3DTextureFormat.BGRA, false, 0);
		texture.uploadFromBitmapData(bitmapData);
		Textures.registerTexture(textureId, texture);
		dispose();
		onUploadComplete.dispatch();
	}
	
	function dispose() 
	{
		bitmapData = null;
	}
}