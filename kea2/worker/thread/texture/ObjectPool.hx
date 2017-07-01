package kea2.worker.thread.texture;
import kea2.worker.thread.display.WorkerDisplay;

/**
 * ...
 * @author P.J.Shand
 */
class ObjectPool
{
	static var pool:Array<WorkerDisplay> = [];
	
	public function new() { }
	
	public static function initialize(initialPoolSize:Int) 
	{
		for (i in 0...initialPoolSize) 
		{
			pool.push(Type.createInstance(WorkerDisplay, [null]));
		}
	}
	
	public static function request():WorkerDisplay
	{
		if (pool.length == 0) pool.push(Type.createInstance(WorkerDisplay, [null]));
		return pool.shift();
	}
	
	public static function release(workerDisplay:WorkerDisplay):Void
	{
		pool.push(workerDisplay);
	}
}