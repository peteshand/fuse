package kea2.worker.thread.display;

import kea2.core.memory.data.vertexData.AtlasVertexData;
import kea2.texture.RenderTexture;
import kea2.utils.GcoArray;
import kea2.utils.Notifier;
import kea2.core.memory.data.displayData.DisplayData;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.worker.communication.IWorkerComms;
import kea2.worker.communication.WorkerComms;
import kea2.worker.data.WorkerSharedProperties;
import kea2.worker.thread.atlas.AtlasPacker;
import kea2.worker.thread.display.WorkerDisplay;
import openfl.utils.Endian;
/**
 * ...
 * @author P.J.Shand
 */
@:access(kea2)
class WorkerDisplayList
{
	var workerGraphics:WorkerGraphics;
	var workerComms:IWorkerComms;
	public var transformDataMap:Map<Int, DisplayData> = new Map<Int, DisplayData>();
	//public var vertexDataMap:Map<Int, VertexData> = new Map<Int, VertexData>();
	
	
	public var stage:WorkerDisplay;
	public var map:Map<Int, WorkerDisplay> = new Map<Int, WorkerDisplay>();
	
	public var hierarchyAll = new GcoArray<WorkerDisplay>([]);
	public var hierarchy = new GcoArray<WorkerDisplay>([]);
	
	public function new(workerComms:IWorkerComms) 
	{
		this.workerComms = workerComms;
		workerGraphics = new WorkerGraphics(workerComms);
	}
	
	
	
	public function addChildAt(objectId:Int, renderId:Int, parentId:Int, addAtIndex:Int) 
	{
		/*var vertexData:VertexData = null;
		if (renderId != -1) vertexData = getVertexData(renderId);*/
		var workerDisplay:WorkerDisplay = new WorkerDisplay(getDisplayData(objectId));
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
	
	function getDisplayData(objectId:Int):DisplayData
	{
		var displayDataAccess:DisplayData = null;
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
		// Reset / Clear objects
		begin();
		
		// Builds the RenderTextures displaylist hierarchy and defines the order in which textures are used
		buildRenderTexturesHierarchy();
		
		// Builds the displaylist hierarchy and defines the order in which textures are used
		buildDisplayListHierarchy();
		
		// Based on the order in which textures are used, this works out how to draw textures into
		// a large texture atlas so a large number of display items can be draw in a single draw call
		createDynamicTextureAtlas();
		
		// Works out how to group textures together so multiple textures (currently 4) can be drawn in a single draw call
		quadBatchTextureDraws();
		
		// Writes data into VertexData byteArray for used in the Renderer class
		writeVertexData();
		
		// Close calculation phase
		end();
	}
	
	function begin() 
	{
		Conductor.conductorDataAccess.busy = 1;
		
		// Reset vertexData read position
		VertexData.OBJECT_POSITION = 0;
		AtlasVertexData.OBJECT_POSITION = 0;
		
		//if (WorkerCore.hierarchyBuildRequired) {
			this.hierarchyAll.clear();
		//}
		
		WorkerCore.textureOrder.begin();
	}
	
	function buildRenderTexturesHierarchy() 
	{
		// Loop through all renderTextures to check if there is content to render
		WorkerCore.renderTextureManager.update();
		//WorkerCore.textureOrder.renderTargetId = -1;
		RenderTexture.currentRenderTextureId = -1;
	}
	
	function buildDisplayListHierarchy() 
	{
		process(this.stage);
		WorkerCore.textureOrder.end();
	}
	
	function createDynamicTextureAtlas() 
	{
		WorkerCore.atlasPacker.update();
		this.checkAtlas();
	}
	
	function quadBatchTextureDraws() 
	{
		WorkerCore.textureRenderBatch.update(WorkerCore.textureOrder.textureDefArray);
	}
	
	function writeVertexData() 
	{
		this.setVertexData();
	}
	
	function end() 
	{
		Conductor.conductorDataAccess.busy = 0;
		Conductor.conductorDataAccess.frameIndex++;
		WorkerCore.hierarchyBuildRequired = false;
	}
	
	function process(root:WorkerDisplay) 
	{
		this.buildHierarchy(root);
		this.updateVertexData();
		this.setTextures();
	}
	
	public function buildHierarchy(root:WorkerDisplay) 
	{
		//if (WorkerCore.hierarchyBuildRequired) {
			hierarchy.clear();
			//numberOfRenderables = 0;
		//}
		if (root != null) {
			root.buildHierarchy(WorkerCore.hierarchyBuildRequired, this, workerGraphics);
		}
	}
	
	public function updateVertexData() 
	{
		for (k in 0...hierarchy.length) 
		{
			hierarchy[k].updateVertexData();
		}
	}
	
	public function setTextures() 
	{
		for (k in 0...hierarchy.length) 
		{
			hierarchy[k].setTextures();
		}
	}
	
	public function setVertexData() 
	{
		VertexData.OBJECT_POSITION = 0;
		//WorkerCore.textureOrder.begin();
		for (k in 0...hierarchyAll.length) 
		{
			hierarchyAll[k].setVertexData();
		}
		
		//WorkerCore.textureOrder.end();
		
		//if (WorkerCore.hierarchyBuildRequired) {
			Conductor.conductorDataAccess.numberOfRenderables = VertexData.OBJECT_POSITION;
		//}
	}
	
	public function checkAtlas() 
	{
		for (k in 0...hierarchyAll.length) 
		{
			hierarchyAll[k].checkAtlas();
		}
	}
}