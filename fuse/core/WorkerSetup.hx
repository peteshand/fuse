package fuse.core;

import fuse.Fuse;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.utils.WorkerInfo;
import fuse.display.DisplayObject;
import fuse.pool.Pool;

import fuse.core.communication.IWorkerComms;
import fuse.core.communication.WorkerlessComms;

#if flash
import fuse.core.communication.WorkerComms;
import flash.system.Worker;
import flash.concurrent.Condition;
import flash.concurrent.Mutex;
#end

import fuse.core.backend.CoreEntryPoint;
import msignal.Signal.Signal0;
import fuse.core.communication.data.MessageType;
import fuse.core.communication.messageData.WorkerPayload;
import fuse.core.communication.data.WorkerSharedProperties;



/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class WorkerSetup
{
	private var workerComms:Array<IWorkerComms> = [];
	
	var count:Int = 0;
	
	public var onReady = new Signal0();
	var workerStartCount:Int = 0;
	
	#if flash
	public var condition:Condition;
	#end
	
    public function new() { }
	
	public function init():Void
	{
		// Override
    }
	
	function setProperties(workerComm:IWorkerComms, i:Int) 
	{
		#if flash
		workerComm.setSharedProperty(WorkerSharedProperties.CONDITION, condition);
		#end
		
		workerComm.setSharedProperty(WorkerSharedProperties.CORE_MEMORY, SharedMemory.memory);
		workerComm.setSharedProperty(WorkerSharedProperties.INDEX, i);
		workerComm.setSharedProperty(WorkerSharedProperties.NUMBER_OF_WORKERS, WorkerInfo.numberOfWorkers);
		workerComm.setSharedProperty(WorkerSharedProperties.FRAME_RATE, 60);
	}
	
	function addListeners(workerComm:IWorkerComms) 
	{
		workerComm.addListener(MessageType.UPDATE_RETURN, OnUpdateReturn);
		workerComm.addListener(MessageType.WORKER_STARTED, OnWorkerStarted);
	}
	
	private function OnWorkerStarted(workerPayload:WorkerPayload):Void 
	{
		workerStartCount++;
		CheckStartCount();
	}
	
	function CheckStartCount() 
	{
		if (workerStartCount == WorkerInfo.numberOfWorkers) {
			onReady.dispatch();
			
			Fuse.current.enterFrame.add(OnUpdate);
		}
	}
	
	public function addMask(display:DisplayObject, mask:DisplayObject) 
	{
		for (workerComm in workerComms) 
		{
			var maskId:Int = -1;
			if (mask != null) maskId = mask.objectId;
			workerComm.send(MessageType.ADD_MASK, { 
				objectId:display.objectId, 
				maskId:maskId
			} );
		}
	}
	
	public function removeMask(display:DisplayObject) 
	{
		for (workerComm in workerComms) 
		{
			workerComm.send(MessageType.REMOVE_MASK, display.objectId);
		}
	}
	
	public function addChild(child:DisplayObject, parent:DisplayObject) 
	{
		addChildAt(child, -1, parent);
	}
	
	public function addChildAt(child:DisplayObject, addAtIndex:Int, parent:DisplayObject) 
	{
		for (workerComm in workerComms) 
		{
			var parentId:Int = -1;
			if (parent != null) parentId = parent.objectId;
			workerComm.send(MessageType.ADD_CHILD, { 
				objectId:child.objectId, 
				displayType:child.displayType, 
				parentId:parentId, 
				addAtIndex:addAtIndex
			} );
		}
	}
	
	public function removeChild(child:DisplayObject) 
	{
		for (workerComm in workerComms) 
		{
			workerComm.send(MessageType.REMOVE_CHILD, child.objectId);
		}
	}
	
	public function addTexture(textureId:Int) 
	{
		for (workerComm in workerComms) 
		{
			workerComm.send(MessageType.ADD_TEXTURE, textureId);
		}
	}
	
	public function removeTexture(textureId:Int) 
	{
		for (workerComm in workerComms) 
		{
			workerComm.send(MessageType.REMOVE_TEXTURE, textureId);
		}
	}
	
	public function lock() 
	{
		#if flash
			if (WorkerInfo.usingWorkers){
				condition.mutex.lock();
			}
		#end
	}
	
	public function unlock() 
	{
		#if flash
			if (WorkerInfo.usingWorkers) {
				condition.notifyAll();
				condition.mutex.unlock();
			}
		#end
	}
	
	private function OnUpdate():Void 
	{
		Fuse.current.conductorData.stageWidth = Fuse.current.stage.stageWidth;
		Fuse.current.conductorData.stageHeight = Fuse.current.stage.stageHeight;
	}
	
	function OnUpdateReturn(workerPayload:WorkerPayload) 
	{
		
	}
}

#if !flash
typedef WorkerComms = WorkerlessComms;
#else

#end