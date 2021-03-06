package fuse.core;

import fuse.core.backend.CoreEntryPoint;
import fuse.info.WorkerInfo;
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
class BackWorkerSetup extends WorkerSetup {
	public function new() {
		super();
	}

	override public function init():Void {
		var workerComms:IWorkerComms = null;
		#if air
		if (WorkerInfo.usingWorkers) {
			workerComms = new WorkerComms();
		} else {
			workerComms = new WorkerlessComms();
		}
		#else
		workerComms = new WorkerlessComms();
		#end
		new CoreEntryPoint(workerComms, WorkerInfo.numberOfWorkers);
		onReady.dispatch();
	}
}
