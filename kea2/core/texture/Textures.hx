package kea2.core.texture;

import com.imagination.delay.EnterFrame;
import kea2.core.texture.upload.TextureUploadQue;
import kea2.texture.BitmapTexture;
import kea2.texture.Texture;
import openfl.display.BitmapData;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DTextureFormat;
//import openfl.display3D.textures.Texture as NativeTexture;
/**
 * ...
 * @author P.J.Shand
 */
class Textures
{
	static private var context3D:Context3D;
	static private var textures = new Map<Int, Texture>();
	static private var defaultId:Int;
	static private var textureCount:Int = 0;
	
	public function new() { }
	
	static public function init(context3D:Context3D) 
	{
		Textures.context3D = context3D;
		
		createDefaultTexture();
		
		EnterFrame.add(OnTick);
	}
	
	static private function OnTick(delta:Int) 
	{
		TextureUploadQue.check();
	}
	
	static private function createDefaultTexture() 
	{
		var bmd:BitmapData = new BitmapData(32, 32, true, 0x11000000);
		var defaultTexture:BitmapTexture = new BitmapTexture(bmd, false);
		defaultId = defaultTexture.textureId;
	}
	
	static public function registerTexture(textureId:Int, texture:Texture):Void
	{
		if (!textures.exists(textureId)) {
			textures.set(textureId, texture);
			textureCount++;
			trace("textureCount = " + textureCount);
		}
	}
	
	static inline public function getTexture(textureId:Int):Texture
	{
		return textures.get(getTextureId(textureId));
	}
	
	static public function getTextureId(textureId:Int):Int
	{
		if (textures.exists(textureId)){
			return textureId;
		}
		return defaultId;
	}
}