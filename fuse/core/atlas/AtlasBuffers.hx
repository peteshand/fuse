package fuse.core.atlas;
import fuse.core.memory.data.conductorData.ConductorData;
import fuse.texture.RenderTexture;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasBuffers
{
	static var bufferWidth:Int;
	static var bufferHeight:Int;
	var buffers:Array<RenderTexture> = [];
	var conductorData:ConductorData = new ConductorData();
	
	public function new(numBuffers:Int, bufferWidth:Int, bufferHeight:Int) 
	{
		AtlasBuffers.bufferWidth = bufferWidth;
		AtlasBuffers.bufferHeight = bufferHeight;
		
		for (i in 0...numBuffers) 
		{
			var buffer:RenderTexture = new RenderTexture(bufferWidth, bufferHeight);
			buffers.push(buffer);
		}
		
		if (buffers.length >= 1) conductorData.atlasTextureId1 = buffers[0].textureId;
		if (buffers.length >= 2) conductorData.atlasTextureId2 = buffers[1].textureId;
		if (buffers.length >= 3) conductorData.atlasTextureId3 = buffers[2].textureId;
		if (buffers.length >= 4) conductorData.atlasTextureId4 = buffers[3].textureId;
		if (buffers.length >= 5) conductorData.atlasTextureId5 = buffers[4].textureId;
	}
}