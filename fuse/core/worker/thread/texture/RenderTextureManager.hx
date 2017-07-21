package fuse.core.worker.thread.texture;

import fuse.core.worker.thread.Conductor;
import fuse.core.worker.thread.WorkerCore;
import fuse.core.front.memory.data.MemoryBlock;
import fuse.core.front.memory.data.displayData.DisplayData;
import fuse.core.front.memory.data.renderTextureData.RenderTextureDrawData;
import fuse.core.front.memory.data.vertexData.VertexData;
import fuse.pool.ObjectPool;
import fuse.pool.Pool;
import fuse.texture.RenderTexture;
import fuse.core.worker.thread.display.WorkerDisplay;
import fuse.core.worker.thread.display.WorkerDisplayList;

/**
 * ...
 * @author P.J.Shand
 */
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
			WorkerCore.hierarchyBuildRequired = true;
			
			for (i in start...end) 
			{
				var renderTextureDrawData:RenderTextureDrawData = getMemoryBlock(i);
				//trace("renderTextureDrawData.renderTextureId = " + renderTextureDrawData.renderTextureId);
				RenderTexture.currentRenderTargetId = renderTextureDrawData.renderTextureId;
				
				//var displayData:IDisplayData = new DisplayData(renderTextureDrawData.displayObjectId);
				//trace([renderTextureDrawData.renderTextureId, renderTextureDrawData.displayObjectId/*, displayData.textureId*/]);
				var rootWorkerDisplay:WorkerDisplay = WorkerCore.workerDisplayList.map.get(renderTextureDrawData.displayObjectId);
				
				var clonedRoot:WorkerDisplay = Pool.workerDisplay.request();
				rootWorkerDisplay.copyTo(clonedRoot);
				
				WorkerCore.workerDisplayList.process(clonedRoot);
				
				clonedRoot.releaseToPool();
			}
			
			
			
			Conductor.conductorData.renderTextureProcessIndex = Conductor.conductorData.renderTextureCountIndex = 0;
		}
		
		
		lastStart = start;
		lastEnd = end;
		
		//memoryBlock = Kea.current.keaMemory.renderTextureDataPool.createMemoryBlock(RenderTextureData.BYTES_PER_ITEM, objectOffset);
		//trace(Conductor.conductorData.renderTextureCountIndex, Conductor.conductorData.renderTextureProcessIndex);
	}
	
	function getMemoryBlock(index:Int):RenderTextureDrawData
	{
		if (!renderTextureDataMap.exists(index)) renderTextureDataMap.set(index, new RenderTextureDrawData(index));
		return renderTextureDataMap.get(index);
	}
}