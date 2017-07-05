package kea2.worker.thread.texture;

import kea2.core.memory.data.MemoryBlock;
import kea2.core.memory.data.displayData.DisplayData;
import kea2.core.memory.data.renderTextureData.RenderTextureDrawData;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.pool.ObjectPool;
import kea2.pool.Pool;
import kea2.texture.RenderTexture;
import kea2.worker.thread.display.WorkerDisplay;
import kea2.worker.thread.display.WorkerDisplayList;

/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
class RenderTextureManager
{
	public var renderTextureDataMap = new Map<Int, RenderTextureDrawData>();
	
	public function new() {
		
	}
	
	public function update() 
	{
		var start:Int = Conductor.conductorDataAccess.renderTextureProcessIndex;
		var end:Int = Conductor.conductorDataAccess.renderTextureCountIndex;
		
		if (end > 0 && start != end) {
			WorkerCore.hierarchyBuildRequired = true;
		}
		
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
		
		
		
		Conductor.conductorDataAccess.renderTextureProcessIndex = Conductor.conductorDataAccess.renderTextureCountIndex = 0;
		
		//memoryBlock = Kea.current.keaMemory.renderTextureDataPool.createMemoryBlock(RenderTextureData.BYTES_PER_ITEM, objectOffset);
		//trace(Conductor.conductorDataAccess.renderTextureCountIndex, Conductor.conductorDataAccess.renderTextureProcessIndex);
	}
	
	function getMemoryBlock(index:Int):RenderTextureDrawData
	{
		if (!renderTextureDataMap.exists(index)) renderTextureDataMap.set(index, new RenderTextureDrawData(index));
		return renderTextureDataMap.get(index);
	}
}