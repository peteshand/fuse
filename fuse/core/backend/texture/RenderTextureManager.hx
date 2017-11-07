package fuse.core.backend.texture;

import fuse.core.backend.Conductor;
import fuse.core.backend.Core;
import fuse.core.communication.data.MemoryBlock;
import fuse.core.communication.data.renderTextureData.RenderTextureDrawData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.utils.ObjectPool;
import fuse.core.utils.Pool;
import fuse.texture.RenderTexture;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.displaylist.DisplayListBuilder;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
@:access(fuse)
class RenderTextureManager
{
	var start:Int;
	var end:Int;
	var lastStart:Int;
	var lastEnd:Int;
	
	public var renderTextureDataMap = new Map<Int, RenderTextureDrawData>();
	
	public function new() {
		
	}
	
	public function update() 
	{
		start = Conductor.conductorData.renderTextureProcessIndex;
		end = Conductor.conductorData.renderTextureCountIndex;
		
		//if (start != lastStart || end != lastEnd) {
		if (end > 0 && start != end) {
			Core.hierarchyBuildRequired = true;
			
			for (i in start...end) 
			{
				var renderTextureDrawData:RenderTextureDrawData = getMemoryBlock(i);
				//trace("renderTextureDrawData.renderTextureId = " + renderTextureDrawData.renderTextureId);
				RenderTexture.currentRenderTargetId = renderTextureDrawData.renderTextureId;
				
				//var displayData:IDisplayData = new DisplayData(renderTextureDrawData.displayObjectId);
				//trace([renderTextureDrawData.renderTextureId, renderTextureDrawData.displayObjectId/*, displayData.textureId*/]);
				var rootWorkerDisplay:CoreDisplayObject = Core.displayList.get(renderTextureDrawData.displayObjectId);
				
				var clonedRoot:CoreDisplayObject = Pool.displayObjects.request();
				rootWorkerDisplay.copyTo(clonedRoot);
				
				Core.displayListBuilder.process(clonedRoot);
				
				clonedRoot.recursiveReleaseToPool();
			}
			
			
			
			Conductor.conductorData.renderTextureProcessIndex = Conductor.conductorData.renderTextureCountIndex = 0;
		}
		
		
		lastStart = start;
		lastEnd = end;
		
		//memoryBlock = Kea.current.sharedMemory.renderTextureDataPool.createMemoryBlock(RenderTextureData.BYTES_PER_ITEM, objectOffset);
		//trace(Conductor.conductorData.renderTextureCountIndex, Conductor.conductorData.renderTextureProcessIndex);
	}
	
	function getMemoryBlock(index:Int):RenderTextureDrawData
	{
		if (!renderTextureDataMap.exists(index)) renderTextureDataMap.set(index, new RenderTextureDrawData(index));
		return renderTextureDataMap.get(index);
	}
}