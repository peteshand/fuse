package fuse.core.communication;

import flash.events.Event;
import flash.system.MessageChannel;
import flash.system.Worker;
import flash.system.WorkerDomain;
import fuse.core.utils.WorkerInfo;
import openfl.Lib;
import fuse.core.communication.data.MessageType;
import fuse.core.communication.data.WorkerMessage;
import fuse.core.communication.messageData.WorkerPayload;
import fuse.core.communication.data.WorkerSharedProperties;
import openfl.display.Sprite;

/**
 * ...
 * @author P.J.Shand
 */
@:dox(hide)
class WorkerComms implements IWorkerComms
{
	public var usingWorkers:Bool = true;
	private var worker:Worker;
    private var mainToBack:MessageChannel;
    private var backToMain:MessageChannel;
	private var callbacks = new Map<String, Array<WorkerPayload -> Void>>();
	private var receiveMessageChannel:MessageChannel;
	private var sendMessageChannel:MessageChannel;
	
	var que:Array<WorkerMessage> = [];
	var sprite:Sprite = new Sprite();
	
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
		
		sprite.addEventListener(Event.ENTER_FRAME, Update);
	}
	
	private function Update(e:Event):Void 
	{
		if (que.length > 0) {
			
			//var workerMessage:WorkerMessage = { name:name, payload:workerPayload };
			//sendMessageChannel.send(workerMessage);
			//trace(que);
			sendMessageChannel.send(que);
			
			que = [];
		}
	}
	
	private function onMessageReceived(event:Event) : Void
    {
		if (receiveMessageChannel.messageAvailable)
        {
            var workerMessages:Array<WorkerMessage> = receiveMessageChannel.receive();
			if (workerMessages == null) return;
			for (workerMessage in workerMessages) 
			{
				if (callbacks.exists(workerMessage.name)) {
					var c:Array<WorkerPayload -> Void> = callbacks.get(workerMessage.name);
					for (i in 0...c.length) 
					{
						c[i](workerMessage.payload);
					}
				}
			}
        }
    }
	
	public function addListener(name:String, callback:WorkerPayload -> Void):Void
	{
		if (!callbacks.exists(name)) callbacks.set(name, []);
		callbacks.get(name).push(callback);
	}
	
	public function send(name:String, payload:WorkerPayload=null):Void
	{
		//trace("worker send = " + name);
		que.push( { name:name, payload:payload } );
	}
	
	public function getSharedProperty(key:String):Dynamic
	{
		return worker.getSharedProperty(key);
	}
	
	public function setSharedProperty(key:String, value:Dynamic):Void
	{
		worker.setSharedProperty(key, value);
	}
}