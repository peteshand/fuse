#if !flash
package openfl.system;
import openfl.utils.ByteArray;

/**
 * ...
 * @author P.J.Shand
 */
class WorkerDomain
{
	static public var current:WorkerDomain;
	
	static function __init__():Void
	{
		current = new WorkerDomain();
	}
	
	public function new() 
	{
		
	}
	
	public function createWorker(bytes:ByteArray):Worker
	{
		return null;
	}
	
}
#end