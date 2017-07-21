package fuse.core.worker.thread.display;

import fuse.core.worker.thread.Conductor;
import fuse.core.worker.thread.WorkerCore;
import fuse.core.front.memory.data.displayData.IDisplayData;
import fuse.pool.Pool;
import fuse.texture.RenderTexture;
import fuse.utils.GcoArray;
import fuse.utils.Notifier;
import fuse.core.front.memory.data.displayData.DisplayData;
import fuse.core.front.memory.data.vertexData.VertexData;
import fuse.core.worker.communication.IWorkerComms;
import fuse.core.worker.communication.WorkerComms;
import fuse.core.worker.data.WorkerSharedProperties;
import fuse.core.worker.thread.atlas.AtlasPacker;
import fuse.core.worker.thread.display.WorkerDisplay;
import fuse.core.worker.thread.layerCache.LayerCache;
import fuse.core.worker.thread.layerCache.groups.LayerGroup;
import openfl.utils.Endian;
/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class WorkerDisplayList
{
	var workerComms:IWorkerComms;
	public var transformDataMap:Map<Int, IDisplayData> = new Map<Int, IDisplayData>();
	//public var vertexDataMap:Map<Int, VertexData> = new Map<Int, VertexData>();
	
	
	public var stage:WorkerDisplay;
	public var map:Map<Int, WorkerDisplay> = new Map<Int, WorkerDisplay>();
	
	public var hierarchyAll = new GcoArray<WorkerDisplay>([]);
	public var hierarchy = new GcoArray<WorkerDisplay>([]);
	public var visHierarchyAll = new GcoArray<WorkerDisplay>([]);
	public var visHierarchy = new GcoArray<WorkerDisplay>([]);
	
	public var hierarchyApplyTransform = new GcoArray<Void -> Void>([]);
	
	public function new(workerComms:IWorkerComms) 
	{
		this.workerComms = workerComms;
	}
	
	public function addChildAt(objectId:Int, renderId:Int, parentId:Int, addAtIndex:Int) 
	{
		/*var vertexData:VertexData = null;
		if (renderId != -1) vertexData = getVertexData(renderId);*/
		var workerDisplay:WorkerDisplay = Pool.workerDisplay.request();// new WorkerDisplay(getDisplayData(objectId));
		workerDisplay.displayData = getDisplayData(objectId);
		workerDisplay.textureId = workerDisplay.displayData.textureId;
		workerDisplay.objectId = objectId;
		workerDisplay.renderId = renderId;
		workerDisplay.parentId = parentId;
		
		//workerDisplay.displayData.position = 0;
		
		var parentId:Int = workerDisplay.parentId;
		
		if (map.exists(parentId)) {
			map.get(parentId).addChildAt(workerDisplay, addAtIndex);
		}
		map.set(workerDisplay.objectId, workerDisplay);
		
		if (objectId == 0) {
			stage = workerDisplay;
		}
		//workerDisplayList.addChildAt(new WorkerDisplay(transformData), addAtIndex);
	}
	
	function getDisplayData(objectId:Int):IDisplayData
	{
		var displayDataAccess:IDisplayData = null;
		if (!transformDataMap.exists(objectId)) {
			displayDataAccess = new DisplayData(objectId);
			//displayDataAccess = workerComms.getSharedProperty(WorkerSharedProperties.DISPLAY + objectId);
			//displayDataAccess.endian = Endian.LITTLE_ENDIAN;
			transformDataMap.set(objectId, displayDataAccess);
		}
		return transformDataMap.get(objectId);
	}
	
	//function getVertexData(renderId:Int):VertexData
	//{
		//var vertexData:VertexData = null;
		//if (!vertexDataMap.exists(renderId)) {
			//vertexData = new VertexData(/*renderId*/);
			////vertexData = workerComms.getSharedProperty(WorkerSharedProperties.DISPLAY + objectId);
			////vertexData.endian = Endian.LITTLE_ENDIAN;
			//vertexDataMap.set(renderId, vertexData);
		//}
		//return vertexDataMap.get(renderId);
	//}
	
	public function removeChild(objectId:Int) 
	{
		var workerDisplay:WorkerDisplay = map.get(objectId);
		if (workerDisplay == null) return;
		
		if (workerDisplay.parent != null) {
			workerDisplay.parent.removeChild(workerDisplay);
		}
		transformDataMap.remove(objectId);
		//vertexDataMap.remove(objectId);
		map.remove(objectId);
	}
	
	
	
	
	
	
	public function update() 
	{
		WorkerCore.isStatic = Conductor.conductorData.isStatic;
		
		if (WorkerCore.isStatic == 0) {
			
			// Reset / Clear objects
			begin();
			
			// Builds the RenderTextures displaylist hierarchy and defines the order in which textures are used
			buildRenderTexturesHierarchy();
			
			// Builds the displaylist hierarchy and defines the order in which textures are used
			buildDisplayListHierarchy();
			
			// Based on the order in which textures are used, work out how to draw textures into
			// a large texture atlas so a large number of display items can be draw in a single draw call
			createDynamicTextureAtlas();
			
			checkLayerCache();
			// Works out how to group textures together so multiple textures (currently 4) can be drawn in a single draw call
			quadBatchTextureDraws();
			
			// Writes data into VertexData byteArray for used in the Renderer class
			writeVertexData();
			
			// Close calculation phase
			end();
		}
	}
	
	inline function begin() 
	{
		Conductor.conductorData.busy = 1;
		
		//trace("WorkerCore.textureBuildRequired = " + WorkerCore.textureBuildRequired);
		if (WorkerCore.textureBuildNextFrame) {
			WorkerCore.textureBuildRequired = true;
		}
		
		// Reset vertexData read position
		VertexData.OBJECT_POSITION = 0;
		
		if (WorkerCore.hierarchyBuildRequired) {
			this.hierarchyAll.clear();
			this.visHierarchyAll.clear();
		}
		
		if (WorkerCore.textureBuildRequired) {
			WorkerCore.atlasTextureDrawOrder.begin();
			WorkerCore.textureOrder.begin();
		}
		
		WorkerCore.textureBuildNextFrame = false;
	}
	
	inline function buildRenderTexturesHierarchy() 
	{
		// Loop through all renderTextures to check if there is content to render
		WorkerCore.renderTextureManager.update();
		RenderTexture.currentRenderTargetId = -1;
	}
	
	inline function buildDisplayListHierarchy() 
	{
		process(this.stage);
	}
	
	inline function createDynamicTextureAtlas() 
	{
		VertexData.OBJECT_POSITION = 0;
		if (WorkerCore.textureBuildRequired) {
			WorkerCore.atlasPacker.update();
		}
		
		AtlasPacker.NUM_ATLAS_DRAWS = VertexData.OBJECT_POSITION;
		//trace("Number of atlas draws = " + VertexData.OBJECT_POSITION);
		//this.checkAtlas();
	}
	
	inline function quadBatchTextureDraws() 
	{
		VertexData.OBJECT_POSITION = 0;
		if (WorkerCore.textureBuildRequired){
			this.setTextures();
			VertexData.OBJECT_POSITION = AtlasPacker.NUM_ATLAS_DRAWS;
			//WorkerCore.atlasTextureRenderBatch.update();
			//trace(WorkerCore.textureBuildRequired);
		}
		
		if (WorkerCore.textureBuildRequired) {
			WorkerCore.textureRenderBatch.begin();
			WorkerCore.textureRenderBatch.update();
			WorkerCore.textureRenderBatch.end();
		}
	}
	
	inline function writeVertexData() 
	{
		this.setVertexData();
	}
	
	inline function end() 
	{
		Conductor.conductorData.frameIndex++;
		WorkerCore.hierarchyBuildRequired = false;
		Conductor.conductorData.busy = 0;
	}
	
	inline function process(root:WorkerDisplay) 
	{		
		this.buildHierarchy(root);
		this.applyTransform();
		//this.updateInternalData();
		if (WorkerCore.textureBuildRequired){
			this.setAtlasTextures();
		}
	}
	
	inline function buildHierarchy(root:WorkerDisplay) 
	{
		if (WorkerCore.hierarchyBuildRequired) {
			hierarchy.clear();
			visHierarchy.clear();
			hierarchyApplyTransform.clear();
			if (root != null) root.buildHierarchy();
		}
	}
	
	inline function applyTransform() 
	{		
		WorkerCore.layerCaches.begin();
		for (i in 0...hierarchyApplyTransform.length) 
		{
			hierarchyApplyTransform[i]();
		}
		WorkerCore.layerCaches.end();
	}
	
	/*public function updateInternalData() 
	{
		for (k in 0...hierarchy.length) 
		{
			hierarchy[k].updateInternalData();
		}
	}*/
	
	inline function setAtlasTextures() 
	{
		VertexData.OBJECT_POSITION = 0;
		for (k in 0...hierarchy.length) 
		{
			hierarchy[k].setAtlasTextures();
		}
	}
	
	inline function checkLayerCache() 
	{
		if (WorkerCore.layerCaches.change){
			VertexData.OBJECT_POSITION = 0;
			for (k in 0...hierarchy.length) 
			{
				hierarchy[k].checkLayerCache();
			}
		}
	}
	
	inline function setTextures() 
	{
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		//
		//for (i in 0...WorkerCore.layerCaches.drawToStaticLayerGroups.length) 
		//{
			//var layerGroup:LayerGroup = WorkerCore.layerCaches.drawToStaticLayerGroups[i];
			//for (j in layerGroup.start...layerGroup.end+1) 
			//{
				//visHierarchy[j].setTexturesDraw();
			//}
		//}
		//
		//for (i in 0...WorkerCore.layerCaches.movingLayerGroups.length) 
		//{
			//var layerGroup:LayerGroup = WorkerCore.layerCaches.movingLayerGroups[i];
			//if (layerGroup.state.value == LayerGroupState.MOVING) {
				//for (j in layerGroup.start...layerGroup.end+1) 
				//{
					//visHierarchy[j].setTexturesMove();
				//}
			//}
			//else if (layerGroup.state.value == LayerGroupState.ALREADY_ADDED) {
				//for (j in layerGroup.start...layerGroup.end+1) 
				//{
					//visHierarchy[j].setTexturesAlreadyAdded();
				//}
			//}
		//}
		//
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
		for (i in 0...WorkerCore.layerCaches.allLayerGroups.length) 
		{
			var layerGroup:LayerGroup = WorkerCore.layerCaches.allLayerGroups[i];
			
			if (layerGroup.state.value == LayerGroupState.MOVING) {
				for (j in layerGroup.start...layerGroup.end+1) 
				{
					visHierarchy[j].setTexturesMove();
				}
			}
			else if (layerGroup.state.value == LayerGroupState.DRAW_TO_LAYER) {
				for (j in layerGroup.start...layerGroup.end+1) 
				{
					visHierarchy[j].setTexturesDraw();
				}
			}
			else if (layerGroup.state.value == LayerGroupState.ALREADY_ADDED) {
				
				for (j in layerGroup.start...layerGroup.end+1) 
				{
					visHierarchy[j].setTexturesAlreadyAdded();
				}
				/*var layerCache:LayerCache = WorkerCore.layerCaches.activeGroups[layerGroup.staticIndex];
				layerCache.setTextures();*/
			}
		}
	}
	
	function setVertexData() 
	{
		if (WorkerCore.textureBuildRequired) {
			/*for (k in 0...visHierarchyAll.length) 
			{
				visHierarchyAll[k].setTextureIndex();
			}*/
			
			/*for (i in 0...WorkerCore.layerCaches.allLayerGroups.length) 
			{
				var layerGroup:LayerGroup = WorkerCore.layerCaches.allLayerGroups[i];
				if (layerGroup.state.value == LayerGroupState.MOVING) {
					for (j in layerGroup.start...layerGroup.end+1) 
					{
						visHierarchy[j].setTextureIndexMove();
					}
				}
				else if (layerGroup.state.value == LayerGroupState.DRAW_TO_LAYER) {
					for (j in layerGroup.start...layerGroup.end+1) 
					{
						visHierarchy[j].setTextureIndexDraw();
					}
				}
				else if (layerGroup.state.value == LayerGroupState.ALREADY_ADDED) {
					for (j in layerGroup.start...layerGroup.end+1) 
					{
						visHierarchy[j].setTextureIndexAlreadyAdded();
					}
				}
			}*/
		}
		VertexData.OBJECT_POSITION = 0;
		if (WorkerCore.textureBuildRequired){
			WorkerCore.atlasPacker.setVertexData();
		}
		//VertexData.OBJECT_POSITION = 0;
		
		//{
			
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
			//for (i in 0...WorkerCore.layerCaches.drawToStaticLayerGroups.length) 
			//{
				//var layerGroup:LayerGroup = WorkerCore.layerCaches.drawToStaticLayerGroups[i];
				//for (j in layerGroup.start...layerGroup.end+1) 
				//{
					//visHierarchy[j].setVertexDataDraw();
				//}
				////var layerCache:LayerCache = WorkerCore.layerCaches.activeGroups[layerGroup.staticIndex];
				////layerCache.setVertexData();
			//}
			//
			//for (i in 0...WorkerCore.layerCaches.allLayerGroups.length) 
			//{
				//var layerGroup:LayerGroup = WorkerCore.layerCaches.allLayerGroups[i];
				//if (layerGroup.state.value == LayerGroupState.MOVING) {
					//for (j in layerGroup.start...layerGroup.end+1) 
					//{
						//visHierarchy[j].setVertexDataMove();
					//}
				//}
				//else {
					//var layerCache:LayerCache = WorkerCore.layerCaches.activeGroups[layerGroup.staticIndex];
					//layerCache.setVertexData();
				//}
			//}
		
		////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////
		
			
			for (i in 0...WorkerCore.layerCaches.allLayerGroups.length) 
			{
				var layerGroup:LayerGroup = WorkerCore.layerCaches.allLayerGroups[i];
				if (layerGroup.state.value == LayerGroupState.MOVING) {
					for (j in layerGroup.start...layerGroup.end+1) 
					{
						visHierarchy[j].setVertexDataMove();
					}
				}
				else {
					if (layerGroup.state.value == LayerGroupState.DRAW_TO_LAYER) {
						for (j in layerGroup.start...layerGroup.end+1) 
						{
							visHierarchy[j].setVertexDataDraw();
						}
					}
					//else if (layerGroup.state.value == LayerGroupState.ALREADY_ADDED) {
						
						/*for (j in layerGroup.start...layerGroup.end+1) 
						{
							visHierarchy[j].setVertexDataAlreadyAdded();
						}*/
					//}
					
					var layerCache:LayerCache = WorkerCore.layerCaches.activeGroups[layerGroup.staticIndex];
					layerCache.setVertexData();
				}
			}
			
			/*for (k in 0...visHierarchyAll.length) 
			{
				trace("k = " + k);
				visHierarchyAll[k].setVertexData();
			}*/
		//}
		
		//WorkerDisplay.layerCacheRenderTarget.value = -1;
		
		//if (WorkerCore.hierarchyBuildRequired) {
			Conductor.conductorData.numberOfRenderables = VertexData.OBJECT_POSITION;
			//trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		//}
	}
}