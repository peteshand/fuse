package fuse.core.front.buffers;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.texture.BaseTexture;
import fuse.texture.AbstractTexture;
import fuse.texture.RenderTexture;

/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse.texture.BaseTexture)
class LayerCacheBuffers
{
	static var startIndex:Int = 10;
	static var numBuffers:Int = 2;
	static var endIndex(get, null):Int;
	
	static var bufferWidth:Int;
	static var bufferHeight:Int;
	static var buffers = new Map<Int, RenderTexture>();
	//var conductorData:ConductorData = new ConductorData();
	
	public function new() 
	{
		
		
		/*for (i in 0...numBuffers) 
		{
			var buffer:RenderTexture = new RenderTexture(bufferWidth, bufferHeight, true);
			buffers.push(buffer);
		}
		
		if (buffers.length >= 1) conductorData.layerCacheTextureId1 = buffers[0].textureId;
		if (buffers.length >= 2) conductorData.layerCacheTextureId2 = buffers[1].textureId;
		if (buffers.length >= 3) conductorData.layerCacheTextureId3 = buffers[2].textureId;
		if (buffers.length >= 4) conductorData.layerCacheTextureId4 = buffers[3].textureId;
		if (buffers.length >= 5) conductorData.layerCacheTextureId5 = buffers[4].textureId;*/
	}
	
	static public function init(bufferWidth:Int, bufferHeight:Int) 
	{
		LayerCacheBuffers.bufferWidth = bufferWidth;
		LayerCacheBuffers.bufferHeight = bufferHeight;
		AbstractTexture.textureIdCount = startIndex + numBuffers;
		for (i in startIndex...endIndex) 
		{
			create(i);
		}
	}
	
	static function create(textureId:Int) 
	{
		if (textureId < startIndex || textureId >= startIndex + numBuffers) return;
		
		if (!buffers.exists(textureId)){
			var currentTextureId:Int = AbstractTexture.textureIdCount;
			AbstractTexture.textureIdCount = textureId;
			var buffer:RenderTexture = new RenderTexture(bufferWidth, bufferHeight, true);
			//buffer.green = 0.5;
			buffer._alreadyClear = true;
			buffers.set(textureId, buffer);
			AbstractTexture.textureIdCount = currentTextureId;
		}
	}
	
	static function get_endIndex():Int 
	{
		return startIndex + numBuffers;
	}
	
	public static function getBufferTexture(index:Int):RenderTexture
	{
		if (index >= numBuffers) return null;
		var id:Int = startIndex + index;
		create(id);
		return buffers.get(id);
	}
}