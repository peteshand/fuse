package fuse.core.assembler.batches.batch;

import fuse.core.assembler.batches.batch.BatchTextures;
import fuse.core.assembler.vertexWriter.ICoreRenderable;
import fuse.utils.GcoArray;

/**
 * ...
 * @author P.J.Shand
 */
class BatchTextures
{
	public var textureIds = new GcoArray<Int>([]);
	public var textureId1(get, null):Int;
	public var textureId2(get, null):Int;
	public var textureId3(get, null):Int;
	public var textureId4(get, null):Int;
	public var textureId5(get, null):Int;
	public var textureId6(get, null):Int;
	public var textureId7(get, null):Int;
	public var textureId8(get, null):Int;
	
	public function new() 
	{
		
	}
	
	public function getTextureIndex(textureId:Int):Int
	{
		for (i in 0...textureIds.length) 
		{
			if (textureId == textureIds[i]) return i;
		}
		if (textureIds.length < PlatformSettings.MAX_TEXTURES) {
			textureIds.push(textureId);
			return textureIds.length-1;
		}
		return -1;
	}
	
	public function toString():String
	{
		return cast textureIds;
	}
	
	public function clear() 
	{
		textureIds.clear();
	}
	
	public function copyFrom(copyFrom:BatchTextures) 
	{
		for (i in 0...copyFrom.textureIds.length) 
		{
			textureIds[i] = copyFrom.textureIds[i];
		}
	}
	
	inline function get_textureId1():Int 
	{
		if (textureIds.length <= 0) return 0;
		return textureIds[0];
	}
	
	inline function get_textureId2():Int 
	{
		if (textureIds.length <= 1) return 0;
		return textureIds[1];
	}
	
	inline function get_textureId3():Int 
	{
		if (textureIds.length <= 2) return 0;
		return textureIds[2];
	}
	
	inline function get_textureId4():Int 
	{
		if (textureIds.length <= 3) return 0;
		return textureIds[3];
	}
	
	inline function get_textureId5():Int 
	{
		if (textureIds.length <= 4) return 0;
		return textureIds[4];
	}
	
	inline function get_textureId6():Int 
	{
		if (textureIds.length <= 5) return 0;
		return textureIds[5];
	}
	
	inline function get_textureId7():Int 
	{
		if (textureIds.length <= 6) return 0;
		return textureIds[6];
	}
	
	inline function get_textureId8():Int 
	{
		if (textureIds.length <= 7) return 0;
		return textureIds[7];
	}
}