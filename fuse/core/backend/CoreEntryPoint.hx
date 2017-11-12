package fuse.core.backend;

import fuse.Fuse;
import fuse.core.backend.Core;
import fuse.core.communication.messageData.AddMaskMsg;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.communication.IWorkerComms;
import fuse.core.backend.Conductor;
import fuse.core.communication.messageData.AddChildMsg;
import fuse.core.utils.WorkerInfo;
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
		
		if (Fuse.current.sharedMemory == null) {
			var memory:ByteArray = workerComms.getSharedProperty(WorkerSharedProperties.CORE_MEMORY);
			Fuse.current.sharedMemory = new SharedMemory(memory);
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
		
		index = workerComms.getSharedProperty(WorkerSharedProperties.INDEX);
		numberOfWorkers = workerComms.getSharedProperty(WorkerSharedProperties.NUMBER_OF_WORKERS);
		var framerate:Float = workerComms.getSharedProperty(WorkerSharedProperties.FRAME_RATE);
		Lib.current.stage.frameRate = framerate;
		Lib.current.stopAllMovieClips();
		
		Conductor.init(workerComms, index, numberOfWorkers, workerComms.usingWorkers);
		Conductor.onTick.add(OnTick);
		
		workerComms.send(MessageType.WORKER_STARTED);
	}
	
	function OnTick() 
	{
		Core.STAGE_WIDTH = Conductor.conductorData.stageWidth;
		Core.STAGE_HEIGHT = Conductor.conductorData.stageHeight;
		
		Core.displayListBuilder.update();
	}
	
	function OnAddMask(addChildPayload:AddMaskMsg) 
	{
		Core.displayList.addMask(addChildPayload.objectId, addChildPayload.maskId);
	}
	
	function OnRemoveMask(workerPayload:WorkerPayload) 
	{
		var objectId:Int = workerPayload;
		Core.displayList.removeMask(objectId);
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
	}
	
	function OnRemoveChild(workerPayload:WorkerPayload) 
	{
		var objectId:Int = workerPayload;
		Core.displayList.removeChild(objectId);
	}
	
	function OnUpdateMsg(workerPayload:WorkerPayload) 
	{
		workerComms.send(MessageType.UPDATE_RETURN);
	}
}