package fuse.core;
import fuse.core.input.FrontMouseInput;
import fuse.core.input.Touch;

import flash.events.Event;
import fuse.Fuse;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.info.WorkerInfo;
import fuse.display.DisplayObject;
import fuse.core.utils.Pool;
import fuse.display.DisplayObjectContainer;
import fuse.display.Stage;

import fuse.core.communication.IWorkerComms;
import fuse.core.communication.WorkerlessComms;

#if air
import fuse.core.communication.WorkerComms;
import flash.system.Worker;
import flash.concurrent.Condition;
import flash.concurrent.Mutex;
#end

import fuse.core.backend.CoreEntryPoint;
import fuse.signal.Signal0;
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
	
	#if air
	public var condition:Condition;
	#end
	
    public function new() { }
	
	public function init():Void
	{
		// Override
    }
	
	function setProperties(workerComm:IWorkerComms, i:Int) 
	{
		#if air
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
		workerComm.addListener(MessageType.MOUSE_COLLISION, OnInputCollision);
	}
	
	private function OnInputCollision(touch:Touch):Void 
	{
		//trace([touch.type, touch.x, touch.y]);
		findDisplay(touch, Fuse.current.stage);
	}
	
	// TODO: move into it's own class
	function findDisplay(touch:Touch, display:DisplayObject):Bool
	{
		if (touch.collisionId == display.objectId) {
			//trace("FOUND: " + display);
			touch.target = display;
			display.dispatchInput(touch);
			return true;
		}
		if (Std.is(display, DisplayObjectContainer)){
			var d:DisplayObjectContainer = cast (display, DisplayObjectContainer);
			for (i in 0...d.children.length) 
			{
				if (findDisplay(touch, d.children[i])) {
					return true;
				}
			}
		}
		
		return false;
		
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
	
	public function setTouchable(displayObject:DisplayObject, value:Bool) 
	{
		for (workerComm in workerComms) 
		{
			workerComm.send(MessageType.SET_TOUCHABLE, { 
				objectId:displayObject.objectId, 
				touchable:value
			} );
		}
	}
	
	public function addInput(touch:Touch) 
	{
		for (workerComm in workerComms) 
		{
			workerComm.send(MessageType.MOUSE_INPUT, touch);
		}
	}
	
	public function lock() 
	{
		#if air
			if (WorkerInfo.usingWorkers){
				condition.mutex.lock();
			}
		#end
	}
	
	public function unlock() 
	{
		#if air
			if (WorkerInfo.usingWorkers) {
				condition.notifyAll();
				condition.mutex.unlock();
			}
		#end
	}
	
	function OnUpdateReturn(workerPayload:WorkerPayload) 
	{
		
	}
}

#if !flash
typedef WorkerComms = WorkerlessComms;
#else

#end