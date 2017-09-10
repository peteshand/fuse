package fuse.core.backend;

import fuse.Fuse;
import fuse.core.backend.Core;
import fuse.core.communication.messageData.AddMaskMsg;
import fuse.core.front.memory.KeaMemory;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.communication.IWorkerComms;
import fuse.core.backend.Conductor;
import fuse.core.communication.messageData.AddChildMsg;
import openfl.Lib;
import openfl.events.Event;
import openfl.utils.ByteArray;
import fuse.core.communication.data.MessageType;
import fuse.core.communication.messageData.WorkerPayload;
import fuse.core.communication.data.WorkerSharedProperties;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class CoreEntryPoint
{
	private var numberOfWorkers:Int;
	private var workerComms:IWorkerComms;
	var index:Int;
	
    public function new(workerComms:IWorkerComms, numberOfWorkers:Int)
    {
		this.workerComms = workerComms;
		this.numberOfWorkers = numberOfWorkers;
		
		if (Fuse.current.keaMemory == null) {
			var memory:ByteArray = workerComms.getSharedProperty(WorkerSharedProperties.CORE_MEMORY);
			Fuse.current.keaMemory = new KeaMemory(memory);
			Fuse.current.conductorData = new ConductorData();
		}
		
		Core.init();
		
		workerComms.addListener(MessageType.UPDATE, OnUpdateMsg);
		workerComms.addListener(MessageType.ADD_CHILD, OnAddChild);
		workerComms.addListener(MessageType.ADD_CHILD_AT, OnAddChildAt);
		workerComms.addListener(MessageType.REMOVE_CHILD, OnRemoveChild);
		workerComms.addListener(MessageType.ADD_MASK, OnAddMask);
		workerComms.addListener(MessageType.REMOVE_MASK, OnRemoveMask);
		workerComms.addListener(MessageType.ADD_TEXTURE, OnAddTexture);
		workerComms.addListener(MessageType.REMOVE_TEXTURE, OnRemoveTexture);
		//workerComms.addListener(MessageType.ADD_TEXTURE, OnAddTexture);
		
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
		
		//Lib.current.stage.addEventListener(Event.ENTER_FRAME, OnUpdate);
		//trace("MessageType.WORKER_STARTED");
		
		
		workerComms.send(MessageType.WORKER_STARTED);
	}
	
	function OnTick() 
	{
		/*if (WorkerCore.STAGE_WIDTH != Conductor.conductorData.stageWidth) {
			trace("UPDATE DIMENSIONS");
		}*/
		Core.STAGE_WIDTH = Conductor.conductorData.stageWidth;
		Core.STAGE_HEIGHT = Conductor.conductorData.stageHeight;
		
		Core.displayListBuilder.update();
	}
	
	function OnAddMask(addChildPayload:AddMaskMsg) 
	{
		Core.displayList.addMask(addChildPayload.objectId, addChildPayload.maskId);
		//Core.hierarchyBuildRequired = true;
	}
	
	function OnRemoveMask(workerPayload:WorkerPayload) 
	{
		var objectId:Int = workerPayload;
		Core.displayList.removeMask(objectId);
		//Core.hierarchyBuildRequired = true;
	}
	
	private function OnAddTexture(textureId:Int):Void 
	{
		Core.textures.create(textureId);
	}
	
	private function OnRemoveTexture(textureId:Int):Void 
	{
		Core.textures.dispose(textureId);
	}
	
	function OnAddChild(addChildPayload:AddChildMsg) 
	{
		addChildPayload.addAtIndex = -1;
		OnAddChildAt(addChildPayload);
	}
	
	function OnAddChildAt(addChildPayload:AddChildMsg) 
	{
		Core.displayList.addChildAt(addChildPayload.objectId, addChildPayload.displayType, addChildPayload.parentId, addChildPayload.addAtIndex);
		Core.hierarchyBuildRequired = true;
	}
	
	function OnRemoveChild(workerPayload:WorkerPayload) 
	{
		var objectId:Int = workerPayload;
		Core.displayList.removeChild(objectId);
		Core.hierarchyBuildRequired = true;
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