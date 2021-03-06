package fuse.core.backend;

import flash.display.Sprite;
import fuse.core.WorkerSetup;
import fuse.core.communication.data.conductorData.WorkerConductorData;
import fuse.core.communication.IWorkerComms;
import fuse.core.communication.data.MessageType;
import fuse.core.communication.data.WorkerSharedProperties;
import fuse.info.WorkerInfo;
import signals.Signal;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.TimerEvent;
import openfl.utils.Endian;
import openfl.utils.Timer;
#if flash
import flash.concurrent.Condition;
#else
import openfl.concurrent.Condition;
#end

/**
 * ...
 * @author P.J.Shand
 */
class Conductor {
	public static var threadActive(get, null):Bool;
	static public var onTick:Signal;
	static public var waitCount:Int;
	// static var conductorData:ConductorData;
	static var index:Int;
	static var usingWorkers:Bool;
	static private var workerComms:IWorkerComms;
	static var condition:Condition;
	static var isActiveWorker:Bool = false;
	static private var numberOfWorkers:Int;
	public static var conductorData:WorkerConductorData;
	static var update:Sprite = new Sprite();

	public static function init(workerComms:IWorkerComms, index:Int, numberOfWorkers:Int, usingWorkers:Bool) {
		Conductor.numberOfWorkers = numberOfWorkers;
		Conductor.workerComms = workerComms;
		Conductor.index = index;
		// Conductor.conductorData = workerComms.getSharedProperty(WorkerSharedProperties.CONDUCTOR_DATA);
		Conductor.condition = workerComms.getSharedProperty(WorkerSharedProperties.CONDITION);
		Conductor.usingWorkers = usingWorkers;
		// conductorData.endian = Endian.LITTLE_ENDIAN;

		conductorData = new WorkerConductorData();
		/*trace("index = " + index);
			if (index == 0) {
				trace("lock");
				isActiveWorker = true;
				condition.mutex.lock();
		}*/

		onTick = new Signal();
		// workerComms.addListener(MessageType.MAIN_THREAD_TICK, OnMainTick);
		update.addEventListener(Event.ENTER_FRAME, OnUpdate);

		/*var timer:Timer = new Timer(1, 0);
			timer.addEventListener(TimerEvent.TIMER, OnTick);
			timer.start(); */

		// new SetIntervalTimer(Interval, 1, true, []);

		// var id:Int = untyped __global__["flash.utils.setInterval"](Interval,1);
	}

	static private function Interval() {
		trace("Interval");
	}

	static private function OnTick(e:TimerEvent):Void {
		trace("OnTick");
	}

	static private function OnMainTick(e:Event):Void {
		// trace("OnMainTick");

		if (WorkerInfo.usingWorkers) {
			// trace("WORKER LOCK");
			Conductor.condition.mutex.lock();
		}
		// conductorData.frameIndex++;
		trace("onTick");
		onTick.dispatch();
		// conductorData.index = -1;

		if (WorkerInfo.usingWorkers) {
			Conductor.condition.notify();
			// trace("WORKER UNLOCK");
			Conductor.condition.mutex.unlock();
		}

		// trace("conductorData.frameIndex = " + conductorData.frameIndex);
		// trace(conductorData.frameIndex % numberOfWorkers == index);
		// onTick.dispatch();

		// conductorData.processIndex++;
		// trace(conductorData.processIndex);
	}

	static private function OnUpdate(e:Event):Void {
		#if air
		// trace([Conductor.index, "threadActive = " + Conductor.threadActive]);

		if (WorkerInfo.usingWorkers) {
			if (Conductor.threadActive) {
				// trace("WORKER LOCK");
				Conductor.condition.mutex.lock();

				// conductorData.frameIndex++;
				onTick.dispatch();
				// conductorData.index = -1;

				Conductor.condition.notifyAll();
				// trace("WORKER UNLOCK");
				Conductor.condition.wait();
				Conductor.condition.mutex.unlock();
			}
		} else {
			onTick.dispatch();
		}
		#else
		onTick.dispatch();
		#end

		// trace("frameIndex = " + conductorData.frameIndex);
		// trace("OnMainTick: " + index + ", isActiveWorker = " + isActiveWorker);
		// if (!isActiveWorker) {
		// isActiveWorker = condition.mutex.tryLock();
		// trace("tryLock: " + index + ", isActiveWorker = " + isActiveWorker);
		// }
		// if (isActiveWorker) {
		////if (Conductor.threadActive) {
		// onTick.dispatch();
		// conductorData.index = -1;
		// }
		//
		// if (isActiveWorker) {
		// trace("Release index = " + index);
		// isActiveWorker = false;
		// condition.notifyAll();
		// condition.wait();
		// }
	}

	static function get_threadActive():Bool {
		if (conductorData.frameIndex % Conductor.numberOfWorkers == index)
			return true;
		return false;
	}
}
