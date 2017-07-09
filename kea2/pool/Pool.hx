package kea2.pool;
import kea2.pool.ObjectPool;
import kea2.worker.thread.display.WorkerDisplay;
import kea2.worker.thread.layerCache.groups.StaticLayerGroup;

/**
 * ...
 * @author P.J.Shand
 */
class Pool
{
	public static var workerDisplay:ObjectPool<WorkerDisplay>;
	public static var staticLayerGroup:ObjectPool<StaticLayerGroup>;
	
	static function __init__():Void
	{
		workerDisplay = new ObjectPool<WorkerDisplay>(WorkerDisplay, 100, [null]);
		staticLayerGroup = new ObjectPool<StaticLayerGroup>(StaticLayerGroup, 100, []);
	}
	
	public function new() 
	{
		
	}
	
}