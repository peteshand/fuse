package fuse.core.front.texture;

import fuse.core.front.buffers.AtlasBuffers;
import fuse.core.front.buffers.LayerCacheBuffers;
import fuse.core.front.texture.upload.TextureUploadQue;
import fuse.texture.BitmapTexture;
import fuse.texture.Texture;
import openfl.display.BitmapData;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DTextureFormat;
import openfl.display3D.textures.TextureBase;
//import openfl.display3D.textures.Texture as NativeTexture;
/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
@:access(fuse.core.front.buffers.AtlasBuffers)
@:access(fuse.core.front.buffers.LayerCacheBuffers)
@:access(fuse.core.front.texture)
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
		
		Fuse.current.enterFrame.add(OnTick);
	}
	
	static private function OnTick() 
	{
		TextureUploadQue.check();
	}
	
	static private function createDefaultTextures() 
	{
		#if debug
		var blank:BitmapData = new BitmapData(512, 512, true, 0x9900FF00);
		#else
		var blank:BitmapData = new BitmapData(32, 32, true, 0x00000000);
		#end
		var blankTexture:DefaultTexture = new DefaultTexture(blank, false);
		blankId = blankTexture.textureId;
		
		var white:BitmapData = new BitmapData(32, 32, true, 0xFFFFFFFF);
		var whiteTexture:DefaultTexture = new DefaultTexture(white, false);
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
		
	static inline public function getTextureBase(textureId:Int):TextureBase
	{
		var texture:Texture = getTexture(textureId);
		if (texture == null) return null;
		return texture.textureBase;
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

class DefaultTexture extends BitmapTexture
{
	function new(bitmapData:BitmapData, queUpload:Bool=true, onTextureUploadCompleteCallback:Void -> Void = null) 
	{
		this.persistent = 1;
		
		super(bitmapData, queUpload, onTextureUploadCompleteCallback);
	}
}