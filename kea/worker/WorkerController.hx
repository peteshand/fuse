package kea.worker;

import flash.display.Stage;
import flash.events.Event;
import flash.system.MessageChannel;
import flash.system.Worker;
import flash.system.WorkerDomain;
import kea.worker.WorkerComms;
import openfl.Assets;
import openfl.Lib;
import openfl.Vector;
import openfl.utils.ByteArray;
import openfl.utils.Endian;
import kea.worker.data.MessageType;
import kea.worker.data.WorkerMessage;
import kea.worker.data.WorkerPayload;
import kea.worker.data.WorkerSharedProperties;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerController
{
	private var workerComms:WorkerComms;
	
	//private var worker:Worker;
    //private var mainToBack:MessageChannel;
    //private var backToMain:MessageChannel;
    //private var sentObject:Dynamic;
	
	private var numberOfWorkers:Int = 2;
	public var transformData:ByteArray;
	public var byteArray2:ByteArray;
	
    public function new()
    {
		
		transformData = new ByteArray();
		transformData.endian = Endian.LITTLE_ENDIAN;
		transformData.shareable = true;
		transformData.position = 0;
		transformData.writeFloat(Math.random());
		transformData.length = 36 * 10000;
		
		byteArray2 = new ByteArray();
		byteArray2.endian = Endian.LITTLE_ENDIAN;
		byteArray2.shareable = true;
		byteArray2.position = 0;
		byteArray2.writeInt(0);
		
		for (i in 0...numberOfWorkers) 
		{
			workerComms = new WorkerComms();
			workerComms.worker.setSharedProperty(WorkerSharedProperties.BYTEARRAY, transformData);
			workerComms.worker.setSharedProperty(WorkerSharedProperties.BYTEARRAY2, byteArray2);
			workerComms.worker.setSharedProperty(WorkerSharedProperties.INDEX, i);
			workerComms.worker.setSharedProperty(WorkerSharedProperties.NUMBER_OF_WORKERS, numberOfWorkers);
			workerComms.worker.setSharedProperty(WorkerSharedProperties.FRAME_RATE, 60);
			workerComms.add(MessageType.UPDATE_RETURN, OnUpdateReturn);
		}
		
		
		//Delay.nextFrame(Tick);
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, OnUpdate);
    }
	
	private function OnUpdate(e:Event):Void 
	{
		/*var displays:Array<Display> = Core2.current.displays;
		transformData.position = 0;
		for (i in 0...displays.length) 
		{
			for (j in 0...10000) 
			{
				transformData.readBytes(displays[i].transformData, i * displays[i].transformData.length, displays[i].transformData.length);
			}
		}*/
		//byteArray2.position = 0;
		//trace(frame % 3);
		//byteArray2.writeInt(frame++%3);
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
		trace("update return");
	}
	
    /*private function onBackToMain(e:Event) : Void
    {
        if (backToMain.messageAvailable)
        {
            var workerMessage:WorkerMessage = backToMain.receive();
            if (workerMessage == null) return;
            
            trace("receive = " + workerMessage.name);
            if (workerMessage.name == MessageType.UPDATE)
            {
                
            }
			if (workerMessage.name == MessageType.UPDATE_RETURN)
            {
				trace("update return");
			}
        }
    }*/
}