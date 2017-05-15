package kea.worker;

import flash.events.Event;
import flash.system.MessageChannel;
import flash.system.Worker;
import openfl.Lib;
import kea.worker.data.MessageType;
import kea.worker.data.WorkerMessage;
import kea.worker.data.WorkerPayload;
import kea.worker.data.WorkerSharedProperties;
import flash.system.WorkerDomain;
/**
 * ...
 * @author P.J.Shand
 */
class WorkerComms
{
	public var worker:Worker;
    private var mainToBack:MessageChannel;
    private var backToMain:MessageChannel;
	private var callbacks = new Map<String, Array<WorkerPayload -> Void>>();
	private var receiveMessageChannel:MessageChannel;
	private var sendMessageChannel:MessageChannel;
	
	public function new() 
	{
		if (Worker.current.isPrimordial) {
			worker = WorkerDomain.current.createWorker(Lib.current.stage.loaderInfo.bytes);
			mainToBack = Worker.current.createMessageChannel(worker);
			backToMain = worker.createMessageChannel(Worker.current);
			
			receiveMessageChannel = backToMain;
			sendMessageChannel = mainToBack;
			
			backToMain.addEventListener(Event.CHANNEL_MESSAGE, onMessageReceived, false, 0, true);
			worker.setSharedProperty(WorkerSharedProperties.BACK_TO_MAIN, backToMain);
			worker.setSharedProperty(WorkerSharedProperties.MAIN_TO_BACK, mainToBack);
			worker.start();
		}
		else {
			worker = Worker.current;
			backToMain = worker.getSharedProperty(WorkerSharedProperties.BACK_TO_MAIN);
			mainToBack = worker.getSharedProperty(WorkerSharedProperties.MAIN_TO_BACK);
			
			receiveMessageChannel = mainToBack;
			sendMessageChannel = backToMain;
			
			mainToBack.addEventListener(Event.CHANNEL_MESSAGE, onMessageReceived);
		}
	}
	
	private function onMessageReceived(event:Event) : Void
    {
		if (receiveMessageChannel.messageAvailable)
        {
            var workerMessage:WorkerMessage = receiveMessageChannel.receive();
			if (workerMessage == null) return;
			
			if (callbacks.exists(workerMessage.name)) {
				var c:Array<WorkerPayload -> Void> = callbacks.get(workerMessage.name);
				for (i in 0...c.length) 
				{
					c[i](workerMessage.payload);
				}
			}
        }
    }
	
	public function add(name:String, callback:WorkerPayload -> Void):Void
	{
		if (!callbacks.exists(name)) callbacks.set(name, []);
		callbacks.get(name).push(callback);
	}
	
	public function send(name:String):Void
	{
		//trace("worker send = " + name);
		var workerMessage:WorkerMessage = { name:name };
        sendMessageChannel.send(workerMessage);
	}
}