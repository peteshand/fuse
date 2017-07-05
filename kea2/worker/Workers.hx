package kea2.worker;
import com.imagination.delay.Delay;
import flash.system.Worker;
import kea.display.Sprite;
import kea2.core.memory.KeaMemory;
import kea2.core.memory.data.conductorData.ConductorData;
import kea2.texture.ITexture;
//import kea2.core.memory.vertexData.VertexData;
import kea2.worker.communication.IWorkerComms;
import kea2.display.containers.IDisplay;
import kea2.worker.communication.WorkerComms;
import kea2.worker.communication.WorkerlessComms;
import kea2.worker.thread.WorkerEntryPoint;
import msignal.Signal.Signal0;
import openfl.Assets;
import openfl.Lib;
import openfl.Memory;
import openfl.Vector;
import openfl.events.Event;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import kea2.worker.data.MessageType;
import kea2.worker.data.WorkerMessage;
import kea2.worker.data.WorkerPayload;
import kea2.worker.data.WorkerSharedProperties;

import flash.concurrent.Condition;
import flash.concurrent.Mutex;

/**
 * ...
 * @author P.J.Shand
 */
class Workers
{
	public static var syncThreads:Bool = false;
	private var workerComms:Array<IWorkerComms> = [];
	
	var count:Int = 0;
	
	private var numberOfWorkers:Int = 0;
	
	public var onReady = new Signal0();
	var workerStartCount:Int = 0;
	
	var condition:Condition;
	var conductorDataAccess:ConductorData;
	
    public function new()
    {
		
	}
	
	public function init():Void
	{
		if (Worker.current.isPrimordial) {
			initWorkerControl();
		}
		else {
			new WorkerEntryPoint(new WorkerComms(), numberOfWorkers);
		}
    }
	
	function initWorkerControl() 
	{
		var mutex:Mutex = new Mutex();
		mutex.lock();
		condition = new Condition(mutex);
		
		Kea.current.keaMemory = new KeaMemory();
		
		conductorDataAccess = new ConductorData();
		conductorDataAccess.frameIndex = 0;
		/*conductorData = new ConductorData();
		conductorData.endian = Endian.LITTLE_ENDIAN;
		conductorData.shareable = true;
		conductorData.index = 0;*/
		
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
		
		if (numberOfWorkers == 0) new WorkerEntryPoint(workerComm, 0);
		
		//Delay.nextFrame(Tick);
		
		//condition.wait();
		
		
		
		//CheckStartCount();
	}
	
	function setProperties(workerComm:IWorkerComms, i:Int) 
	{
		workerComm.setSharedProperty(WorkerSharedProperties.CONDITION, condition);
		//workerComm.setSharedProperty(WorkerSharedProperties.TRANSFORM_DATA, transformData);
		workerComm.setSharedProperty(WorkerSharedProperties.CORE_MEMORY, KeaMemory.memory);
		//workerComm.setSharedProperty(WorkerSharedProperties.CONDUCTOR_DATA, conductorData);
		//workerComm.setSharedProperty(WorkerSharedProperties.VERTEX_DATA, vertexData);
		//workerComm.setSharedProperty(WorkerSharedProperties.DISPLAY_DATA, displayData);
		
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
		if (workerStartCount == numberOfWorkers) {
			onReady.dispatch();
			
			//Trigger();
			Kea.enterFrame.add(OnUpdate);
		}
	}
	
	/*function Trigger() 
	{
		
	}*/
	
	public function addChild(child:IDisplay, parent:IDisplay) 
	{
		addChildAt(child, -1, parent);
	}
	
	public function addChildAt(child:IDisplay, addAtIndex:Int, parent:IDisplay) 
	{
		for (workerComm in workerComms) 
		{
			
			//workerComm.setSharedProperty(WorkerSharedProperties.DISPLAY + child.objectId, child.displayData);
			var parentId:Int = -1;
			if (parent != null) parentId = parent.objectId;
			workerComm.send(MessageType.ADD_CHILD, { objectId:child.objectId, renderId:child.renderId, parentId:parentId, addAtIndex:addAtIndex } );
		}
	}
	
	public function removeChild(child:IDisplay) 
	{
		for (workerComm in workerComms) 
		{
			workerComm.send(MessageType.ADD_CHILD, child.objectId);
		}
	}
	
	/*public function addTexture(texture:ITexture) 
	{
		for (workerComm in workerComms) 
		{
			workerComm.send(MessageType.ADD_TEXTURE, texture.textureId );
		}
	}*/
	
	private function OnUpdate():Void 
	{
		if (Workers.syncThreads){
			//trace("WAIT");
			condition.wait();
		}
		/*
		//trace("OnUpdate");
		//if (conductorDataAccess.frameIndex == -1){
		//	count++;
		//	//conductorData.index = count % numberOfWorkers;
		//	conductorDataAccess.frameIndex = count % numberOfWorkers;
		//}
		
		
		//for (i in 0...workerComms.length) 
		//{
			
			//workerComm.send(MessageType.MAIN_THREAD_TICK);
		//}
		
		//conductorDataAccess.frameIndex++;
		*/
		
		
		conductorDataAccess.stageWidth = Kea.current.stage.stageWidth;
		conductorDataAccess.stageHeight = Kea.current.stage.stageHeight;
		
		workerComms[conductorDataAccess.frameIndex % workerComms.length].send(MessageType.MAIN_THREAD_TICK);
		
		
		
		
		//trace("count = " + conductorDataAccess.frameIndex);
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
	
	function Tick() 
	{
		//transformData.position = 0;
		//transformData.writeFloat(Math.random());
		
		//transformData.position = 0;
		//trace(transformData.readFloat());
		
		//Delay.nextFrame(Tick);
		//workerComms.send(MessageType.UPDATE);
	}
	
	function OnUpdateReturn(workerPayload:WorkerPayload) 
	{
		
	}
}