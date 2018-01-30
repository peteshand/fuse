package fuse.info;

#if air
import flash.system.Worker;
#end

/**
 * ...
 * @author P.J.Shand
 */
class WorkerInfo
{
	static var numberOfWorkers:Int = 0;
	
	public static var isMainThread(get, null):Bool;
	public static var isCoreThread(get, null):Bool;
	public static var isWorkerThread(get, null):Bool;
	public static var usingWorkers(get, null):Bool;
	public static var workersAvailable(get, null):Bool;
	static var isPrimordial(get, null):Bool;
	
	public function new() 
	{
		
	}
	
	inline static function get_isMainThread():Bool 
	{
		if (workersAvailable) return isPrimordial;
		else return true;
	}
	
	inline static function get_isCoreThread():Bool 
	{
		if (workersAvailable) {
			if (WorkerInfo.numberOfWorkers == 0) return true;
			return isPrimordial == false;
		}
		else return true;
	}
	
	inline static function get_isWorkerThread():Bool 
	{
		return isPrimordial == false;
	}
	
	inline static function get_usingWorkers():Bool 
	{
		if (workersAvailable && numberOfWorkers > 0) return true;
		return false;
	}
	
	inline static function get_workersAvailable():Bool 
	{
		#if air
			return true;
		#else
			return false;
		#end
	}
	
	inline static function get_isPrimordial():Bool 
	{
		#if air
			return Worker.current.isPrimordial;
		#else
			return true;
		#end
	}
}