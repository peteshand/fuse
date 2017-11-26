package fuse.core.assembler.batches.batch;

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
	
	public function new() 
	{
		
	}
	
	public function getTextureIndex(textureId:Int):Int
	{
		for (i in 0...textureIds.length) 
		{
			if (textureId == textureIds[i]) return i;
		}
		if (textureIds.length < 4) {
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
}