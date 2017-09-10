package fuse.core.front.texture;

import fuse.core.front.atlas.AtlasBuffers;
import fuse.core.front.layers.LayerCacheBuffers;
import fuse.core.front.texture.upload.TextureUploadQue;
import fuse.texture.BitmapTexture;
import fuse.texture.Texture;
import openfl.display.BitmapData;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DTextureFormat;
//import openfl.display3D.textures.Texture as NativeTexture;
/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.core.front.atlas.AtlasBuffers)
@:access(fuse.core.front.layers.LayerCacheBuffers)

class Textures
{
	static private var context3D:Context3D;
	static private var textures = new Map<Int, Texture>();
	static private var blankId:Int;
	static private var whiteId:Int;
	static private var textureCount:Int = 0;
	
	public function new() { }
	
	static public function init(context3D:Context3D) 
	{
		Textures.context3D = context3D;
		
		createDefaultTextures();
		
		Fuse.enterFrame.add(OnTick);
	}
	
	static private function OnTick() 
	{
		TextureUploadQue.check();
	}
	
	static private function createDefaultTextures() 
	{
		var blank:BitmapData = new BitmapData(32, 32, true, 0x00000000);
		var blankTexture:BitmapTexture = new BitmapTexture(blank, false);
		blankId = blankTexture.textureId;
		
		var white:BitmapData = new BitmapData(32, 32, true, 0xFFFFFFFF);
		var whiteTexture:BitmapTexture = new BitmapTexture(white, false);
		whiteId = whiteTexture.textureId;
	}
	
	static public function registerTexture(textureId:Int, texture:Texture):Void
	{
		if (!textures.exists(textureId)) {
			textures.set(textureId, texture);
			textureCount++;
			//trace("textureCount = " + textureCount);
		}
	}
	
	static public function deregisterTexture(textureId:Int, texture:Texture) 
	{
		if (textures.exists(textureId)) {
			textures.remove(textureId);
		}
	}
	
	static inline public function getTexture(textureId:Int):Texture
	{
		return textures.get(getTextureId(textureId));
	}
	
	static public function getTextureId(textureId:Int):Int
	{
		if (textureId == -1) return -1;
		if (textures.exists(textureId)) return textureId;
		
		if (textureId >= AtlasBuffers.startIndex && textureId < AtlasBuffers.endIndex) {
			AtlasBuffers.create(textureId);
			// recheck
			if (textures.exists(textureId)) return textureId;
		}
		else if (textureId >= LayerCacheBuffers.startIndex && textureId < LayerCacheBuffers.endIndex) {
			LayerCacheBuffers.create(textureId);
			// recheck
			if (textures.exists(textureId)) return textureId;
		}
		// still can't find textureId, default to blankId
		return blankId;
	}
}