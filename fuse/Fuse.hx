package fuse;
import fuse.core.ThreadBase;
import fuse.core.backend.WorkerThread;
import fuse.core.front.FuseConfig;
import fuse.core.front.MainThread;
import fuse.core.messenger.MessageManager;
import fuse.core.utils.WorkerInfo;
import fuse.display.DisplayObject;
import fuse.display.Stage;
import fuse.events.FuseEvent;
import openfl.display.Stage3D;
import openfl.display3D.Context3DProfile;
import openfl.display3D.Context3DRenderMode;
import openfl.events.EventDispatcher;

/**
 * ...
 * @author P.J.Shand
 */
@:access(fuse)
class Fuse extends EventDispatcher
{
	public static inline var MAX_TEXTURE_SIZE:Int = 2048;
	
	var mainThread:MainThread;
	var workerThread:WorkerThread;
	@:isVar 
	public static var current(default, null):ThreadBase;
	public var stage:Stage;
	
	public function new(rootClass:Class<DisplayObject>, fuseConfig:FuseConfig, stage3D:Stage3D=null, renderMode:Context3DRenderMode = AUTO, profile:Array<Context3DProfile> = null)
	{	
		trace("WorkerInfo.isMainThread = " + WorkerInfo.isMainThread);
		trace("WorkerInfo.isCoreThread = " + WorkerInfo.isCoreThread);
		trace("profile = " + profile);
		
		MessageManager.init();
		
		if (WorkerInfo.isMainThread) {
			mainThread = new MainThread(this, rootClass, fuseConfig, stage3D, renderMode, profile);
			mainThread.addEventListener(FuseEvent.ROOT_CREATED, this.dispatchEvent);
			//mainThread.init();
		}
		if (WorkerInfo.isCoreThread) {
			workerThread = new WorkerThread();
			//workerThread.init();
		}
		super();
	}
	
	public function init():Void
	{
		if (WorkerInfo.isMainThread) {
			mainThread.init();
		}
		if (WorkerInfo.isCoreThread) {
			workerThread.init();
		}
	}
	
	public function start():Void
	{
		
		mainThread.start();
	}
	
	public function stop():Void
	{
		mainThread.stop();
	}
	
	public function process() 
	{
		mainThread.process();
	}
	
	static public function useWorker():Bool 
	{
		WorkerInfo.numberOfWorkers = 1;
		if (WorkerInfo.isWorkerThread) {
			var fuse:Fuse = new Fuse(null, null, null);
			fuse.init();
			return true;
		}
		
		return false;
	}
}