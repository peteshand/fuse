package fuse.core.front.buffers;

import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.texture.BaseTexture;
import fuse.texture.AbstractTexture;
import fuse.texture.RenderTexture;

/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse.texture.BaseTexture)
class AtlasBuffers
{
	static var startIndex:Int = 2;
	static var numBuffers:Int = 4;
	static var endIndex(get, null):Int;
	
	static var bufferWidth:Int;
	static var bufferHeight:Int;
	static var buffers = new Map<Int, RenderTexture>();
	
	public function new() 
	{
		
	}
	
	static public function init(bufferWidth:Int, bufferHeight:Int) 
	{
		AtlasBuffers.bufferWidth = bufferWidth;
		AtlasBuffers.bufferHeight = bufferHeight;
		BaseTexture.textureIdCount = startIndex + numBuffers;
		for (i in startIndex...endIndex) 
		{
			create(i);
		}
	}
	
	static function create(textureId:Int) 
	{
		if (textureId < startIndex || textureId >= startIndex + numBuffers) return;
		
		if (!buffers.exists(textureId)){
			var currentTextureId:Int = BaseTexture.textureIdCount;
			BaseTexture.textureIdCount = textureId;
			var buffer:RenderTexture = new RenderTexture(bufferWidth, bufferHeight, true);
			//buffer.red = 0.5;
			buffers.set(textureId, buffer);
			BaseTexture.textureIdCount = currentTextureId;
		}
	}
	
	static function get_endIndex():Int 
	{
		return startIndex + (numBuffers * 2);
	}
	
	public static function getBufferTexture(index:Int):RenderTexture
	{
		if (index >= numBuffers) return null;
		var id:Int = startIndex + index;
		create(id);
		return buffers.get(id);
	}
}