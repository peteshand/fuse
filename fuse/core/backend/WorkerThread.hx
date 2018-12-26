package fuse.core.backend;

import fuse.core.communication.memory.SharedMemory;
import fuse.core.input.Input;
import fuse.info.WorkerInfo;
import fuse.core.utils.Pool;
import openfl.Lib;

import fuse.core.communication.IWorkerComms;
import fuse.core.communication.WorkerlessComms;
#if air
import fuse.core.communication.WorkerComms;
#end

/**
 * ...
 * @author P.J.Shand
 */

@:access(fuse)
class WorkerThread extends ThreadBase
{
	public function new()
	{	
		super();
	}
	
	public function init():Void
	{
		if (WorkerInfo.isWorkerThread){
			Fuse.current = this;
			
			
		}
		//else {
		//	OnWorkerReady();
		//}
		
		workerSetup = new BackWorkerSetup();
		workerSetup.onReady.add(OnWorkerReady);
		workerSetup.init();
		
		//var input:Input = new Input();
	}
	
	function OnWorkerReady() 
	{
		Pool.init();
	}
}