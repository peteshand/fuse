package kea2.pool;
import kea2.pool.ObjectPool;
import kea2.worker.thread.display.WorkerDisplay;

/**
 * ...
 * @author P.J.Shand
 */
class Pool
{
	static var workerDisplay:ObjectPool<WorkerDisplay>;
	
	static function __init__():Void
	{
		workerDisplay = new ObjectPool<WorkerDisplay>(WorkerDisplay, 100);
	}
	
	public function new() 
	{
		
	}
	
}