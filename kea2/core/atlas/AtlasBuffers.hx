package kea2.core.atlas;
import kea2.texture.RenderTexture;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasBuffers
{
	static var bufferWidth:Int;
	static var bufferHeight:Int;
	var buffers:Array<RenderTexture> = [];
	
	public function new(atlasBuffers:Int, bufferWidth:Int, bufferHeight:Int) 
	{
		AtlasBuffers.bufferWidth = bufferWidth;
		AtlasBuffers.bufferHeight = bufferHeight;
		
		for (i in 0...atlasBuffers) 
		{
			var buffer:RenderTexture = new RenderTexture(bufferWidth, bufferHeight);
			trace("buffer.textureId = " + buffer.textureId);
			buffers.push(buffer);
		}
	}
	
}