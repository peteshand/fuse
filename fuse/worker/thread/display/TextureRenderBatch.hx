package fuse.worker.thread.display;
import fuse.worker.thread.Conductor;
import fuse.worker.thread.WorkerCore;
import fuse.core.memory.data.batchData.BatchData;
import fuse.core.memory.data.batchData.IBatchData;
import fuse.core.memory.data.vertexData.VertexData;
import fuse.utils.GcoArray;
import fuse.worker.thread.display.TextureOrder.TextureDef;

/**
 * ...
 * @author P.J.Shand
 */
class TextureRenderBatch
{
	var batchDataArray:Array<IBatchData> = [];
	
	var renderBatchDefPool:Array<RenderBatchDef> = [];
	var renderBatchDefs = new GcoArray<RenderBatchDef>([]);
	var currentRenderBatchDef:RenderBatchDef;
	var itemCount:Int = 0;
	
	public function new() 
	{
		
	}
	
	public function begin() 
	{
		renderBatchDefs.clear();
		currentRenderBatchDef = null;
		itemCount = 0;
	}
	
	public function update() 
	{
		//trace("update: " + WorkerCore.textureOrder.textureDefArray.length);
		//clear();
		currentRenderBatchDefs(WorkerCore.textureOrder.textureDefArray);
		createBatchData();
	}
	
	public function end() 
	{
		//trace("renderBatchDefs.length = " + renderBatchDefs.length);
		/*for (i in 0...renderBatchDefs.length) 
		{
			var renderBatchDef:RenderBatchDef = renderBatchDefs[i];
			//trace("renderBatchDef.textureDefs.length = " + renderBatchDef.textureDefs.length);
			for (i in 0...renderBatchDef.textureDefs.length) 
			{
				var textureDef:TextureDef = renderBatchDef.textureDefs[i];
				trace("textureDef.workerDisplays.length = " + textureDef.workerDisplays.length);
				for (j in 0...textureDef.workerDisplays.length) 
				{
					var workerDisplay:WorkerDisplay = textureDef.workerDisplays[j];
					//trace("workerDisplay.textureData.atlasTextureId = " + workerDisplay.textureData.atlasTextureId);
					for (k in 0...renderBatchDef.textureIdArray.length) 
					{
						//trace("renderBatchDef.textureIdArray[k] = " + renderBatchDef.textureIdArray[k]);
						if (workerDisplay.textureData.atlasTextureId == renderBatchDef.textureIdArray[k]) {
							//trace(["workerDisplay.textureIndex = " + k, workerDisplay.objectId]);
							workerDisplay.textureIndex = k;
						}
					}
				}
			}
		}*/
		
		//trace("number of batches = " + renderBatchDefs.length);
		Conductor.conductorData.numberOfBatches = renderBatchDefs.length;
	}
	
	function currentRenderBatchDefs(textureDefArray:GcoArray<TextureDef>) 
	{
		for (i in 0...textureDefArray.length) 
		{
			var currentTextureDef:TextureDef = textureDefArray[i];
			if (requiresNewRenderBatchDef(currentTextureDef, currentTextureDef)) {
				closeCurrentRenderBatch();
				currentRenderBatchDef = createRenderBatchDef(renderBatchDefs.length);
				currentRenderBatchDef.startIndex = currentTextureDef.startIndex;
				currentRenderBatchDef.renderTargetId = currentTextureDef.renderTargetId;
			}
			currentTextureDef.renderBatchDef = currentRenderBatchDef;
			
			currentRenderBatchDef.numItems += currentTextureDef.numItems;
			
			
			////////////////////////////////////////////////////
			// TODO, need to limit to 4 textures per batch
			////////////////////////////////////////////////////
			
			/*var alreadyAdded:Bool = false;
			for (i in 0...currentRenderBatchDef.textureIdArray.length) 
			{
				if (currentRenderBatchDef.textureIdArray[i] == currentTextureDef.textureId) {
					alreadyAdded = true;
					break;
				}
			}
			trace("alreadyAdded = " + alreadyAdded);
			if (!alreadyAdded) {*/
				currentRenderBatchDef.textureIdArray.push(currentTextureDef.textureId);
				currentRenderBatchDef.textureDefs.push(currentTextureDef);
			//}
			itemCount++;
		}
		closeCurrentRenderBatch();
		/*trace("renderBatchDefPool.length = " + renderBatchDefPool.length);
		for (j in 0...renderBatchDefPool.length) 
		{
			for (k in 0...renderBatchDefPool[j].textureDefs.length) 
			{
				//trace("renderBatchDefPool[j].textureDefs[k].workerDisplay = " + renderBatchDefPool[j].textureDefs[k].workerDisplay);
				for (j in 0...renderBatchDefPool[j].textureDefs[k].workerDisplays.length) 
				{
					trace(renderBatchDefPool[j].textureDefs[k].workerDisplays);
				}
			}
		}*/
		//currentTextureDef = null;
	}
	
	function closeCurrentRenderBatch() 
	{
		if (currentRenderBatchDef != null) {
			trace("closeCurrentRenderBatch");
			currentRenderBatchDef.length = currentRenderBatchDef.textureIdArray.length * VertexData.BYTES_PER_ITEM;
			for (i in 0...currentRenderBatchDef.textureDefs.length) 
			{
				currentRenderBatchDef.textureDefs[i].renderBatchIndex = currentRenderBatchDef.index;
				currentRenderBatchDef.textureDefs[i].textureIndex = i;
				trace("currentRenderBatchDef.textureDefs[" + i + "].textureIndex = " + currentRenderBatchDef.textureDefs[i].textureIndex);
			}
			currentRenderBatchDef = null;
		}
		itemCount = 0;
	}
	
