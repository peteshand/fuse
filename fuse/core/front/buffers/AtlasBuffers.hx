package fuse.core.front.buffers;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.texture.RenderTexture;
import fuse.texture.Texture;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse.texture.Texture)
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
		Texture.textureIdCount = startIndex + numBuffers;
		//for (i in startIndex...endIndex) 
		//{
			//create(i);
		//}
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