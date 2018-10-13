package fuse.core.front.texture;

import fuse.core.front.texture.BlankBmd;
import fuse.texture.DefaultTexture;
import openfl.Lib;
import fuse.core.front.buffers.AtlasBuffers;
import fuse.core.front.buffers.LayerCacheBuffers;
import fuse.core.front.texture.upload.TextureUploadQue;
import openfl.display.BitmapData;
import openfl.display3D.Context3D;
import openfl.display3D.textures.TextureBase;
import openfl.events.Event;
import fuse.core.front.texture.ITexture;
/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse.core.front.buffers.AtlasBuffers)
@:access(fuse.core.front.buffers.LayerCacheBuffers)
@:access(fuse.core.front.texture)
class Textures
{
	static private var context3D:Context3D;
	static public var textures = new Map<Int, ITexture>();
	static private var blankId:Int = 0;
	static private var whiteId:Int = 1;
	static private var textureCount:Int = 0;
	static public var whiteTexture:DefaultTexture;
	static public var blankTexture:DefaultTexture;
	
	public function new() { }
	
	static public function init(context3D:Context3D) 
	{
		Textures.context3D = context3D;
		
		createDefaultTextures();
		
		Lib.current.addEventListener(Event.ENTER_FRAME, OnTick);
	}
	
	static private function OnTick(e:Event) 
	{
		TextureUploadQue.check();
	}
	
	static private function createDefaultTextures() 
	{
		var blank:BlankBmd = new BlankBmd();
		blankTexture = new DefaultTexture(blank, false);
		//trace("blankTexture.textureId = " + blankTexture.textureId);
		var white:BitmapData = new BitmapData(8, 8, true, 0xFFFFFFFF);
		whiteTexture = new DefaultTexture(white, false);
		//trace("whiteTexture.textureId = " + whiteTexture.textureId);
	}
	
	static public function registerTexture(textureId:Int, texture:ITexture):Void
	{
		if (!textures.exists(textureId)) {
			textures.set(textureId, texture);
			textureCount++;
			//trace("textureCount = " + textureCount);
			Fuse.current.conductorData.frontStaticCount = 0;
		}
	}
	
	static public function deregisterTexture(textureId:Int, texture:ITexture) 
	{
		if (textureId == 0) {
			trace("deregisterTexture: " + textureId);
		}
		
		if (textures.exists(textureId)) {
			textures.remove(textureId);
		}
	}
		
	static inline public function getTextureBase(textureId:Null<Int>):TextureBase
	{
		if (textureId == null) return null;
		
		var texture:ITexture = getTexture(textureId);
		if (texture == null) {
			//trace("No texture found for textureId: " + textureId);
			return null;
		}
		//if (texture.textureBase == null) trace("texture.textureBase = null");
		return texture.textureBase;
	}

	static inline public function getTexture(textureId:Int):ITexture
	{
		return textures.get(getTextureId(textureId));
	}
	
	static public function getTextureId(textureId:Null<Int>):Null<Int>
	{
		if (textureId == -1) return -1;
		if (textureId == null) return null;
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