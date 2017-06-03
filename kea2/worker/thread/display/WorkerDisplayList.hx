package kea2.worker.thread.display;

import kea.notify.Notifier;
import kea2.core.memory.data.displayData.DisplayData;
import kea2.core.memory.data.vertexData.VertexData;
import kea2.worker.communication.IWorkerComms;
import kea2.worker.communication.WorkerComms;
import kea2.worker.data.WorkerSharedProperties;
import kea2.worker.thread.display.WorkerDisplay;
import openfl.utils.Endian;
/**
 * ...
 * @author P.J.Shand
 */
class WorkerDisplayList
{
	var workerGraphics:WorkerGraphics;
	var workerComms:IWorkerComms;
	public var transformDataMap:Map<Int, DisplayData> = new Map<Int, DisplayData>();
	public var vertexDataMap:Map<Int, VertexData> = new Map<Int, VertexData>();
	
	
	var root:WorkerDisplay;
	public var map:Map<Int, WorkerDisplay> = new Map<Int, WorkerDisplay>();
	
	public var hierarchy:Array<WorkerDisplay>;
	public var numberOfRenderables:Int;
	
	var textureOrder:TextureOrder;
	
	
	public function new(workerComms:IWorkerComms) 
	{
		this.workerComms = workerComms;
		workerGraphics = new WorkerGraphics(workerComms);
		textureOrder = new TextureOrder();
	}
	
	
	
	public function addChildAt(objectId:Int, renderId:Int, parentId:Int, addAtIndex:Int) 
	{
		
		var vertexData:VertexData = null;
		if (renderId != -1) vertexData = getVertexData(renderId);
		var workerDisplay:WorkerDisplay = new WorkerDisplay(textureOrder, getDisplayData(objectId), vertexData);
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
			root = workerDisplay;
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
	
	function getVertexData(renderId:Int):VertexData
	{
		var vertexData:VertexData = null;
		if (!vertexDataMap.exists(renderId)) {
			vertexData = new VertexData(renderId);
			//vertexData = workerComms.getSharedProperty(WorkerSharedProperties.DISPLAY + objectId);
			//vertexData.endian = Endian.LITTLE_ENDIAN;
			vertexDataMap.set(renderId, vertexData);
		}
		return vertexDataMap.get(renderId);
	}
	
	public function removeChild(objectId:Int) 
	{
		var workerDisplay:WorkerDisplay = map.get(objectId);
		if (workerDisplay == null) return;
		
		if (workerDisplay.parent != null) {
			workerDisplay.parent.removeChild(workerDisplay);
		}
		transformDataMap.remove(objectId);
		vertexDataMap.remove(objectId);
		map.remove(objectId);
	}
	
	/*public function buildHierarchy() 
	{
		hierarchy = [];
		if (root != null) {
			root.buildHierarchy(this);
		}
	}*/
	
	public function buildTransformData() 
	{
		if (WorkerEntryPoint.hierarchyBuildRequired) {
			hierarchy = [];
			numberOfRenderables = 0;
		}
		if (root != null) {
			root.buildTransformData(WorkerEntryPoint.hierarchyBuildRequired, this, workerGraphics);
		}
		
		/*for (j in 0...hierarchy.length) 
		{
			hierarchy[j].buildTransformData(this, workerGraphics);
		}*/
	}
	
	public function updateVertexData() 
	{
		for (k in 0...hierarchy.length) 
		{
			hierarchy[k].updateVertexData(workerGraphics);
		}
	}
	
	public function setVertexData() 
	{
		textureOrder.begin();
		
		for (k in 0...hierarchy.length) 
		{
			hierarchy[k].setVertexData(workerGraphics);
		}
		
		textureOrder.end();
		
		if (WorkerEntryPoint.hierarchyBuildRequired) {
			Conductor.conductorDataAccess.numberOfRenderables = numberOfRenderables;
		}
	}
}