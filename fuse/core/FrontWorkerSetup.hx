package fuse.core;

import fuse.core.communication.IWorkerComms;
import fuse.core.communication.WorkerlessComms;
#if flash
import fuse.core.communication.WorkerComms;
import flash.system.Worker;
import flash.concurrent.Condition;
import flash.concurrent.Mutex;
#end
import fuse.core.communication.data.conductorData.ConductorData;
import fuse.core.communication.memory.SharedMemory;
import fuse.core.utils.WorkerInfo;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class FrontWorkerSetup extends WorkerSetup
{
	//public static var singleThreadComms:IWorkerComms;
	
	public function new() 
	{
		super();
	}
	
	override public function init():Void
	{
		trace("initWorkerControl");
		#if flash
		condition = new Condition(new Mutex());
		#end
		
		Fuse.current.sharedMemory = new SharedMemory();
		Fuse.current.conductorData = new ConductorData();
		Fuse.current.conductorData.frameIndex = 0;
		
		var workerComm:IWorkerComms = null;
		#if flash
		if (WorkerInfo.usingWorkers) {
			for (i in 0...WorkerInfo.numberOfWorkers) 
			{
				workerComm = new WorkerComms();
				setProperties(workerComm, i);
				addListeners(workerComm);
				workerComms.push(workerComm);
			}
		}
		else {
		#end
			workerStartCount--;
			workerComm = new WorkerlessComms();
			//if (singleThreadComms == null) {
			//	singleThreadComms = workerComm;
			//}
			setProperties(workerComm, 0);
			addListeners(workerComm);
			workerComms.push(workerComm);
		#if flash
		}
		#end
    }
}