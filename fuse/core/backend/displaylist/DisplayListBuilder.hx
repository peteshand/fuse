package fuse.core.backend.displaylist;

import fuse.core.communication.IWorkerComms;
import fuse.core.backend.Conductor;
import fuse.core.backend.Core;
import fuse.core.backend.atlas.AtlasPacker;
import fuse.core.backend.display.CoreDisplayObject;
import fuse.core.backend.layerCache.LayerCache;
import fuse.core.backend.layerCache.groups.LayerGroup;
import fuse.core.communication.data.displayData.DisplayData;
import fuse.core.communication.data.displayData.IDisplayData;
import fuse.core.communication.data.indices.IndicesData;
import fuse.core.communication.data.vertexData.VertexData;
import fuse.pool.Pool;
import fuse.texture.RenderTexture;
import fuse.utils.GcoArray;
/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class DisplayListBuilder
{
	public var hierarchyAll = new GcoArray<CoreDisplayObject>([]);
	public var hierarchy = new GcoArray<CoreDisplayObject>([]);
	public var visHierarchyAll = new GcoArray<CoreDisplayObject>([]);
	public var visHierarchy = new GcoArray<CoreDisplayObject>([]);
	
	public var hierarchyApplyTransform = new GcoArray<Void -> Void>([]);
	
	public function new() 
	{
		
	}
	
	public function update() 
	{
		Core.isStatic = Conductor.conductorData.isStatic;
		
		if (Core.isStatic == 0) {
			
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
		if (Core.textureBuildNextFrame) {
			Core.textureBuildRequired = true;
		}
		
		// Reset vertexData read position
		VertexData.OBJECT_POSITION = 0;
		IndicesData.OBJECT_POSITION = 0;
		
		if (Core.hierarchyBuildRequired) {
			this.hierarchyAll.clear();
			this.visHierarchyAll.clear();
		}
		
		if (Core.textureBuildRequired) {
			Core.atlasTextureDrawOrder.begin();
			Core.textureOrder.begin();
		}
		
		Core.textureBuildNextFrame = false;
	}
	
	inline function buildRenderTexturesHierarchy() 
	{
		// Loop through all renderTextures to check if there is content to render
		Core.renderTextureManager.update();
		RenderTexture.currentRenderTargetId = -1;
	}
	
	inline function buildDisplayListHierarchy() 
	{
		process(Core.displayList.stage);
	}
	
	inline function createDynamicTextureAtlas() 
	{
		VertexData.OBJECT_POSITION = 0;
		IndicesData.OBJECT_POSITION = 0;
		
		if (Core.textureBuildRequired) {
			Core.atlasPacker.update();
		}
		
		AtlasPacker.NUM_ATLAS_DRAWS = VertexData.OBJECT_POSITION;
		//trace("Number of atlas draws = " + VertexData.OBJECT_POSITION);
		//this.checkAtlas();
	}
	
	inline function quadBatchTextureDraws() 
	{
		VertexData.OBJECT_POSITION = 0;
		IndicesData.OBJECT_POSITION = 0;
		
		if (Core.textureBuildRequired){
			this.setTextures();
			VertexData.OBJECT_POSITION = AtlasPacker.NUM_ATLAS_DRAWS;
			//WorkerCore.atlasTextureRenderBatch.update();
			//trace(WorkerCore.textureBuildRequired);
		}
		
		if (Core.textureBuildRequired) {
			Core.textureRenderBatch.begin();
			Core.textureRenderBatch.update();
			Core.textureRenderBatch.end();
		}
	}
	
	inline function writeVertexData() 
	{
		this.setVertexData();
	}
	
	inline function end() 
	{
		Conductor.conductorData.frameIndex++;
		Core.hierarchyBuildRequired = false;
		Conductor.conductorData.busy = 0;
	}
	
	inline function process(root:CoreDisplayObject) 
	{		
		this.buildHierarchy(root);
		this.applyTransform();
		//this.updateInternalData();
		if (Core.textureBuildRequired){
			this.setAtlasTextures();
		}
	}
	
	inline function buildHierarchy(root:CoreDisplayObject) 
	{
		if (Core.hierarchyBuildRequired) {
			hierarchy.clear();
			visHierarchy.clear();
			hierarchyApplyTransform.clear();
			if (root != null) root.buildHierarchy();
		}
	}
	
	inline function applyTransform() 
	{		
		Core.layerCaches.begin();
		for (i in 0...hierarchyApplyTransform.length) 
		{
			hierarchyApplyTransform[i]();
		}
		Core.layerCaches.end();
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
		IndicesData.OBJECT_POSITION = 0;
		
		for (k in 0...hierarchy.length) 
		{
			hierarchy[k].setAtlasTextures();
		}
	}
	
	inline function checkLayerCache() 
	{
		if (Core.layerCaches.change){
			VertexData.OBJECT_POSITION = 0;
			IndicesData.OBJECT_POSITION = 0;
			
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
		
		for (i in 0...Core.layerCaches.allLayerGroups.length) 
		{
			var layerGroup:LayerGroup = Core.layerCaches.allLayerGroups[i];
			
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
		if (Core.textureBuildRequired) {
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
		IndicesData.OBJECT_POSITION = 0;
		if (Core.textureBuildRequired){
			Core.atlasPacker.setVertexData();
		}
		
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
		
			
			for (i in 0...Core.layerCaches.allLayerGroups.length) 
			{
				var layerGroup:LayerGroup = Core.layerCaches.allLayerGroups[i];
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
					
					var layerCache:LayerCache = Core.layerCaches.activeGroups[layerGroup.staticIndex];
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
			Conductor.conductorData.numTriangles = VertexData.OBJECT_POSITION * 2;
			//trace("VertexData.OBJECT_POSITION = " + VertexData.OBJECT_POSITION);
		//}
	}
}