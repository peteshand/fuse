package kea2.core.texture;

import com.imagination.delay.EnterFrame;
import kea2.core.texture.upload.TextureUploader;
import kea2.texture.Texture as KeaTexture;
import openfl.display.BitmapData;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.textures.Texture;

/**
 * ...
 * @author P.J.Shand
 */
class Textures
{
	static private var context3D:Context3D;
	static private var textures = new Map<Int, Texture>();
	static private var defaultId:Int;
	static private var textureUploaders:Array<TextureUploader> = [];
	
	public function new() { }
	
	static public function init(context3D:Context3D) 
	{
		Textures.context3D = context3D;
		
		createDefaultTexture();
		
		EnterFrame.add(OnTick);
	}
	
	static private function OnTick(delta:Int) 
	{
		if (textureUploaders.length > 0) {
			// Upload one at a time
			var textureUploader:TextureUploader = textureUploaders.shift();
			textureUploader.upload();
		}
	}
	
	static private function createDefaultTexture() 
	{
		var bmd:BitmapData = new BitmapData(32, 32, true, 0x55FF0000);
		var defaultTexture:KeaTexture = new KeaTexture(bmd, false);
		defaultId = defaultTexture.textureId;
	}
	
	static public function registerTexture(textureId:Int, texture:Texture):Void
	{
		textures.set(textureId, texture);
	}
	
	static public function getTexture(textureId:Int):Texture
	{
		if (textures.exists(textureId)){
			return textures.get(textureId);
		}
		return textures.get(defaultId);
	}	
	
	static public function registerUploader(textureUploader:TextureUploader) 
	{
		textureUploaders.push(textureUploader);
	}
}