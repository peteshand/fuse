package fuse.core;

import fuse.Fuse;
import openfl.events.Event;
import fuse.texture.TextureId;
import fuse.utils.ObjectId;
import fuse.display.Stage;
import fuse.display.DisplayObject;
import fuse.display.DisplayObjectContainer;
import fuse.input.Touch;
import fuse.core.front.texture.TextureRef;
import fuse.core.communication.messageData.StaticData;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.info.WorkerInfo;
import fuse.core.utils.Pool;

import fuse.core.communication.IWorkerComms;
import fuse.core.communication.WorkerlessComms;
import fuse.utils.GcoArray;

#if air
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
	var touchables = new Map<Int, DisplayObject>();
	var workerComms:Array<IWorkerComms> = [];
	//var staticChanges = new Map<Int, DisplayObject>();
	var staticChanges = new GcoArray<DisplayObject>();
	var count:Int = 0;
	var staticData:StaticData = { };
	
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
		var display:DisplayObject = touchables.get(touch.targetId);
		if (display == null) return;
		touch.target = display;
		display.dispatchInput(touch);
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
	
	public function addMask(display:DisplayObject, displayType:Int, mask:DisplayObject, maskDisplayType:Int) 
	{
		var maskId:Int = -1;
		if (mask != null) maskId = mask.objectId;
		send(MessageType.ADD_MASK, { 
			objectId:display.objectId, 
			displayType:displayType, 
			maskId:maskId, 
			maskDisplayType:maskDisplayType
		} );
	}
	
	public function removeMask(display:DisplayObject) 
	{
		send(MessageType.REMOVE_MASK, display.objectId);
	}
	
	public function addChild(child:DisplayObject, parent:DisplayObject) 
	{
		addChildAt(child, -1, parent);
	}
	
	public function addChildAt(child:DisplayObject, addAtIndex:Int, parent:DisplayObject) 
	{
		var parentId:Int = -1;
		if (parent != null) parentId = parent.objectId;
		send(MessageType.ADD_CHILD, { 
			objectId:child.objectId, 
			displayType:child.displayType, 
			parentId:parentId, 
			addAtIndex:addAtIndex
		} );
		setStatic(child);
	}

	public function setChildIndex(child:DisplayObject, index:Int, parent:DisplayObjectContainer):Void
	{
		var parentId:Int = parent.objectId;
		send(MessageType.SET_CHILD_INDEX, { 
			objectId:child.objectId, 
			displayType:child.displayType, 
			parentId:parentId, 
			index:index
		} );
		setStatic(parent);
	}
	
	public function removeChild(child:DisplayObject) 
	{
		send(MessageType.REMOVE_CHILD, child.objectId);
	}
	
	public function visibleChange(child:DisplayObject, visible:Bool) 
	{
		send(MessageType.VISIBLE_CHANGE, { 
			objectId:child.objectId, 
			visible:visible
		});
	}
	
	public function addTexture(textureRef:TextureRef) 
	{
		send(MessageType.ADD_TEXTURE, textureRef);
	}

	public function updateTexture(objectId:ObjectId) 
	{
		send(MessageType.UPDATE_TEXTURE, objectId);
	}
	
	public function removeTexture(objectId:ObjectId) 
	{
		send(MessageType.REMOVE_TEXTURE, objectId);
	}
	
	public function setTouchable(displayObject:DisplayObject, value:Null<Bool>) 
	{
		if (value) touchables.set(displayObject.objectId, displayObject);
		else touchables.remove(displayObject.objectId);
		
		send(MessageType.SET_TOUCHABLE, { 
			objectId:displayObject.objectId, 
			displayType:displayObject.displayType, 
			touchable:value
		} );
	}
	
	public function addInput(touch:Touch) 
	{
		send(MessageType.MOUSE_INPUT, touch);
	}
	
	public function setStatic(displayObject:DisplayObject) 
	{
		Fuse.current.conductorData.frontStaticCount = 0;
		staticChanges[displayObject.objectId] = displayObject;
		//Fuse.current.conductorData.backIsStatic = 0;
		//staticChanges.set(displayObject.objectId, displayObject);
		//staticChanges.push(displayObject);
		//trace("1 staticChanges.length = " + staticChanges.length);
	}
	
	inline function send(name:String, payload:WorkerPayload = null) 
	{
		for (workerComm in workerComms) 
		{
			workerComm.send(name, payload);
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
	
	public function update() 
	{
		send(MessageType.UPDATE, null);
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
	
	public function sendQue() 
	{
		//trace("sendQue: " + staticChanges.length);
		for (i in 0...staticChanges.length) 
		{
			var displayObject:DisplayObject = staticChanges[i];
			if (displayObject == null) continue;
			
			staticData.objectId = displayObject.objectId;
			staticData.updateAny = displayObject.updatePosition || displayObject.updateRotation || displayObject.updateColour || displayObject.updateVisible || displayObject.updateAlpha || displayObject.updateTexture;
			staticData.updatePosition = displayObject.updatePosition;
			staticData.updateRotation = displayObject.updateRotation;
			staticData.updateColour = displayObject.updateColour;
			staticData.updateVisible = displayObject.updateVisible;
			staticData.updateAlpha = displayObject.updateAlpha;
			staticData.updateTexture = displayObject.updateTexture;
			
			send(MessageType.SET_STATIC, staticData);
			
			displayObject.resetMovement();
			staticChanges[i] = null;
		}
		staticChanges.length = 0;
		
	}
	
	function OnUpdateReturn(workerPayload:WorkerPayload) 
	{
		
	}
}

#if !flash
typedef WorkerComms = WorkerlessComms;
#else

#end