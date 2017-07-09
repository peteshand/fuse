package kea2.core.layers;
import kea2.core.memory.data.conductorData.ConductorData;
import kea2.texture.RenderTexture;

/**
 * ...
 * @author P.J.Shand
 */
class LayerCacheBuffers
{
	static var bufferWidth:Int;
	static var bufferHeight:Int;
	var buffers:Array<RenderTexture> = [];
	var conductorData:ConductorData = new ConductorData();
	
	public function new(numBuffers:Int, bufferWidth:Int, bufferHeight:Int) 
	{
		LayerCacheBuffers.bufferWidth = bufferWidth;
		LayerCacheBuffers.bufferHeight = bufferHeight;
		
		for (i in 0...numBuffers) 
		{
			var buffer:RenderTexture = new RenderTexture(bufferWidth, bufferHeight);
			trace("buffer.textureId = " + buffer.textureId);
			
			buffers.push(buffer);
		}
		
		if (buffers.length >= 1) conductorData.layerCacheTextureId1 = buffers[0].textureId;
		if (buffers.length >= 2) conductorData.layerCacheTextureId2 = buffers[1].textureId;
		if (buffers.length >= 3) conductorData.layerCacheTextureId3 = buffers[2].textureId;
		if (buffers.length >= 4) conductorData.layerCacheTextureId4 = buffers[3].textureId;
		if (buffers.length >= 5) conductorData.layerCacheTextureId5 = buffers[4].textureId;
	}
	
}