package fuse.core.backend;
import fuse.core.assembler.input.Touchables;
import fuse.core.communication.messageData.StaticData;
import fuse.core.communication.messageData.TouchableMsg;
import fuse.core.communication.messageData.VisibleMsg;
import fuse.core.input.FrontMouseInput;
import fuse.core.input.Touch;

import fuse.Fuse;
import fuse.core.assembler.Assembler;
import fuse.core.assembler.input.InputAssembler;
import fuse.core.assembler.vertexWriter.VertexWriter;
import fuse.core.backend.Core;
import fuse.core.communication.messageData.AddMaskMsg;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.IWorkerComms;
import fuse.core.backend.Conductor;
import fuse.core.communication.messageData.AddChildMsg;
import fuse.info.WorkerInfo;
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
			Fuse.current.conductorData = new WorkerConductorData();
		}
		
		Core.init();
		
		workerComms.addListener(MessageType.UPDATE, OnUpdateMsg);
		workerComms.addListener(MessageType.ADD_CHILD, OnAddChild);
		workerComms.addListener(MessageType.ADD_CHILD_AT, OnAddChildAt);
		workerComms.addListener(MessageType.REMOVE_CHILD, OnRemoveChild);
		workerComms.addListener(MessageType.VISIBLE_CHANGE, OnVisibleChange);
		workerComms.addListener(MessageType.ADD_MASK, OnAddMask);
		workerComms.addListener(MessageType.REMOVE_MASK, OnRemoveMask);
		workerComms.addListener(MessageType.ADD_TEXTURE, OnAddTexture);
		workerComms.addListener(MessageType.UPDATE_TEXTURE, OnUpdateTexture);
		workerComms.addListener(MessageType.REMOVE_TEXTURE, OnRemoveTexture);
		workerComms.addListener(MessageType.MOUSE_INPUT, OnMouseInput);
		workerComms.addListener(MessageType.SET_TOUCHABLE, OnSetTouchable);
		workerComms.addListener(MessageType.SET_STATIC, OnSetStatic);
		
		index = workerComms.getSharedProperty(WorkerSharedProperties.INDEX);
		numberOfWorkers = workerComms.getSharedProperty(WorkerSharedProperties.NUMBER_OF_WORKERS);
		var framerate:Float = workerComms.getSharedProperty(WorkerSharedProperties.FRAME_RATE);
		Lib.current.stage.frameRate = framerate;
		Lib.current.stopAllMovieClips();
		
		Conductor.init(workerComms, index, numberOfWorkers, workerComms.usingWorkers);
		Conductor.onTick.add(OnTick);
		
		VertexWriter.init();
		Assembler.init();
		
		workerComms.send(MessageType.WORKER_STARTED);
	}
	
	function OnTick() 
	{
		Core.STAGE_WIDTH = Conductor.conductorData.stageWidth;
		Core.STAGE_HEIGHT = Conductor.conductorData.stageHeight;
		
		// Remove for New Assembler //
		//Core.assembler.update();
		
		Assembler.update();
		
		for (i in 0...InputAssembler.collisions.length) 
		{
			workerComms.send(MessageType.MOUSE_COLLISION, InputAssembler.collisions[i]);
		}
	}
	
	function OnAddMask(addChildPayload:AddMaskMsg) 
	{
		Core.displayList.addMask(addChildPayload);
	}
	
	function OnRemoveMask(workerPayload:WorkerPayload) 
	{
		var objectId:Int = workerPayload;
		Core.displayList.removeMask(objectId);
	}
	
	function OnAddTexture(textureId:Int):Void 
	{
		Core.textures.create(textureId);
	}

	function OnUpdateTexture(textureId:Int):Void 
	{
		Core.textures.update(textureId);
	}
	
	private function OnRemoveTexture(textureId:Int):Void 
	{
		Core.textures.dispose(textureId);
	}
	
	private function OnMouseInput(touch:Touch):Void 
	{
		InputAssembler.add(touch);
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
	
	function OnVisibleChange(visibleMsg:VisibleMsg) 
	{
		Core.displayList.visibleChange(visibleMsg.objectId, visibleMsg.visible);
	}
	
	
	private function OnSetTouchable(payload:TouchableMsg):Void 
	{
		Touchables.setTouchable(payload);
	}
	
	private function OnSetStatic(payload:StaticData):Void 
	{
		Core.displayList.setStatic(payload);
	}
	
	function OnUpdateMsg(workerPayload:WorkerPayload) 
	{
		workerComms.send(MessageType.UPDATE_RETURN);
		//OnTick();
	}
}