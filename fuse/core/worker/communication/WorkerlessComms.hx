package fuse.core.worker.communication;
import fuse.core.worker.data.WorkerPayload;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerlessComms implements IWorkerComms
{
	public var usingWorkers:Bool = false;
	var properties:Map<String, Dynamic>;
	var listeners:Map<String, Array<WorkerPayload-> Void>>;
	
	public function new() 
	{
		properties = new Map<String, Dynamic>();
		listeners = new Map<String, Array<WorkerPayload-> Void>>();
	}
	
	public function addListener(name:String, callback:WorkerPayload-> Void):Void 
	{
		if (!listeners.exists(name)) listeners.set(name, []);
		listeners.get(name).push(callback);
	}
	
	public function send(name:String, payload:WorkerPayload = null):Void 
	{
		if (listeners.exists(name)) {
			var callbacks:Array<WorkerPayload-> Void> = listeners.get(name);
			for (callback in callbacks) callback(payload);
		}
	}
	
	public function getSharedProperty(key:String):Dynamic 
	{
		return properties.get(key);
	}
	
	public function setSharedProperty(key:String, value:Dynamic):Void 
	{
		properties.set(key, value);
	}
}