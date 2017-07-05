package kea2.worker.thread.atlas;

import kea2.core.memory.data.batchData.BatchData;
import kea2.core.memory.data.batchData.IBatchData;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.utils.GcoArray;
import kea2.worker.thread.display.TextureOrder.TextureDef;

/**
 * ...
 * @author P.J.Shand
 */
class AtlasTextureRenderBatch
{
	var batchDataArray:Array<IBatchData> = [];
	
	var renderBatchDefPool:Array<RenderBatchDef> = [];
	var renderBatchDefs = new GcoArray<RenderBatchDef>([]);
	var currentRenderBatchDef:RenderBatchDef;
	var itemCount:Int = 0;
	
	public function new() 
	{
		
	}
	
	public function update() 
	{
		currentRenderBatchDefs(WorkerCore.atlasTextureDrawOrder.textureDefArray);
		
		for (i in 0...renderBatchDefs.length) 
		{
			trace(renderBatchDefs[i]);
		}
		createBatchData();
		trace("renderBatchDefs.length = " + renderBatchDefs.length);
		Conductor.conductorDataAccess.numberOfBatches = renderBatchDefs.length;
	}
	
	function currentRenderBatchDefs(textureDefArray:GcoArray<TextureDef>) 
	{
		renderBatchDefs.clear();
		currentRenderBatchDef = null;
		itemCount = 0;
		
		for (i in 0...textureDefArray.length) 
		{
			var currentTextureDef:TextureDef = textureDefArray[i];
			
			if (requiresNewRenderBatchDef(currentTextureDef, currentTextureDef)) {
				closeCurrentRenderBatch();
				currentRenderBatchDef = createRenderBatchDef(renderBatchDefs.length);
				currentRenderBatchDef.startIndex = currentTextureDef.startIndex;
				currentRenderBatchDef.renderTargetId = currentTextureDef.renderTargetId;
				currentRenderBatchDef.textureIdArray.clear();
			}
			
			var alreadyAdded:Bool = false;
			for (i in 0...currentRenderBatchDef.textureIdArray.length) 
			{
				if (currentRenderBatchDef.textureIdArray[i] == currentTextureDef.textureId) {
					alreadyAdded = true;
					break;
				}
			}
			if (!alreadyAdded) {
				currentRenderBatchDef.textureIdArray.push(currentTextureDef.textureId);
				currentRenderBatchDef.textureDefs.push(currentTextureDef);
			}
			itemCount++;
		}
		closeCurrentRenderBatch();
	}
	
	function createBatchData() 
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
	
	function closeCurrentRenderBatch() 
	{
		if (currentRenderBatchDef != null) {
			currentRenderBatchDef.length = currentRenderBatchDef.textureIdArray.length * VertexData.BYTES_PER_ITEM;
			currentRenderBatchDef.numItems = itemCount;
			currentRenderBatchDef = null;
		}
		itemCount = 0;
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
				textureIdArray:new GcoArray<Int>([])
			}
			renderBatchDefPool[index] = renderBatchDef;
		}
		else {
			renderBatchDefPool[index].index = index;
			renderBatchDefPool[index].startIndex = -1;
			renderBatchDefPool[index].renderTargetId = -1;
			renderBatchDefPool[index].textureIdArray.clear();
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
	
	public function getRenderBatchIndex(drawIndex:Int):Int
	{
		for (i in 0...renderBatchDefs.length) 
		{
			for (j in 0...renderBatchDefs[i].textureDefs.length) 
			{
				if (renderBatchDefs[i].textureDefs[j].drawIndex == drawIndex) {
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
	?numItems:Int,
	?length:Int
}