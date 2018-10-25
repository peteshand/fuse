package fuse.core.front.buffers;

import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.front.texture.FrontBaseTexture;
import fuse.core.front.texture.FrontRenderTexture;
import mantle.notifier.Notifier;

/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse.core.front.texture.FrontBaseTexture)
class AtlasBuffers
{
	static var startIndex:Int = 2;
	static var numBuffers:Int = 2;
	static var endIndex(get, null):Int;
	
	static var bufferWidth:Int;
	static var bufferHeight:Int;
	static var buffers = new Map<Int, FrontRenderTexture>();
	
	public static var states:Array<Notifier<Null<Int>>> = [];

	public function new() 
	{
		
	}
	
	static public function init(bufferWidth:Int, bufferHeight:Int) 
	{
		AtlasBuffers.bufferWidth = bufferWidth;
		AtlasBuffers.bufferHeight = bufferHeight;
		FrontBaseTexture.textureIdCount = startIndex + numBuffers;
		for (i in startIndex...endIndex) 
		{
			if (i % 2 == 0) 
			states.push(new Notifier<Null<Int>>());
			create(i);
		}
	}
	
	static function create(textureId:Int) 
	{
		if (textureId < startIndex || textureId >= startIndex + numBuffers) return;
		
		if (!buffers.exists(textureId)) {
			var buffer:FrontRenderTexture = new FrontRenderTexture(bufferWidth, bufferHeight, true, textureId, textureId);
			//buffer.red = 0.5;
			buffers.set(textureId, buffer);
		}
	}
	
	static function get_endIndex():Int 
	{
		return startIndex + (numBuffers * 2);
	}
	
	public static function getBufferTexture(index:Int):FrontRenderTexture
	{
		if (index >= numBuffers) return null;
		var id:Int = startIndex + index;
		create(id);
		return buffers.get(id);
	}
	
	static public function setBufferIndexState(renderTargetId:Int) 
	{
		if (renderTargetId >= 2 && renderTargetId < 10) {
			var index:Int = Math.floor((renderTargetId - 2) / 2);
			var state:Int = (renderTargetId - 2) % 2;
			states[index].value = state;
		}
	}
}