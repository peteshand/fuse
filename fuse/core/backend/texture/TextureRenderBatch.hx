package fuse.core.backend.texture;
//import fuse.core.backend.Conductor;
//import fuse.core.backend.Core;
import fuse.core.communication.data.CommsObjGen;
//import fuse.core.communication.data.batchData.WorkerBatchData;
import fuse.core.communication.data.batchData.IBatchData;
//import fuse.core.communication.data.vertexData.VertexData;
//import fuse.utils.GcoArray;
//import fuse.core.backend.texture.TextureOrder.TextureDef;

/**
 * ...
 * @author P.J.Shand
 */

class TextureRenderBatch
{
	var batchDataArray:Array<IBatchData> = [];
	
	//var renderBatchDefPool:Array<RenderBatchDef> = [];
	//var renderBatchDefs = new GcoArray<RenderBatchDef>([]);
	//var currentRenderBatchDef:RenderBatchDef;
	//var itemCount:Int = 0;
	//
	//var textureIds:GcoArray<Int> = new GcoArray<Int>([]);
	//var added:Bool = false;
	
	public function new() { }
	
	//public function begin() 
	//{
		//renderBatchDefs.clear();
		//currentRenderBatchDef = null;
		//itemCount = 0;
	//}
	
	//public function update() 
	//{
		////currentRenderBatchDefs(Core.textureOrder.textureDefs);
		//createBatchData();
	//}
	
	//public function end() 
	//{
		//Conductor.conductorData.numberOfBatches = renderBatchDefs.length;
	//}
	
	//function closeCurrentRenderBatch() 
	//{
		//if (currentRenderBatchDef != null) {
			////trace("closeCurrentRenderBatch");
			//currentRenderBatchDef.length = currentRenderBatchDef.textureIdArray.length * VertexData.BYTES_PER_ITEM;
			//for (i in 0...currentRenderBatchDef.textureDefs.length) 
			//{
				//currentRenderBatchDef.textureDefs[i].renderBatchIndex = currentRenderBatchDef.index;
				//currentRenderBatchDef.textureDefs[i].textureIndex = i;
				////trace("currentRenderBatchDef.textureDefs[" + i + "].textureIndex = " + currentRenderBatchDef.textureDefs[i].textureIndex);
			//}
			//currentRenderBatchDef = null;
		//}
		//itemCount = 0;
	//}
	
	//public function findTextureIndex(batchIndex:Int, textureId:Int):Int
	//{
		////trace("textureId = " + textureId);
		//for (j in 0...renderBatchDefs[batchIndex].textureDefs.length) 
		//{
			////trace("renderBatchDefs[" + batchIndex + "].textureDefs[" + j + "].textureId = " + renderBatchDefs[batchIndex].textureDefs[j].textureId);
			//if (renderBatchDefs[batchIndex].textureDefs[j].textureId == textureId) {
				//return j;
			//}
		//}
		//return 0;
	//}
	
	//inline function createBatchData() 
	//{
		//for (j in 0...renderBatchDefs.length) 
		//{
			//var batchData:IBatchData = getBatchData(j);
			//batchData.startIndex = renderBatchDefs[j].startIndex;
			////batchData.length = renderBatchDefs[j].length;
			//
			//textureIds.clear();
			//for (i in 0...renderBatchDefs[j].textureIdArray.length) 
			//{
				//added = false;
				//for (k in 0...textureIds.length) 
				//{
					//if (textureIds[k] == renderBatchDefs[j].textureIdArray[i]) {
						//renderBatchDefs[j].textureDefs[i].textureIndex = k;
						//added = true;
						//break;
					//}
				//}
				//if (!added) textureIds.push(renderBatchDefs[j].textureIdArray[i]);
			//}
			//
			//batchData.textureId1 = setTextureIds(textureIds, 0);
			//batchData.textureId2 = setTextureIds(textureIds, 1);
			//batchData.textureId3 = setTextureIds(textureIds, 2);
			//batchData.textureId4 = setTextureIds(textureIds, 3);
			//
			//batchData.renderTargetId = renderBatchDefs[j].renderTargetId;
			//batchData.numItems = renderBatchDefs[j].numItems;
			//
			//batchData.numTextures = renderBatchDefs[j].textureIdArray.length;
			//if (batchData.renderTargetId == -1){
				//batchData.width = Core.STAGE_WIDTH;
				//batchData.height = Core.STAGE_HEIGHT;
			//}
			//else {
				//batchData.width = 512;
				//batchData.height = 512;
			//}
		//}
	//}
	
