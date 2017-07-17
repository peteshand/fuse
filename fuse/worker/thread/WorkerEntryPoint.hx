package fuse.worker.thread;

import com.imagination.delay.Delay;
import fuse.Fuse;
import fuse.core.memory.KeaMemory;
import fuse.core.memory.data.conductorData.ConductorData;
import fuse.worker.communication.IWorkerComms;
import fuse.worker.thread.Conductor;
import fuse.worker.data.AddChild;
import openfl.Lib;
import openfl.events.Event;
import openfl.utils.ByteArray;
import fuse.worker.data.MessageType;
import fuse.worker.data.WorkerPayload;
import fuse.worker.data.WorkerSharedProperties;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class WorkerEntryPoint
{
	private var numberOfWorkers:Int;
	private var workerComms:IWorkerComms;
	var index:Int;
	
    public function new(workerComms:IWorkerComms, numberOfWorkers:Int)
    {
		this.workerComms = workerComms;
		this.numberOfWorkers = numberOfWorkers;
		
		workerComms.addListener(MessageType.UPDATE, OnUpdateMsg);
		workerComms.addListener(MessageType.ADD_CHILD, OnAddChild);
		workerComms.addListener(MessageType.ADD_CHILD_AT, OnAddChildAt);
		workerComms.addListener(MessageType.REMOVE_CHILD, OnRemoveChild);
		//workerComms.addListener(MessageType.ADD_TEXTURE, OnAddTexture);
		
		if (Fuse.current.keaMemory == null) {
			var memory:ByteArray = workerComms.getSharedProperty(WorkerSharedProperties.CORE_MEMORY);
			Fuse.current.keaMemory = new KeaMemory(memory);
			Fuse.current.conductorData = new ConductorData();
		}
		
		WorkerCore.init(workerComms);
		
		index = workerComms.getSharedProperty(WorkerSharedProperties.INDEX);
		numberOfWorkers = workerComms.getSharedProperty(WorkerSharedProperties.NUMBER_OF_WORKERS);
		var framerate:Float = workerComms.getSharedProperty(WorkerSharedProperties.FRAME_RATE);
		Lib.current.stage.frameRate = framerate;
		Lib.current.stopAllMovieClips();
		
		Conductor.init(workerComms, index, numberOfWorkers, workerComms.usingWorkers);
		Conductor.onTick.add(OnTick);
		
		//byteArray2.position = 0;
		//if (byteArray2.readInt() == index) {
			////condition.mutex.lock();
			//Lib.current.stage.addEventListener(Event.ENTER_FRAME, OnUpdate);
		//}
		//else {
			////condition.wait();
		//}
		
		
		
		//condition.mutex.lock();
		//condition.wait();
		
		//trace("wait complete");
		
		//Delay.nextFrame(Tick);
		//Lib.current.stage.addEventListener(Event.ENTER_FRAME, OnUpdate);
		//trace("MessageType.WORKER_STARTED");
		
		
		workerComms.send(MessageType.WORKER_STARTED);
	}
	
	function OnTick() 
	{
		WorkerCore.STAGE_WIDTH = Conductor.conductorData.stageWidth;
		WorkerCore.STAGE_HEIGHT = Conductor.conductorData.stageHeight;
		
		//trace("OnTick: " + index);
		
		/*
		 * Loop through whole displaylist in a Hierarchical order and calculate their transform matrix
		 * TODO: skip items that are currently in cached layer
		*/
		//workerDisplayList.buildHierarchy();	// Hierarchical
		
		/*
		 * - Loops through whole displaylist in linear order and updates isStatic
		 * - If Renderer.layerStateChangeAvailable == true
		 * -- Order displaylist by layerIndex > low to high
		 * -- Group displaylist items into cache and direct render layers
		 * Calculate cache vs direct layers
		*/
		//workerLayerConstruct.update();
		
		// Calculate texture draw order and generate atlas buffers
		//logic.atlasBuffer.update();		// Linear
		
		// Draw renderables in linear order (cache and direct layers)
		//logic.renderer.render(g2);		// Linear
		
		//if (Conductor.conductorData.processIndex % numberOfWorkers == index){
			//if (index == 0) trace("Mod = " + (Math.floor(Conductor.conductorData.frameIndex % numberOfWorkers)));
			//if (Conductor.conductorData.frameIndex % numberOfWorkers == index){
				
				//Conductor.conductorData.busy = 1;
				//
				//workerDisplayList.buildHierarchy();
				//
				//
				//
				//workerDisplayList.updateVertexData();
				//
				//
				//
				//VertexData.OBJECT_POSITION = 0;
				//workerDisplayList.setVertexData();
				//
				//renderTextureManager.update();
				//
				//atlasPacker.update();
				//
				//Conductor.conductorData.busy = 0;
				//
				//Conductor.conductorData.frameIndex++;
				//hierarchyBuildRequired = false;
			//}
		//}
		
		WorkerCore.workerDisplayList.update();
	}
	
	function OnAddChild(addChildPayload:AddChild) 
	{
		addChildPayload.addAtIndex = -1;
		OnAddChildAt(addChildPayload);
	}
	
	function OnAddChildAt(addChildPayload:AddChild) 
	{
		var objectId:Int = addChildPayload.objectId;
		var renderId:Int = addChildPayload.renderId;
		var parentId:Int = addChildPayload.parentId;
		var addAtIndex:Int = addChildPayload.addAtIndex;
		
		/*var transformData:TransformData = workerComms.worker.getSharedProperty(WorkerSharedProperties.DISPLAY + objectId);
		transformData.endian = Endian.LITTLE_ENDIAN;
		
		workerDisplayList.addChild(new WorkerDisplay(transformData));*/
		WorkerCore.workerDisplayList.addChildAt(objectId, renderId, parentId, addAtIndex);
		WorkerCore.hierarchyBuildRequired = true;
	}
	
	function OnRemoveChild(workerPayload:WorkerPayload) 
	{
		var objectId:Int = workerPayload;
		WorkerCore.workerDisplayList.removeChild(objectId);
		WorkerCore.hierarchyBuildRequired = true;
	}
	
	/*private function OnAddTexture(workerPayload:WorkerPayload):Void 
	{
		var textureId:Int = workerPayload;
	}*/
	
	function OnUpdateMsg(workerPayload:WorkerPayload) 
	{
		workerComms.send(MessageType.UPDATE_RETURN);
	}
	
	private function OnUpdate(e:Event):Void 
	{
		//transformData.position = 0;
		//transformData.writeFloat(Math.random());
		return;
		//condition.mutex.lock();
		//var locked:Bool = condition.mutex.tryLock();
		//trace("locked = " + locked + " - " + index);
		//if (couldLock){
			//if (byteArray2.length > 0){
				//byteArray2.position = 0;
				//if (byteArray2.readInt() == index) {
					//
					//var count:Int = 0;
					//for (i in 0...1000000) 
					//{
						//count++;
					//}
					//trace("worker " + index);
					//
					//byteArray2.position = 0;
					//var newIndex:Int = (index + 1) % numberOfWorkers;
					////trace("newIndex = " + newIndex);
					//byteArray2.writeInt(newIndex);
				//}
				//
			////}
			//
			////condition.notify();
			//
			////condition.mutex.unlock();
			////
			////condition.wait();
			//trace("wait complete");
		////}
		////else {
		////	condition.wait();
		////}
		//
		//trace("worker " + index + " waiting");
		//Delay.nextFrame(Tick);
		//workerComms.send(MessageType.UPDATE);
	}
	
	function Tick() 
	{
		
    }
	
}