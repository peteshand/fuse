package kea.worker;

import flash.events.Event;
import flash.system.MessageChannel;
import flash.system.Worker;
import kea.worker.WorkerComms;
import openfl.Lib;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import kea.worker.data.MessageType;
import openfl.Vector;
import kea.worker.data.WorkerMessage;
import kea.worker.data.WorkerPayload;
import kea.worker.data.WorkerSharedProperties;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerEntryPoint
{
	private var numberOfWorkers:Int = 2;
	private var workerComms:WorkerComms;
	var index:Int;
	public var transformData:ByteArray;
	public var byteArray2:ByteArray;
	
    public function new()
    {
		workerComms = new WorkerComms();
		workerComms.add(MessageType.UPDATE, OnUpdateMsg);
        
		transformData = workerComms.worker.getSharedProperty(WorkerSharedProperties.BYTEARRAY);
		transformData.endian = Endian.LITTLE_ENDIAN;
		
		byteArray2 = workerComms.worker.getSharedProperty(WorkerSharedProperties.BYTEARRAY2);
		byteArray2.endian = Endian.LITTLE_ENDIAN;
		
		index = workerComms.worker.getSharedProperty(WorkerSharedProperties.INDEX);
		numberOfWorkers = workerComms.worker.getSharedProperty(WorkerSharedProperties.NUMBER_OF_WORKERS);
		var framerate:Float = workerComms.worker.getSharedProperty(WorkerSharedProperties.FRAME_RATE);
		Lib.current.stage.frameRate = framerate;
		//trace("index = " + index);
		
		//Delay.nextFrame(Tick);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, OnUpdate);
    }
	
	private function OnUpdate(e:Event):Void 
	{
		//transformData.position = 0;
		//transformData.writeFloat(Math.random());
		
		if (byteArray2.length > 0){
			byteArray2.position = 0;
			if (byteArray2.readInt() == index) {
				/*var count:Int = 0;
				for (i in 0...1000000) 
				{
					count++;
				}*/
				//trace("worker " + index);
				
				byteArray2.position = 0;
				var newIndex:Int = (index + 1) % numberOfWorkers;
				//trace("newIndex = " + newIndex);
				byteArray2.writeInt(newIndex);
			}
			
		}
		//Delay.nextFrame(Tick);
		//workerComms.send(MessageType.UPDATE);
	}
	
	function Tick() 
	{
		
    }
	
	function OnUpdateMsg(workerPayload:WorkerPayload) 
	{
		workerComms.send(MessageType.UPDATE_RETURN);
	}
}