	public function findTextureIndex(batchIndex:Int, textureId:Int):Int
	{
		//trace("textureId = " + textureId);
		for (j in 0...renderBatchDefs[batchIndex].textureDefs.length) 
		{
			//trace("renderBatchDefs[" + batchIndex + "].textureDefs[" + j + "].textureId = " + renderBatchDefs[batchIndex].textureDefs[j].textureId);
			if (renderBatchDefs[batchIndex].textureDefs[j].textureId == textureId) {
				return j;
			}
		}
		return 0;
	}
	
	inline function createBatchData() 
	{
		for (j in 0...renderBatchDefs.length) 
		{
			var batchData:IBatchData = getBatchData(j);
			batchData.startIndex = renderBatchDefs[j].startIndex;
			batchData.length = renderBatchDefs[j].length;
			
			batchData.textureId1 = setTextureIds(renderBatchDefs[j].textureIdArray, 0);
			batchData.textureId2 = setTextureIds(renderBatchDefs[j].textureIdArray, 1);
			batchData.textureId3 = setTextureIds(renderBatchDefs[j].textureIdArray, 2);
			batchData.textureId4 = setTextureIds(renderBatchDefs[j].textureIdArray, 3);
			
			batchData.renderTargetId = renderBatchDefs[j].renderTargetId;
			batchData.numItems = renderBatchDefs[j].numItems;
			
			batchData.numTextures = renderBatchDefs[j].textureIdArray.length;
			if (batchData.renderTargetId == -1){
				batchData.width = 1600;
				batchData.height = 900;
			}
			else {
				batchData.width = 512;
				batchData.height = 512;
			}
		}
	}
	
	function setTextureIds(textureIdArray:GcoArray<Int>, index:Int):Null<Int>
	{
		if (index < textureIdArray.length) return textureIdArray[index];
		return null;
	}
	
	
	function requiresNewRenderBatchDef(textureDef:TextureDef, currentTextureDef:TextureDef):Bool
	{
		if (currentRenderBatchDef == null || currentTextureDef == null) {
			return true;
		}
		else if (currentRenderBatchDef.renderTargetId != textureDef.renderTargetId) {
			return true; 
		}
		else if (currentRenderBatchDef.textureIdArray.length >= 4) {
			return true;
		}
		else {
			return false;
		}
	}
	
	public function getBatchData(objectId:Int):IBatchData
	{
		if (objectId >= batchDataArray.length) {
			var batchData:IBatchData = new BatchData(objectId);
			batchDataArray.push(batchData);
		}
		return batchDataArray[objectId];
	}
	
	public function getTextureIndex(textureId:Int) 
	{
		for (k in 0...renderBatchDefs.length) 
		{
			var renderBatchDef:RenderBatchDef = renderBatchDefs[k];
			for (i in 0...renderBatchDef.textureIdArray.length) 
			{
				if (renderBatchDef.textureIdArray[i] == textureId) return i;
			}
		}
		return 0;
	}
	
	public function createRenderBatchDef(index:Int):RenderBatchDef
	{
		if (index >= renderBatchDefPool.length) {
			
			var renderBatchDef:RenderBatchDef = {
				index:index,
				startIndex:-1,
				//textureIds:new Map<Int, Int>(),
				renderTargetId: -1,
				textureDefs:new GcoArray<TextureDef>([]),
				textureIdArray:new GcoArray<Int>([]),
				numItems:0
			}
			renderBatchDefPool[index] = renderBatchDef;
		}
		else {
			renderBatchDefPool[index].index = index;
			renderBatchDefPool[index].startIndex = -1;
			renderBatchDefPool[index].renderTargetId = -1;
			renderBatchDefPool[index].textureIdArray.clear();
			renderBatchDefPool[index].textureDefs.clear();
			renderBatchDefPool[index].numItems = 0;
		}
		
		renderBatchDefs[index] = renderBatchDefPool[index];
		return renderBatchDefs[index];
	}
	
	public function getRenderBatchDef(index:Int):RenderBatchDef
	{
		return renderBatchDefs[index];
	}
	
	/*public function getRenderBatchDef(drawIndex:Int):RenderBatchDef
	{
		for (i in 0...renderBatchDefs.length) 
		{
			for (j in 0...renderBatchDefs[i].textureDefs.length) 
			{
				if (renderBatchDefs[i].textureDefs[j].drawIndex == drawIndex) {
					return renderBatchDefs[i];
				}
			}
		}
		return null;
	}*/
	
	public function getRenderBatchIndex(index:Int):Int
	{
		for (i in 0...renderBatchDefs.length) 
		{
			for (j in 0...renderBatchDefs[i].textureDefs.length) 
			{
				if (renderBatchDefs[i].textureDefs[j].index == index) {
					return i;
				}
			}
		}
		return 0;
	}
	
	
}

typedef RenderBatchDef =
{
	index:Int,
	startIndex:Int,
	renderTargetId:Int,
	textureIdArray:GcoArray<Int>,
	textureDefs:GcoArray<TextureDef>,
	numItems:Int,
	?length:Int
}