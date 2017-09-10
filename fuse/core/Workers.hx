package fuse.core;

import fuse.Fuse;
import fuse.core.front.memory.KeaMemory;
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.display.DisplayObject;
import fuse.pool.Pool;

import fuse.core.communication.IWorkerComms;
import fuse.core.communication.WorkerlessComms;
#if flash
import fuse.core.communication.WorkerComms;
#end

import fuse.core.backend.CoreEntryPoint;
import msignal.Signal.Signal0;
import fuse.core.communication.data.MessageType;
import fuse.core.communication.messageData.WorkerPayload;
import fuse.core.communication.data.WorkerSharedProperties;

import flash.system.Worker;
import flash.concurrent.Condition;
import flash.concurrent.Mutex;

/**
 * ...
 * @author P.J.Shand
 */
class Workers
{
	private var numberOfWorkers:Int = 0;
	public static var syncThreads:Bool = false;
	private var workerComms:Array<IWorkerComms> = [];
	
	var count:Int = 0;
	
	public var onReady = new Signal0();
	var workerStartCount:Int = 0;
	
	public var condition:Condition;
	//var conductorData:ConductorData;
	
    public function new() { }
	
	public function init():Void
	{
		if (Worker.current.isPrimordial) {
			initWorkerControl();
		}
		else {
			new CoreEntryPoint(new WorkerComms(), numberOfWorkers);
		}
		Pool.init();
    }
	
	function initWorkerControl() 
	{
		trace("initWorkerControl");
		condition = new Condition(new Mutex());
		
		
		Fuse.current.keaMemory = new KeaMemory();
		
		Fuse.current.conductorData = new ConductorData();
		Fuse.current.conductorData.frameIndex = 0;
		
		var workerComm:IWorkerComms = null;
		if (numberOfWorkers == 0) {
			workerStartCount--;
			workerComm = new WorkerlessComms();
			setProperties(workerComm, 0);
			addListeners(workerComm);
			workerComms.push(workerComm);
		}
		else {
			for (i in 0...numberOfWorkers) 
			{
				workerComm = new WorkerComms();
				setProperties(workerComm, i);
				addListeners(workerComm);
				workerComms.push(workerComm);
			}
		}
		
		if (numberOfWorkers == 0) new CoreEntryPoint(workerComm, 0);
	}
	
	function setProperties(workerComm:IWorkerComms, i:Int) 
	{
		workerComm.setSharedProperty(WorkerSharedProperties.CONDITION, condition);
		workerComm.setSharedProperty(WorkerSharedProperties.CORE_MEMORY, KeaMemory.memory);
		workerComm.setSharedProperty(WorkerSharedProperties.INDEX, i);
		workerComm.setSharedProperty(WorkerSharedProperties.NUMBER_OF_WORKERS, numberOfWorkers);
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
		//trace("workerStartCount = " + workerStartCount);
		//trace("numberOfWorkers = " + numberOfWorkers);
		
		if (workerStartCount == numberOfWorkers) {
			onReady.dispatch();
			
			//Trigger();
			Fuse.enterFrame.add(OnUpdate);
		}
	}
	
	/*function Trigger() 
	{
		
	}*/
	
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
	
	private function OnUpdate():Void 
	{
		
		/*
		//trace("OnUpdate");
		//if (Fuse.current.conductorData.frameIndex == -1){
		//	count++;
		//	//Fuse.current.conductorData.index = count % numberOfWorkers;
		//	Fuse.current.conductorData.frameIndex = count % numberOfWorkers;
		//}
		
		
		//for (i in 0...workerComms.length) 
		//{
			
			//workerComm.send(MessageType.MAIN_THREAD_TICK);
		//}
		
		//Fuse.current.conductorData.frameIndex++;
		*/
		
		
		Fuse.current.conductorData.stageWidth = Fuse.current.stage.stageWidth;
		Fuse.current.conductorData.stageHeight = Fuse.current.stage.stageHeight;
		
		//workerComms[conductorData.frameIndex % workerComms.length].send(MessageType.MAIN_THREAD_TICK);
		
		//trace("OnUpdate");
		//if (Workers.syncThreads){
			//trace("WAIT");
			//condition.mutex.unlock();
			//condition.wait();
		//}
		
		
		//trace("count = " + conductorData.frameIndex);
		//trace("count = " + count);
		
		/*if (count == 120) {
			condition.mutex.lock();
			condition.notify();
			condition.mutex.unlock();
		}*/
		/*var displays:Array<Display> = Core2.current.displays;
		transformData.position = 0;
		for (i in 0...displays.length) 
		{
			for (j in 0...10000) 
			{
				transformData.readBytes(displays[i].transformData, i * displays[i].transformData.length, displays[i].transformData.length);
			}
		}*/
		//conductorData.position = 0;
		//trace(frame % 3);
		//conductorData.writeInt(frame++%3);
	}
	
	function OnUpdateReturn(workerPayload:WorkerPayload) 
	{
		
	}
}

#if !flash
typedef WorkerComms = WorkerlessComms;
#else

#end