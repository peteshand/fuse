package fuse.core.front.layers;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.texture.RenderTexture;
import fuse.texture.Texture;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture.Texture)
class LayerCacheBuffers
{
	static var startIndex:Int = 6;
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
			var buffer:RenderTexture = new RenderTexture(bufferWidth, bufferHeight);
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
		Texture.textureIdCount = startIndex + numBuffers;
	}
	
	static function create(textureId:Int) 
	{
		if (textureId < startIndex || textureId >= startIndex + numBuffers) return;
		
		if (!buffers.exists(textureId)){
			var currentTextureId:Int = Texture.textureIdCount;
			Texture.textureIdCount = textureId;
			var buffer:RenderTexture = new RenderTexture(bufferWidth, bufferHeight);
			buffers.set(textureId, buffer);
			Texture.textureIdCount = currentTextureId;
		}
	}
	
	static function get_endIndex():Int 
	{
		return startIndex + numBuffers;
	}
}