	//function setTextureIds(textureIdArray:GcoArray<Int>, index:Int):Null<Int>
	//{
		//if (index < textureIdArray.length) return textureIdArray[index];
		//return null;
	//}
	
	
	//function requiresNewRenderBatchDef(textureDef:TextureDef, currentTextureDef:TextureDef):Bool
	//{
		//if (currentRenderBatchDef == null || currentTextureDef == null) {
			//return true;
		//}
		//else if (currentRenderBatchDef.renderTargetId != textureDef.renderTargetId) {
			//return true; 
		//}
		//else if (currentRenderBatchDef.textureIdArray.length >= 4) {
			//for (i in 0...currentRenderBatchDef.textureIdArray.length) 
			//{
				//if (currentRenderBatchDef.textureIdArray[i] == textureDef.textureId) {
					//return false;
				//}
			//}
			//return true;
		//}
		//else {
			//return false;
		//}
	//}
	
	public function getBatchData(objectId:Int):IBatchData
	{
		if (objectId >= batchDataArray.length) {
			var batchData:IBatchData = CommsObjGen.getBatchData(objectId);
			//var batchData:IBatchData = new WorkerBatchData(objectId);
			batchDataArray.push(batchData);
		}
		return batchDataArray[objectId];
	}
	
	//public function getTextureIndex(textureId:Int) 
	//{
		//for (k in 0...renderBatchDefs.length) 
		//{
			//var renderBatchDef:RenderBatchDef = renderBatchDefs[k];
			//for (i in 0...renderBatchDef.textureIdArray.length) 
			//{
				//if (renderBatchDef.textureIdArray[i] == textureId) return i;
			//}
		//}
		//return 0;
	//}
	//
	//public function createRenderBatchDef(index:Int):RenderBatchDef
	//{
		//if (index >= renderBatchDefPool.length) {
			//
			//var renderBatchDef:RenderBatchDef = {
				//index:index,
				//startIndex:-1,
				////textureIds:new Map<Int, Int>(),
				//renderTargetId: -1,
				//textureDefs:new GcoArray<TextureDef>([]),
				//textureIdArray:new GcoArray<Int>([]),
				//numItems:0
			//}
			//renderBatchDefPool[index] = renderBatchDef;
		//}
		//else {
			//renderBatchDefPool[index].index = index;
			//renderBatchDefPool[index].startIndex = -1;
			//renderBatchDefPool[index].renderTargetId = -1;
			//renderBatchDefPool[index].textureIdArray.clear();
			//renderBatchDefPool[index].textureDefs.clear();
			//renderBatchDefPool[index].numItems = 0;
		//}
		//
		//renderBatchDefs[index] = renderBatchDefPool[index];
		//return renderBatchDefs[index];
	//}
	//
	//public function getRenderBatchDef(index:Int):RenderBatchDef
	//{
		//return renderBatchDefs[index];
	//}
	//
	//public function getRenderBatchIndex(index:Int):Int
	//{
		//for (i in 0...renderBatchDefs.length) 
		//{
			//for (j in 0...renderBatchDefs[i].textureDefs.length) 
			//{
				//if (renderBatchDefs[i].textureDefs[j].index == index) {
					//return i;
				//}
			//}
		//}
		//return 0;
	//}
	
	
}

//typedef RenderBatchDef =
//{
	//index:Int,
	//startIndex:Int,
	//renderTargetId:Int,
	//textureIdArray:GcoArray<Int>,
	//textureDefs:GcoArray<TextureDef>,
	//numItems:Int,
	//?length:Int
//}